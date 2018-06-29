//
//  CountriesTableViewCell.swift
//  ContactsApplication
//
//  Created by Ammulu on 08/01/18.
//  Copyright © 2018 Kyle Melton. All rights reserved.
//

import UIKit

class CountriesTableViewCell: UITableViewCell {
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    class var identifier: String { return String.className(self) }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
