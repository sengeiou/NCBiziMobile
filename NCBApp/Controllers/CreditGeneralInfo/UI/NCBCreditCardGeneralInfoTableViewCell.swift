//
//  NCBCreditCardGeneralInfoTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 7/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBCreditCardGeneralInfoTableViewCell: NCBBaseTableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var paddingRightStackView: NSLayoutConstraint!
    @IBOutlet weak var lbNarrative: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbDate.font = regularFont(size: 10)
        lbDate.textColor = UIColor(hexString: "7F7F7F")
        
        lbNarrative.font = regularFont(size: 10)
        lbNarrative.textColor = UIColor(hexString: "7F7F7F")
        lbNarrative.text = ""
        
        lbContent.font = semiboldFont(size: 12)
        lbContent.textColor = ColorName.normalText.color
        
        lbAmount.font = semiboldFont(size: 12)
    }
    
    func setupData(_ item: NCBCreditCardDealHistoryModel) {
        if let strDate = item.transactionDate, let date = yyyyMMdd.date(from: strDate) {
            lbDate.text = ddMMyy.string(from: date)
        }
        lbContent.text = item.merchantdescription
        
        lbAmount.textColor = item.getAmountColor
        lbAmount.text = (item.getAmount() ?? 0.0).currencyFormatted
    }
    
    func setupDataForTopTen(_ item: NCBDetailHistoryDealItemModel) {
        if let strDate = item.txndate, let date = yyyyMMdd.date(from: strDate) {
            lbDate.text = ddMMyy.string(from: date)
        }
//        lbContent.text = item.message
        lbAmount.textColor = item.getAmountColor
        lbAmount.text = (item.getAmount() ?? 0.0).currencyFormatted
        lbNarrative.text = item.message
    }
    
}
