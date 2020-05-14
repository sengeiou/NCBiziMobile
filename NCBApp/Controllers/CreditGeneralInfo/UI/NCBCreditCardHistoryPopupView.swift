//
//  NCBCreditCardHistoryPopupView.swift
//  NCBApp
//
//  Created by Thuan on 7/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBCreditCardHistoryPopupView: UIView {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbAmountValue: UILabel!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbContentValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lbTime.font = regularFont(size: 12)
        lbTime.textColor = ColorName.blackText.color
        
        lbAmount.font = regularFont(size: 12)
        lbAmount.textColor = ColorName.blurNormalText.color
        lbAmount.text = "Số tiền giao dịch"
        
        lbAmountValue.font = boldFont(size: 18)
        
        lbContent.font = regularFont(size: 10)
        lbContent.textColor = ColorName.blurNormalText.color
        lbContent.text = "Nội dung"
        
        lbContentValue.font = regularFont(size: 12)
        lbContentValue.textColor = ColorName.blackText.color
    }
    
    func setupData(_ item: NCBCreditCardDealHistoryModel) {
        lbTime.text = item.getTransactionTime
        lbContentValue.text = item.merchantdescription
        
        lbAmountValue.textColor = item.getAmountColor
        lbAmountValue.text = (item.getAmount() ?? 0.0).currencyFormatted
    }
    
    @IBAction func closeAction(_ sender: Any) {
        removeFromSuperview()
    }
    
}
