//
//  NCBVerifyTransactionGeneralInfoTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 8/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBVerifyTransactionGeneralInfoTableViewCell: NCBBaseTableViewCell {

    @IBOutlet weak var lbContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbContent.font = regularFont(size: 12)
        lbContent.textColor = ColorName.blackText.color
    }
    
}
