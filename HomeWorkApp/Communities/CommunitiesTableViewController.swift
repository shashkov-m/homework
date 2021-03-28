//
//  CommunitiesTableViewController.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 07.03.2021.
//

import UIKit

class CommunitiesTableViewController: UITableViewController {
    
    var userCommunities: [CommunityModel] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userCommunities.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCommunityCell", for: indexPath)

        // Configure the cell...
        let favoriteCommunity = userCommunities [indexPath.row]
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = "\(favoriteCommunity.communityName)\n\(favoriteCommunity.communityType)"
        return cell
    }
    
    @IBAction func addCommunity (segue: UIStoryboardSegue) {
        if segue.identifier == "exitCommunity",
                  let sourceVC = segue.source as? AllCommunitiesTableViewController,
                  let selectedCommunity = sourceVC.selectedCommunity {
            guard !userCommunities.contains(selectedCommunity) else {
                let alert = UIAlertController (title: "", message: "You already have the \(selectedCommunity.communityName) community", preferredStyle: .alert)
                let action = UIAlertAction (title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return
            }
            userCommunities.append(selectedCommunity)
            tableView.reloadData()
        }
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            userCommunities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
