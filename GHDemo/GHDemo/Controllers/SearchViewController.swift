//
//  SearchViewController.swift
//  GHDemo
//
//  Created by user on 14/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {

    @IBOutlet weak var tableResult: UITableView!
    
    var searchController: UISearchController? = UISearchController(searchResultsController: nil)
    var url: String?
    var repositories: [Repository] = []
    var filteredRepositories: [Repository] = []
    var showPreviousSearchResults: Bool = true
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupSearchController()
        setupNavigationItem()
        resetSearch()
        tableResult.tableFooterView = UIView()
        
        // fetch all the repositories for given search
        repositoriesWebService()
    }
    
    //MARK: Repositories Web Service
    func repositoriesWebService(_ page: Int = 1) {
        guard let url = self.url else { return }
        let rest = RestManager<[Repository]>()
        rest.makeRequest(toURL: "\(url)?page=\(page)", withHttpMethod: .get) { [weak self]  (result) in
            switch result {
            case .success(let repositories):
                self?.repositories.append(contentsOf: repositories)
                if repositories.count >= 30 {
                    self?.repositoriesWebService(page + 1)
                }
            case .failure(let error):
                self?.view.makeToast(error.description)
            }
        }
    }
    
    // setup navigation item
    private func setupNavigationItem() {
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    // setup search view controller
    private func setupSearchController() {
        searchController?.searchBar.placeholder = "Search Repository"
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.delegate = self
        searchController?.isActive = true
    }
    
    // rest search results and update ui
    private func resetSearch() {
        showPreviousSearchResults = true
        filteredRepositories = SearchManager.instance.results
        tableResult.reloadData()
    }
    
    // back button action
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        searchController?.isActive = false
        searchController = nil
        navigationController?.popViewController(animated: false)
    }
}


//MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resetSearch()
        } else {
            let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchBar.text!);
            filteredRepositories = repositories.filter{searchPredicate.evaluate(with: $0.full_name)}
            showPreviousSearchResults = false
            tableResult.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetSearch()
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRepositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = filteredRepositories[indexPath.row].full_name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.textColor = showPreviousSearchResults ? .gray : .black
        cell.accessoryView = showPreviousSearchResults ? UIImageView(image: #imageLiteral(resourceName: "diagonal_arrow")) : nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // save selected search result
        let searchResult = filteredRepositories[indexPath.row]
        SearchManager.instance.append(searchResult)
        
        // cell selection animation
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
        // push to detail view controller
        let controller = DetailViewController.initiate(with: .Home)
        controller.repo_name = filteredRepositories[indexPath.row].full_name
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
}
