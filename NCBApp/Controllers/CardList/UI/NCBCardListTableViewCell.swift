//
//  NCBCardListTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 8/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBCardListTableViewCell: NCBBaseTableViewCell {
    
    @IBOutlet weak var creditCardInfoView: NCBCreditCardInfoView!
    @IBOutlet weak var otherBtnView: UIView!
    @IBOutlet weak var otherBtn: NCBStatementButton!
    @IBOutlet weak var mainBtn: NCBStatementButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        otherBtnView.isHidden = true
    }
    
}
