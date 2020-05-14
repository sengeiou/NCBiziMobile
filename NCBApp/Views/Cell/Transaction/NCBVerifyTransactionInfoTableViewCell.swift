//
//  NCBVerifyTransactionInfoTableViewCell.swift
//  NCBApp
//
//  Created by Van Dong on 27/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBVerifyTransactionInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var tittleLb1: UILabel!
    @IBOutlet weak var accountNo1: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var tittleLb2: UILabel!
    @IBOutlet weak var accountNo2: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tittleLb1.font = regularFont(size: 12)
        tittleLb1.textColor = ColorName.blackText.color
        
        accountNo1.font = semiboldFont(size: 14)
        accountNo1.textColor = ColorName.blackText.color
        
        label1.font = regularFont(size: 12)
        label1.textColor = ColorName.holderText.color
        
        tittleLb2.font = regularFont(size: 12)
        tittleLb2.textColor = ColorName.blackText.color
        
        accountNo2.font = semiboldFont(size: 14)
        accountNo2.textColor = ColorName.blackText.color
        
        label2.font = regularFont(size: 12)
        label2.textColor = ColorName.holderText.color
        
        label3.font = regularFont(size: 12)
        label3.textColor = ColorName.holderText.color
        
    }
    
}
