//
//  NCBVerifyTransferTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBVerifyTransferTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbTitle.font = regularFont(size: 15)
        lbValue.font = boldFont(size: 15)
    }
    
}
