//
//  SearchViewController.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 02.03.2021.
//

import UIKit
class FriendsTableViewController: UITableViewController {
    let friendsRequest = FriendsRequest()
    let albumRequest = AlbumRequest()
    var user_id:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        friendsRequest.getFriendsList()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //userNameChar.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsRequest.friendsList.count //sortedUserDictionary [section].value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath)
        let user = friendsRequest.friendsList[indexPath.row] //sortedUserDictionary[indexPath.section].value [indexPath.row]
//        let paragraphStyle = NSMutableParagraphStyle()
 //       paragraphStyle.firstLineHeadIndent = 55
 //       let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        cell.textLabel?.numberOfLines = user.city != "" ? 2 : 1
        let text = user.city != "" ? "\(user.name)\n\(user.city)" : "\(user.name)"
        cell.textLabel?.text = text
        cell.imageView?.image = user.photo
        cell.imageView?.layer.cornerRadius = 25
        cell.imageView?.layer.masksToBounds = true
 //       cell.textLabel?.attributedText = NSAttributedString (string: text, attributes: attributes)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = friendsRequest.friendsList[indexPath.row]
        user_id = user.id
        performSegue(withIdentifier: "toAlbums", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! CustomHeaderView
//        let char = userNameChar [section]
//        header.textLabel?.text = String(char)
//        header.tintColor = .systemGray5
//        return header
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlbums",
           let albumsVC = segue.destination as? AlbumsCollectionViewController {
            albumsVC.user_id = user_id            
        }
    }
}
