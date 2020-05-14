//
//  NCBSourceAccountTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 7/15/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBSourceAccountTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var checkbtn: UIButton!
    @IBOutlet weak var lbAccountNumberTitle: UILabel!
    @IBOutlet weak var lbAccountNumberValue: UILabel!
    @IBOutlet weak var lbBalance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        checkbtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
        checkbtn.setImage(R.image.ic_radio_check(), for: .selected)
        
        lbAccountNumberTitle.text = "Tài khoản nguồn"
        lbAccountNumberTitle.font = semiboldFont(size: 14)
        lbAccountNumberTitle.textColor = ColorName.blurNormalText.color
        
        lbAccountNumberValue.font = regularFont(size: 12)
        lbAccountNumberValue.textColor = ColorName.holderText.color
        
        lbBalance.font = regularFont(size: 12)
        lbBalance.textColor = ColorName.holderText.color
    }
    
}
