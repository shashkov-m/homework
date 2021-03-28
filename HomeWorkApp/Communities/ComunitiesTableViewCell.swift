//
//  ComunitiesTableViewCell.swift
//  HomeWorkApp
//
//  Created by Шашков Максим Алексеевич on 08.03.2021.
//

import UIKit

class ComunitiesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = ""
    }

}
