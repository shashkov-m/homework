//
//  NewsfeedTableViewController.swift
//  HomeWorkApp
//
//  Created by 18261451 on 22.06.2021.
//

import UIKit
import RealmSwift
import SDWebImage
class NewsfeedTableViewController: UITableViewController {
    
    var news:Results<NewsfeedRealmEntuty>?
    var token:NotificationToken?
    let queue = DispatchQueue (label: "NewsFeedCellQueue", qos: .userInteractive, attributes: .concurrent)
    var realm = try? Realm ()
    let cache = NSCache <NSString, UIImage> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            realm = try Realm ()
            news = realm?.objects(NewsfeedRealmEntuty.self)
        } catch {
            print (error.localizedDescription)
        }
        token = news?.observe {[weak self] changes in
            switch changes {
            case .initial:
                self?.tableView.reloadData()
            case .update(_, deletions: _, insertions: _, modifications: _):
                self?.tableView.reloadData()
            case .error(let error):
                print (error.localizedDescription)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // guard let userNews = news else {return UITableViewCell ()}
       // let news = userNews [indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsfeedTableViewCell", for: indexPath) as! NewsfeedUITableViewCell
        cell.backgroundColor = .black
        cell.layer.backgroundColor = UIColor.black.cgColor
        print (cell)
        return cell
    }
}
