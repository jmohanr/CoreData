//
//  ContactDetailViewController.swift
//  ContactsApplication
//
//  Created by jagan on 6/01/18.
//  Copyright © 2017 jagan. All rights reserved.
//

import UIKit
import CoreData

class ContactDetailViewController: UIViewController {
    //MARK:- Objects Decleration
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    var contact: NSManagedObject? = nil
    var isDeleted: Bool = false
    var indexPath: IndexPath? = nil

    //MARK:- ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = contact?.value(forKey:"name") as? String
        phoneLabel.text = contact?.value(forKey:"phoneNumber") as? String
        emailLabel.text = contact?.value(forKey:"emailId") as? String
        countryCode.text = contact?.value(forKey:"countryCoude") as? String
        profilePic.image = UIImage(data: contact?.value(forKey: "image") as! Data)
        profilePic.layer.cornerRadius = profilePic.frame.width/2
        profilePic.layer.masksToBounds = true
    }

    //MARK: - Navigation
    @IBAction func done(_ sender: Any) {
        performSegue(withIdentifier: "unwindToContactList", sender: self)
    }
    
    @IBAction func deleteContact(_ sender: Any) {
        isDeleted = true
        performSegue(withIdentifier: "unwindToContactList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            guard let viewController = segue.destination as? AddContactViewController else { return }
            viewController.titleText = "Edit Contact"
            viewController.contact = contact
            viewController.indexPathForContact = self.indexPath!
        }
    }
    
}
