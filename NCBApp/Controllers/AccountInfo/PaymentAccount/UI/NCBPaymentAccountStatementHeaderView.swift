//
//  NCBPaymentAccountStatementHeaderView.swift
//  NCBApp
//
//  Created by Thuan on 7/30/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBPaymentAccountStatementHeaderView: UIView {
    
    @IBOutlet weak var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbTitle.font = semiboldFont(size: 10)
        lbTitle.textColor = ColorName.blurNormalText.color
    }
    
}
