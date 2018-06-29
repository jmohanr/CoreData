//
//  SPURTextField.swift
//  Spur_iOS
//
//  Created by Manish_Office on 9/12/17.
//  Copyright © 2017 indutech-labs. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setBottomLine(borderColor: UIColor) {
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear

        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
    

   
 
    
}
