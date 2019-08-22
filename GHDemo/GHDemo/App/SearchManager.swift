//
//  SearchedResults.swift
//  GHDemo
//
//  Created by user on 21/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

/*Search Manager is singelton class use to save and get all previously search results*/
/*all the repository resuts are stored in userdefaults*/

class SearchManager {
    
    static let key = "search"
    static let instance = SearchManager()
    
    // stored property with setter and getter methods
    var results: [Repository] {
        set {
            save(newValue)
        } get {
            return fetch()
        }
    }
    
    // call this method to add searched result into array
    func append(_ newElement: Repository) {
        if results.contains(where: { $0.id == newElement.id }) {
            if let index = SearchManager.instance.results.firstIndex(where: { $0.id == newElement.id }) {
                SearchManager.instance.results.remove(at: index)
                SearchManager.instance.results.append(newElement)
            }
        } else {
            SearchManager.instance.results.append(newElement)
        }
    }
    
    // updates searched result array
    private func save(_ results: [Repository]) {
        let encode = try? JSONEncoder().encode(results.reversed())
        UserDefaults.standard.set(encode, forKey: SearchManager.key)
    }
    
    // fetch searched results
    private func fetch() -> [Repository] {
        if let data = UserDefaults.standard.value(forKey: SearchManager.key) as? Data {
            let results = try? JSONDecoder().decode([Repository].self, from: data)
            return results ?? []
        }
        return []
    }
}
