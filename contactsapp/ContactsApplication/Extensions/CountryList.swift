//
//  CountryList.swift
//  ContactsApplication
//
//  Created by Ammulu on 07/01/18.
//  Copyright © 2018 Kyle Melton. All rights reserved.
//

import Foundation
struct CountryList:Decodable {
    let alpha2Code: String
    let name:String
    let callingCodes:String
   
}
