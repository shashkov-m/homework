//
//  SearchViewController.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 02.03.2021.
//

import UIKit
class FriendsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")

    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return userNameChar.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedUserDictionary [section].value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath)
        let user = sortedUserDictionary[indexPath.section].value [indexPath.row]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 60
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        cell.textLabel?.numberOfLines = 2
        let text = "\(user.userName)\n\(user.userCity)"
        cell.textLabel?.text = text
        cell.textLabel?.attributedText = NSAttributedString (string: text, attributes: attributes)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! CustomHeaderView
        let char = userNameChar [section]
        header.textLabel?.text = String(char)
        header.tintColor = .systemGray5
        return header
    }
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let char = userNameChar [section]
//        return "\(char)"
//    }
}
