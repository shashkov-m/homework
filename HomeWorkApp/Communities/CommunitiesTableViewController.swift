//
//  CommunitiesTableViewController.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 07.03.2021.
//

import UIKit

class CommunitiesTableViewController: UITableViewController {
    let communitiesRequest = CommunitiesRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        communitiesRequest.getGroupsList()
        DispatchQueue.main.asyncAfter (deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return communitiesRequest.groupsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCommunityCell", for: indexPath)

        // Configure the cell...
        let community = communitiesRequest.groupsList[indexPath.row]
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = "\(community.name)\n\(community.type)"
        cell.textLabel?.font = .systemFont(ofSize: 16)
        cell.imageView?.image = community.photo
        cell.imageView?.layer.cornerRadius = 25
        cell.imageView?.layer.masksToBounds = true
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
