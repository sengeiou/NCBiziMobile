//
//  NCBCreditCardDetailTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 7/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBCreditCardDetailTableViewCell: NCBBaseTableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbTitle.font = regularFont(size: 12)
        lbTitle.textColor = UIColor.white
        
        lbValue.font = semiboldFont(size: 14)
        lbValue.textColor = UIColor.white
    }
    
}
