//
//  UserTableViewCell.swift
//  dev-chat
//
//  Created by Ryan Huebert on 10/20/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var firstNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setCheckmark(selected: false)
    }
    
    func setCheckmark(selected: Bool) {
        let imageStr = selected ? "messageindicatorchecked1" : "messageindicator1"
        self.accessoryView = UIImageView(image: UIImage(named: imageStr))
    }
    
    func updateUI(user: User) {
        firstNameLabel.text = user.firstName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
