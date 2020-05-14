//
//  NCBDFDatePickerDayCell.swift
//  NCBApp
//
//  Created by Thuan on 9/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import RSDayFlow

class NCBDFDatePickerDayCell: RSDFDatePickerDayCell {
    
    override func selectedTodayImageColor() -> UIColor {
        return UIColor(hexString: "0083DC")
    }
    
    override func selectedDayImageColor() -> UIColor {
        return UIColor(hexString: "0083DC")
    }
    
}
