//
//  NCBTransferInfoSavingTableViewCell.swift
//  NCBApp
//
//  Created by Van Dong on 26/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBTransferInfoSavingTableViewCell: UITableViewCell {

    @IBOutlet weak var lbContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbContent.font = italicFont(size: 12)
        lbContent.textColor = UIColor(hexString: "0083DC")
    }
    
}
