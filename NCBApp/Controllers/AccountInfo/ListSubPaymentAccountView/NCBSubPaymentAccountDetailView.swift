//
//  NCBSubPaymentAccountDetailView.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/11/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBSubPaymentAccountDetailView: UIView {

    // MARK: Outlets
    @IBOutlet weak var accountImg: UIImageView! {
        didSet {
            let radius = accountImg.frame.width / 2
            accountImg.layer.cornerRadius = radius
            accountImg.layer.masksToBounds = true

        }
    }
    @IBOutlet weak var accountNumbLbl: UILabel! {
        didSet {
            accountNumbLbl.font = UIFont.systemFont(ofSize: 15.0)
        }
    }
    @IBOutlet weak var accountBalanceLbl: NCBCurrencyLabel! {
        didSet {
            accountBalanceLbl.font = UIFont.systemFont(ofSize: 15.0)
        }
    }
    
    // MARK: - Properties
    
    var amount: Double = 0.0 {
        didSet {
            accountBalanceLbl.currencyLabel(with: amount, and: curCode)
        }
    }
    var curCode: String = "" {
        didSet {
            curCode = curCode.convertCurrencyUnit()
        }
    }
    
    var accountInfo: NCBDetailPaymentAccountModel? {
        didSet {
            accountNumbLbl.text = accountInfo?.acctNo
            curCode = accountInfo?.curCode ?? "VND"
            amount = Double(accountInfo?.curBal ?? 0)
            if amount < 0 {
                accountBalanceLbl.textColor = UIColor(hexString: ColorName.pinkishRed.rawValue)
            } else {
                accountBalanceLbl.textColor = UIColor(hexString: ColorName.mediumBlue.rawValue)
            }
        }
    }
    
    var dealHistoryInfo: NCBDetailHistoryDealItemModel? {
        didSet {
            accountNumbLbl.text = dealHistoryInfo?.actno
            curCode = dealHistoryInfo?.curCode ?? "VND"
            amount = dealHistoryInfo?.getAmount() ?? 0.0
            if amount < 0 {
                accountBalanceLbl.textColor = UIColor(hexString: ColorName.pinkishRed.rawValue)
            } else {
                accountBalanceLbl.textColor = UIColor(hexString: ColorName.mediumBlue.rawValue)
            }
        }
    }
    
    override func awakeFromNib() {
        
    }
}
