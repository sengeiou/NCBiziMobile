//
//  NCBInterestRateTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBInterestRateTableViewCell: NCBBaseTableViewCell {
    
    @IBOutlet weak var lbTerm: UILabel!
    @IBOutlet weak var lbPeriodLast: UILabel!
    @IBOutlet weak var lbPeriod1m: UILabel!
    @IBOutlet weak var lbPeriod3m: UILabel!
    @IBOutlet weak var lbPeriod6m: UILabel!
    @IBOutlet weak var lbPeriod12m: UILabel!
    @IBOutlet weak var lbPeriodFirst: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbTerm.font = boldFont(size: 12)
        lbTerm.textColor = ColorName.blackText.color
        
        lbPeriodLast.font = regularFont(size: 12)
        lbPeriodLast.textColor = ColorName.blackText.color
        
        lbPeriodFirst.font = regularFont(size: 12)
        lbPeriodFirst.textColor = ColorName.blackText.color
        
        lbPeriod1m.font = regularFont(size: 12)
        lbPeriod1m.textColor = ColorName.blackText.color
        
        lbPeriod3m.font = regularFont(size: 12)
        lbPeriod3m.textColor = ColorName.blackText.color
        
        lbPeriod6m.font = regularFont(size: 12)
        lbPeriod6m.textColor = ColorName.blackText.color
        
        lbPeriod12m.font = regularFont(size: 12)
        lbPeriod12m.textColor = ColorName.blackText.color
    }
    
    func setData(_ interestRate: NCBInterestRateInfoModel) {
        lbTerm.text = interestRate.term
        lbPeriodLast.text = interestRate.period_last
        lbPeriodFirst.text = interestRate.period_first
        lbPeriod1m.text = interestRate.period_1m
        lbPeriod3m.text = interestRate.period_3m
        lbPeriod6m.text = interestRate.period_6m
        lbPeriod12m.text = interestRate.period_12m
    }
    
}
