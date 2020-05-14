//
//  NCBListSavingAccountTableViewCell.swift
//  NCBApp
//
//  Created by Van Dong on 21/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBListSavingAccountTableViewCell: UITableViewCell {

    @IBOutlet weak var checkbtn: UIButton!
    @IBOutlet weak var account: UILabel!
    @IBOutlet weak var balance: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    @IBOutlet weak var termDest: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        checkbtn.setImage(R.image.ic_radio_uncheck(), for: .normal)
        checkbtn.setImage(R.image.ic_radio_check(), for: .selected)
        
        account.font = semiboldFont(size: 14)
        account.textColor = ColorName.blackText.color
        
        balance.font = semiboldFont(size: 12)
        balance.textColor = ColorName.blackText.color
        
        dueDate.font = regularFont(size: 12)
        dueDate.textColor = ColorName.holderText.color
        
        termDest.font = regularFont(size: 12)
        termDest.textColor = ColorName.holderText.color
    }
    
}
