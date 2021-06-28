//
//  DefaultTableViewCell.swift
//  HomeWorkApp
//
//  Created by 18261451 on 26.06.2021.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {

    @IBOutlet weak var postLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        postLabel.text = nil
    }
}
