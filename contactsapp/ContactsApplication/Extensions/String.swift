//
//  String.swift
//  ContactsApplication
//
//  Created by Ammulu on 06/01/18.
//  Copyright © 2018 Kyle Melton. All rights reserved.
//

import Foundation
extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    static func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailVerify = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailVerify.evaluate(with: emailID)
    }
    var length: Int {
        return self.characters.count
    }
}
    
