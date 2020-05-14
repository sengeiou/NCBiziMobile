//
//  NCBDFDatePickerView.swift
//  NCBApp
//
//  Created by Thuan on 9/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import RSDayFlow

class NCBDFDatePickerView: RSDFDatePickerView {
    
    override func dayCellClass() -> AnyClass {
        return NCBDFDatePickerDayCell.self
    }
    
}
