//
//  ContactsViewController.swift
//  ContactsApplication
//
//  Created by jagan on 6/01/18.
//  Copyright © 2017 jagan. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UITableViewController {
    //MARK:-Objects Decleration
    @IBOutlet var searchBar: UISearchBar!
    var names = [CountryList]()
    var isSearching = false
    var contacts: [NSManagedObject] = []
    var filteredContacts: [NSManagedObject] = []
    var country = [CountryList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.returnKeyType = UIReturnKeyType.done
       tableView.register(UINib(nibName: "ContactListTableViewCell", bundle: nil), forCellReuseIdentifier: ContactListTableViewCell.identifier)
        self.fetchDetailsFormDb()
        tableView.reloadData()
        searchBar.placeholder = "search items"
        searchBar.tintColor = UIColor.blue.withAlphaComponent(0.7)
        searchBar.showsCancelButton = true
        filteredContacts = contacts
    }

    
    //MARK: - Fetching Details From DataBase
    
    func fetchDetailsFormDb() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Contact")
        do {
            contacts = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
    }
    
    //MARK: - Save Details To DataBase
    
    func save(name: String, phoneNumber: String,emailId:String, image:UIImage?,countryCode:String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName:"Contact", in: managedObjectContext) else { return }
        let contact = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        contact.setValue(name, forKey: "name")
        contact.setValue(phoneNumber, forKey: "phoneNumber")
        contact.setValue(emailId, forKey: "emailId")
        contact.setValue(countryCode, forKey: "countryCoude")

        if let img = image {
           contact.setValue(UIImageJPEGRepresentation(img, 0.5), forKey: "image")
        }
        do {
            try managedObjectContext.save()
            self.contacts.append(contact)
        } catch let error as NSError {
            print("Couldn't save. \(error)")
        }
    }
    
    //MARK: - Update Details To DataBase

    func update(indexPath: IndexPath, name:String, phoneNumber: String,emailId:String, image:UIImage?,countryCode:String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let contact = contacts[indexPath.row]
        contact.setValue(name, forKey:"name")
        contact.setValue(phoneNumber, forKey: "phoneNumber")
        contact.setValue(emailId, forKey: "emailId")
        contact.setValue(countryCode, forKey: "countryCoude")

        //countryCoude
        
        if let img = image {
            contact.setValue(UIImageJPEGRepresentation(img, 0.5), forKey: "image")
        }
        do {
            try managedObjectContext.save()
            contacts[indexPath.row] = contact
        } catch let error as NSError {
            print("Couldn't update. \(error)")
        }
    }
    
    //MARK: - Delete Details To DataBase

    func delete(_ contact: NSManagedObject, at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        managedObjectContext.delete(contact)
        contacts.remove(at: indexPath.row)
    }
    @IBAction func unwindToContactList(segue: UIStoryboardSegue) {
        if let viewController = segue.source as? AddContactViewController {
            guard let name: String = viewController.nameTextField.text,let emailId:String = viewController.emailTextField.text ,let phoneNumber: String = viewController.phoneNumberTextField.text, let countryCode: String = viewController.countryCode.text,let profileImage = viewController.profilePic.image else { return }
            if name != "" && phoneNumber != "" {
                if let indexPath = viewController.indexPathForContact {
                    update(indexPath: indexPath, name: name, phoneNumber: phoneNumber, emailId: emailId, image: profileImage, countryCode: countryCode)
                } else {
                    save(name:name, phoneNumber:phoneNumber, emailId: emailId, image: profileImage,countryCode: countryCode)
                }
            }
            tableView.reloadData()
        } else if let viewController = segue.source as? ContactDetailViewController {
            if viewController.isDeleted {
                guard let indexPath: IndexPath = viewController.indexPath else { return }
                let contact = contacts[indexPath.row]
                delete(contact, at: indexPath)
                reloadTableData()
            }
        }
    }
}

//MARK: - TableView Delegate And DataSourceMethods

extension ContactsViewController {
    func reloadTableData() {
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredContacts.count : contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactListTableViewCell.identifier) as! ContactListTableViewCell
        let contact = isSearching ? filteredContacts[indexPath.row] : contacts[indexPath.row]
        cell.nam?.text = contact.value(forKey:"name") as? String
        cell.phone?.text = contact.value(forKey:"phoneNumber") as? String
        cell.img?.image = UIImage(data: contact.value(forKey: "image") as! Data)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController:ContactDetailViewController = UIStoryboard(
            name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let contact = contacts[indexPath.row]
        viewController.contact = contact
        viewController.indexPath = indexPath
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension ContactsViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "name contains[c] '\(searchText)'")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Contact")
            fetchRequest.predicate = predicate
            do {
                contacts = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
        reloadTableData()
    }
    
   
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {// return NO to not resign first responder
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        isSearching = false
        self.searchBar.endEditing(true)
        reloadTableData()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false;
        self.searchBar.endEditing(true)
        reloadTableData()
    }
   
}


