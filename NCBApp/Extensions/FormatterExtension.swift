//
//  FormatterExtension.swift
//  NCBApp
//
//  Created by Thuan on 4/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

extension Formatter {
    
    static let withDotSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
    
}
