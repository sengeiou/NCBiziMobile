//
//  NCBBankListTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 4/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBBankListTableViewCell: NCBBaseTableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbSection: UILabel!
    @IBOutlet weak var lbBankName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbBankName.font = semiboldFont(size: 14)
        lbBankName.textColor = ColorName.blackText.color
        
        lbSection.font = semiboldFont(size: 11)
        lbSection.textColor = UIColor(hexString: "797979")
    }
    
}
