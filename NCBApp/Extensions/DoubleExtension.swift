//
//  DoubleExtension.swift
//  NCBApp
//
//  Created by Thuan on 4/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

extension Double {
    
    var formattedWithDotSeparator: String {
        return Formatter.withDotSeparator.string(from: NSNumber(value: self)) ?? ""
    }
    
    var currencyFormatted: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.groupingSeparator = ","
        currencyFormatter.numberStyle = .decimal
        
        return (currencyFormatter.string(from: NSNumber.init(value: self)) ?? "") + " VND"
    }
    
    var asWord: String {
        let numberValue = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.numberStyle = .spellOut
        return formatter.string(from: numberValue) ?? ""
    }
    
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
    
}
