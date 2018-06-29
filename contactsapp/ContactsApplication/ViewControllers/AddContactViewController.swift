//
//  AddContactViewController.swift
//  ContactsApplication
//
//  Created by jagan on 6/01/18.
//  Copyright © 2017 jagan. All rights reserved.
//

import UIKit
import CoreData

class AddContactViewController: UIViewController {
    //MARK:- Objects Decleration
    var titleText = "Add Contact"
    var contact: NSManagedObject? = nil
    var indexPathForContact: IndexPath? = nil
    let limitLength = 10
    var country = [CountryList]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countryCode: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        countryCode.inputView = UIView(frame: CGRect.zero)
        self.downloadJSON {
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.setDoneOnKeyboard()
        self.nameTextField.setBottomLine(borderColor: UIColor.gray)
        self.emailTextField.setBottomLine(borderColor: UIColor.gray)
        self.phoneNumberTextField.setBottomLine(borderColor: UIColor.gray)
        self.countryCode.setBottomLine(borderColor: UIColor.gray)
        tableView.isHidden = true
        profilePic.layer.cornerRadius = profilePic.frame.width/2
        profilePic.layer.masksToBounds = true
        let tapProfilePic = UITapGestureRecognizer(target: self, action: #selector(tapProfilePicFunction))
        profilePic.addGestureRecognizer(tapProfilePic)
        profilePic.isUserInteractionEnabled = true
        let tapCountry = UITapGestureRecognizer(target: self, action: #selector(callingApiFunction))
        countryCode.addGestureRecognizer(tapCountry)
        countryCode.isUserInteractionEnabled = true
        titleLabel.text = titleText
        if let contact = self.contact {
            nameTextField.text = contact.value(forKey: "name") as? String
            phoneNumberTextField.text = contact.value(forKey: "phoneNumber") as? String
            emailTextField.text = contact.value(forKey: "emailId") as? String
            profilePic.image = UIImage(data: contact.value(forKey: "image") as! Data)
            countryCode.text = contact.value(forKey: "countryCoude") as? String

        }
    }

    // MARK: - Navigation

    @IBAction func saveAndClose(_ sender: Any) {
        if nameTextField.text == "" || phoneNumberTextField.text == "" ||  emailTextField.text == "" || profilePic.image == nil {
            self.presentingAlert(message: "Please enter all details", alertTitle: "")
        } else {
            let email = emailTextField.text!
            let isValidEmailID = String.isValidEmail(emailID:email )
            if isValidEmailID {
                performSegue(withIdentifier: "unwindToContactList", sender: self)
            } else {
                self.presentingAlert(message: "Please enter proper email", alertTitle: "")
            }
        }
    }
    @IBAction func close(_ sender: Any) {
        nameTextField.text = nil
        phoneNumberTextField.text = nil
        emailTextField.text = nil
        performSegue(withIdentifier: "unwindToContactList", sender: self)
    }
  
}

extension AddContactViewController:UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    func tapProfilePicFunction(sender:UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action:UIAlertAction!) in
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }        }
        
        
        let photo = UIAlertAction(title: "PhotoLibrary", style: .default) { (action:UIAlertAction!) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        alertController.addAction(photo)
        alertController.addAction(camera)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        
        selectedImage = info["UIImagePickerControllerEditedImage"]   as? UIImage
        
        self.profilePic.image =  selectedImage
        
        self.dismiss(animated: true, completion: nil)
        
        }
   }

extension AddContactViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.phoneNumberTextField.inputAccessoryView = keyboardToolbar
    }
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(AddContactViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func presentingAlert(message:String, alertTitle:String) {
        let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
  
}
extension AddContactViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return country.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CountriesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CountriesTableViewCell") as! CountriesTableViewCell
        cell.countryName?.text = country[indexPath.row].name.capitalized
        cell.countryCode.text = country[indexPath.row].alpha2Code.capitalized

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = country[indexPath.row].alpha2Code.capitalized
        countryCode.text = text
        tableView.isHidden = true
    }
    

}
extension AddContactViewController {
    
    func callingApiFunction(sender:UITapGestureRecognizer) {
        tableView.isHidden = false
        
    }
    func downloadJSON(completed: @escaping () -> ()) {
        
        let url = URL(string: "https://restcountries.eu/rest/v1/all")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do {
                    self.country = try JSONDecoder().decode([CountryList].self, from: data!)
                    
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch {
                    print("JSON Error")
                }
            }
            }.resume()
    }
}
