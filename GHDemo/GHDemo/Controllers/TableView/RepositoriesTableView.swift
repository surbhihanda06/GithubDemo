//
//  RepositoriesTableView.swift
//  GHDemo
//
//  Created by user on 22/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class RepositoriesTableView: UITableView {
    
    var repodelegate: RepoTableViewDelegate? = nil
    private var page = 1
    private var loadMore = true
    private var repositories: [Repository] = [] {
        didSet {
            reloadData()
        }
    }
    private var url: String? {
        didSet {
            repositoriesWebService()
        }
    }
    
    // required init method
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerCell()
        configureRefreshControl()
        delegate = self
        dataSource = self
    }
    
    // configure table with url
    func load(with urlString: String) {
        url = urlString
    }
    
    // register cell
    private func registerCell() {
        let nib = UINib(nibName: "RepoCell", bundle: nil)
        register(nib, forCellReuseIdentifier: "cell")
    }
    
    // configure refresh control
    private func configureRefreshControl() {
        refreshControl =  UIRefreshControl()
        refreshControl?.tintColor = .black
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    // refresh list
    @objc private func refresh() {
        page = 1
        repositoriesWebService()
    }
    
    //MARK: Repositories Web Service
    private func repositoriesWebService() {
        
        if let url = self.url {
            let rest = RestManager<[Repository]>()
            rest.makeRequest(toURL: url + "?page=\(page)", withHttpMethod: .get) { [weak self] (result) in
                
                guard let `self` = self else {
                    return
                }
                
                `self`.repodelegate?.didEndLoadingRepositories()
                `self`.refreshControl?.endRefreshing()
                `self`.hideBottomLoader()

                switch result {
                case .success(let repositories):
                    `self`.handleResponse(repositories)
                case .failure(let error):
                    `self`.repodelegate?.didFailedWithError(error)
                    `self`.page = `self`.page == 1 ? 1 : `self`.page - 1
                }
            }
        }
        else {
            print("invalid url")
        }
    }
    
    // handle web service response with pagination
    func handleResponse(_ repositories: [Repository]) {
        if self.page == 1 {
            self.repositories = repositories
        } else {
            self.repositories.append(contentsOf: repositories)
        }
        self.page += 1
        self.loadMore = repositories.count < 30
    }
}

// MARK: Delegate & Data Source 
extension RepositoriesTableView: UITableViewDataSource, UITableViewDelegate {
    
    // number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    // cell for row at indexpath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RepoCell
        cell.configure(repo: repositories[indexPath.row])
        return cell
    }
    
    // will display cell
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 && !loadMore {
            loadMore = true
            repositoriesWebService()
            showBottomLoader()
        }
    }
    
    // did select row at indexpath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
        let repository = repositories[indexPath.row]
        repodelegate?.didSelect(repository)
    }
}

