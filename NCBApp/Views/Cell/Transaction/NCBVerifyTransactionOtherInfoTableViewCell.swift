//
//  NCBVerifyTransactionOtherInfoTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 7/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBVerifyTransactionOtherInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbTitle.font = regularFont(size: 12)
        lbTitle.textColor = ColorName.blackText.color
        
        lbValue.font = semiboldFont(size: 14)
        lbValue.textColor = ColorName.blackText.color
    }
    
}
