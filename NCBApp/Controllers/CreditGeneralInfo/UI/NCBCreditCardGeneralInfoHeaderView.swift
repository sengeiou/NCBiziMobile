//
//  NCBCreditCardGeneralInfoHeaderView.swift
//  NCBApp
//
//  Created by Thuan on 7/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBCreditCardGeneralInfoHeaderView: UIView {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbPeriodTitle: UILabel!
    @IBOutlet weak var lbLimit: UILabel!
    @IBOutlet weak var lbLimitValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbPeriodTitle.font = semiboldFont(size: 14)
        lbPeriodTitle.textColor = UIColor(hexString: "959595")
        lbPeriodTitle.text = "Giao dịch trong kỳ"
        
        lbLimit.font = semiboldFont(size: 10)
        lbLimit.textColor = ColorName.blurNormalText.color
        lbLimit.text = "Hạn mức còn lại"
        
        lbLimitValue.font = semiboldFont(size: 10)
        lbLimitValue.textColor = ColorName.blurNormalText.color
    }
    
    func hiddenLimitView() {
        lbLimit.isHidden = true
        lbLimitValue.isHidden = true
    }
    
}
