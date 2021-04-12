//
//  SearchViewController.swift
//  TechnicalTask
//
//  Created by Viacheslav Markov on 12.04.2021.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var listVideos: [String] = []
    lazy var searchListVideos: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        searchListVideos = listVideos
        
    }

}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchListVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = searchListVideos[indexPath.row]
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchListVideos = listVideos
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchListVideos = searchText == "" ? listVideos : listVideos.filter { $0.contains(searchText) }
        listTableView.reloadData()
    }
}
