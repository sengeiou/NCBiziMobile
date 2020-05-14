//
//  NCBDetailSavingAccountCell.swift
//  NCBApp
//
//  Created by Tuan Pham Hai  on 8/29/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBDetailSavingAccountCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    
    @IBOutlet weak var lbTitle2: UILabel!
    @IBOutlet weak var lbValue2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbTitle.font = regularFont(size: 12)
        lbTitle.textColor = UIColor.white
        
        lbValue.font = semiboldFont(size: 14)
        lbValue.textColor = UIColor.white
        
        lbTitle2.font = regularFont(size: 12)
        lbTitle2.textColor = UIColor.white
        
        lbValue2.font = semiboldFont(size: 14)
        lbValue2.textColor = UIColor.white
    }
}
