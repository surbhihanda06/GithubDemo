//
//  RestManager.swift
//  GHDemo
//
//  Created by user on 13/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

struct Response: Codable { }

class RestManager<T: Codable> {
    
    enum Result<T: Codable> {
        case success(T)
        case failure(WebError)
    }
    
    // MARK: - Properties
    var requestHttpHeaders: [String:String] = [:]
    var responseHttpHeaders: [String:String] = [:]
    var response: [String:Any] = [:]
    
    // MARK: - Public Methods
    func makeRequest(toURL url: String, params: [String:Any] = [:],
                     withHttpMethod httpMethod: HttpMethod,
                     completion: @escaping (_ result: Result<T>) -> Void) {
        
        DispatchQueue.global(qos: .background).async {
            
            guard let request = self.prepareRequest(withURL: url, params: params, httpMethod: httpMethod) else {
                completion(Result.failure(.invalidRequest(url)))
                return
            }
            
            /*HTTP REQUEST*/
            /*************************************************/
            print("url: \(url)")
            print("method: \(httpMethod.rawValue)")
            print("HTTPHeaders: \(request.allHTTPHeaderFields ?? [:])")
            print("parameters:\(params)")

            /*************************************************/
            
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    
                    guard let response = response as? HTTPURLResponse else {
                        completion(.failure(.other("response is nil")))
                        return
                    }
                    
                    if let responseHttpHeaders = (response.allHeaderFields.compactMapValues{ $0 }) as? [String:String] {
                        self.responseHttpHeaders = responseHttpHeaders
                    }
                    
                    /*RESPONSE*/
                    /***********************************************/
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)  {
                        print("response: \(json)")
                        if let result = json as? [String:Any] {
                            self.response = result
                        }
                    } else {
                        print("response is empty")
                    }
                    /*************************************************/
                    
                    switch response.statusCode  {
                    case (200..<300):
                        guard let model = Response<T>().parceModel(data: data) else {
                            completion(.failure(WebError.parse))
                            return
                        }
                        completion(.success(model))
                    case (300...600):
                        guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                            completion(.failure(.other((error?.localizedDescription) ?? "internal server error")))
                            return
                        }
                        
                        let message = json["message"] as? String ?? "internal server error"
                        if response.statusCode == 401 {
                            completion(.failure(WebError.unauthorized))
                        } else {
                            completion(.failure(.other(message)))
                        }
                    default:
                        break
                    }
                }
            }
            task.resume()
        }
    }
    
    private func getData(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data else { completion(nil); return }
                completion(data)
            })
            task.resume()
        }
    }
    
    
    // MARK: - Private Methods
    private func setAuthorizationHeader() {
        if let authorization = UserDefaults.standard.authorization_type {
            requestHttpHeaders["authorization"] = authorization
        }
    }
    
    private func prepareRequest(withURL url: String, params: [String:Any], httpMethod: HttpMethod) -> URLRequest? {
        
        guard let url = URL(string: url) else { return nil }
        var urlRequest = URLRequest(url: url) // initialize with url
        urlRequest.httpMethod = httpMethod.rawValue // set http method
        
        /*set http body*/
        switch httpMethod {
        case .post, .put:
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        case .get:
            var queryParameters = "?"
            params.forEach({ (key, value) in
                var stringValue = value as? String
                stringValue = stringValue?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.replacingOccurrences(of: ":", with: "%3A")
                queryParameters += key + "=\(stringValue ?? value)"
                queryParameters += "&"
            })
            queryParameters.removeLast()
            
            let urlString = urlRequest.url!.absoluteString + queryParameters
            urlRequest.url = URL(string: urlString)
        default:
            break
        }
        
        /*set authorization header*/
        setAuthorizationHeader()
        
        for (header, value) in requestHttpHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }
        
        return urlRequest
    }
}


// MARK: - RestManager Custom Types

extension RestManager {
    
    enum HttpMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }    
    
    struct RestEntity {
        
        private var values: [String: String] = [:]
        
        mutating func add(value: String, forKey key: String) {
            values[key] = value
        }
        
        func value(forKey key: String) -> String? {
            return values[key]
        }
        
        func allValues() -> [String: String] {
            return values
        }
        
        func totalItems() -> Int {
            return values.count
        }
    }
    
    fileprivate struct Response<T: Codable> {
        
        func parceModel(data: Data?) -> T? {
            guard let data = data else {
                return nil
            }
            return try? JSONDecoder().decode(T.self, from: data)
        }
    }
}

