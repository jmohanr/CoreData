//
//  ContactListTableViewCell.swift
//  ContactsApplication
//
//  Created by Ammulu on 06/01/18.
//  Copyright © 2018 Kyle Melton. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var nam: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        img.layer.cornerRadius = img.frame.width/2
        img.layer.masksToBounds = true

    }
    class var identifier: String { return String.className(self) }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
