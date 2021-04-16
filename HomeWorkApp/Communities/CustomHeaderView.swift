//
//  CustomHeaderView.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 24.03.2021.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {
    let friendsTableView = FriendsTableViewController ()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContent () {
        //tintColor = .purple
    }
}
