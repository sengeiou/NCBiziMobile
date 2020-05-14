//
//  UILabelExtension.swift
//  NCBApp
//
//  Created by Thuan on 5/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func currencyLabel(with number: Double, and locale: String? = "vi_VN"){
        let currencyFormatter = NumberFormatter()
        currencyFormatter.groupingSeparator = ","
        currencyFormatter.numberStyle = .decimal
        
        self.text = (currencyFormatter.string(from: NSNumber.init(value: number)) ?? "") + " VND"
    }
    
}

