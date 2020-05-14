//
//  DateExtension.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum MonthFromName: String {
    case January
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
    case Other
}

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
}
