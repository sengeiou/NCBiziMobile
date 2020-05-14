//
//  NCBPaymentAccountHistoryDetailTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 7/30/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBPaymentAccountHistoryDetailTableViewCell: NCBBaseTableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbTitle.font = regularFont(size: 10)
        lbTitle.textColor = ColorName.blurNormalText.color
        
        lbValue.font = regularFont(size: 12)
        lbValue.textColor = ColorName.blackText.color
    }
    
}
