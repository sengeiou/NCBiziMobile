//
//  NCBBaseTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 7/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import SwipeCellKit

class NCBBaseTableViewCell: SwipeTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
}
