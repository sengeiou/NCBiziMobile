//
//  NCBListAccountRegisterSMSTableViewCell.swift
//  NCBApp
//
//  Created by Van Dong on 15/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBListAccountRegisterSMSTableViewCell: UITableViewCell {

    @IBOutlet weak var checkbtn: UIButton!
    @IBOutlet weak var titleAccount: UILabel!
    @IBOutlet weak var accNumber: UILabel!
    @IBOutlet weak var curBal: UILabel!
    @IBOutlet weak var curCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        checkbtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
        checkbtn.setImage(R.image.ic_radio_check(), for: .selected)
        
        titleAccount.text = "Tài khoản nguồn"
        titleAccount.font = semiboldFont(size: 14)
        titleAccount.textColor = ColorName.blurNormalText.color
        
        accNumber.font = regularFont(size: 12)
        accNumber.textColor = ColorName.holderText.color
        
        curBal.font = regularFont(size: 12)
        curBal.textColor = ColorName.holderText.color
        
        curCode.font = regularFont(size: 12)
        curCode.textColor = ColorName.holderText.color
    }
    
}
