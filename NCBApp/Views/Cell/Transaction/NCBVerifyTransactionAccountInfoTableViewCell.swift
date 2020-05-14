//
//  NCBVerifyTransactionAccountInfoTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 7/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBVerifyTransactionAccountInfoTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbSourceAccount: UILabel!
    @IBOutlet weak var lbSourceAccountValue: UILabel!
    @IBOutlet weak var lbDestAccount: UILabel!
    @IBOutlet weak var lbDestAccountValue: UILabel!
    @IBOutlet weak var lbDestName: UILabel!
    @IBOutlet weak var lbBankName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbSourceAccount.font = regularFont(size: 12)
        lbSourceAccount.textColor = ColorName.blackText.color
        lbSourceAccount.text = "Từ tài khoản"
        
        lbSourceAccountValue.font = semiboldFont(size: 14)
        lbSourceAccountValue.textColor = ColorName.blackText.color
        
        lbDestAccount.font = regularFont(size: 12)
        lbDestAccount.textColor = ColorName.blackText.color
        lbDestAccount.text = "Đến số tài khoản nhận"
        
        lbDestAccountValue.font = semiboldFont(size: 14)
        lbDestAccountValue.textColor = ColorName.blackText.color
        
        lbDestName.font = regularFont(size: 12)
        lbDestName.textColor = ColorName.holderText.color
        
        lbBankName.font = regularFont(size: 12)
        lbBankName.textColor = ColorName.holderText.color
    }
    
}
