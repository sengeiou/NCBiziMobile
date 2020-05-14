//
//  NCBExchangeRateTableViewCell.swift
//  NCBApp
//
//  Created by Thuan on 8/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBExchangeRateTableViewCell: NCBBaseTableViewCell {
    
    @IBOutlet weak var lbCurrency: UILabel!
    @IBOutlet weak var lbExchangeRateBuyTM: UILabel!
    @IBOutlet weak var lbExchangeRateBuyCK: UILabel!
    @IBOutlet weak var lbExchangeRateSellTM: UILabel!
    @IBOutlet weak var lbExchangeRateSellCK: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lbCurrency.font = boldFont(size: 12)
        lbCurrency.textColor = UIColor.black
        
        lbExchangeRateBuyTM.font = regularFont(size: 12)
        lbExchangeRateBuyTM.textColor = UIColor.black
        lbExchangeRateBuyCK.font = regularFont(size: 12)
        lbExchangeRateBuyCK.textColor = UIColor.black
        lbExchangeRateSellTM.font = regularFont(size: 12)
        lbExchangeRateSellTM.textColor = UIColor.black
        lbExchangeRateSellCK.font = regularFont(size: 12)
        lbExchangeRateSellCK.textColor = UIColor.black
    }
    
    func setData(_ info: NCBExchangeRateInfoModel) {
        lbCurrency.text = info.rateFullname
        lbExchangeRateBuyTM.text = info.rateBuyCash
        lbExchangeRateBuyCK.text = info.rateBuyTransfer
        lbExchangeRateSellTM.text = info.rateSell
        lbExchangeRateSellCK.text = info.rateSellTransfer
    }
    
}
