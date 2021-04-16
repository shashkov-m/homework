//
//  CommunitiesTableViewController.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 07.03.2021.
//

import UIKit

class AllCommunitiesTableViewController: UITableViewController, UISearchBarDelegate {
    
    var selectedCommunity:CommunityModel?
    var filterCommunities:[CommunityModel] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search a community"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterCommunities.count
        }
        return communityList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath)
        let community:CommunityModel
        if isFiltering {
            community = filterCommunities [indexPath.row]
        } else {
            community = communityList [indexPath.row]
        }
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = "\(community.communityName)\n\(community.communityType)"
        cell.imageView?.image = #imageLiteral(resourceName: "com")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isFiltering {
            selectedCommunity = filterCommunities [indexPath.row]
           
        } else {
            selectedCommunity = communityList [indexPath.row]
        }
        searchController.dismiss(animated: false) {
            self.performSegue(withIdentifier: "exitCommunity", sender: self)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard segue.identifier == "exitCommunity" else {return}
//    }
    
    // Добавялем SearchBar
    let searchController = UISearchController(searchResultsController: nil)
    private func setupSearchBar () {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    func filterContentForSearchText(_ searchText: String) {
        filterCommunities = communityList.filter { (community: CommunityModel) -> Bool in
            return community.communityName.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
}

extension AllCommunitiesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    
}
