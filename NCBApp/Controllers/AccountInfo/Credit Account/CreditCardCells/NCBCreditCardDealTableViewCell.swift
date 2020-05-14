//
//  NCBCreditCardDealTableViewCell.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBCreditCardDealTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var creditCardNameLbl: UILabel! {
        didSet {
            creditCardNameLbl.font = regularFont(size: 15.0)
        }
    }
    @IBOutlet weak var creditCardSerieLbl: UILabel! {
        didSet {
            creditCardSerieLbl.font = regularFont(size: 15.0)
        }
    }
    
    @IBOutlet weak var creditCardSurplusLbl: NCBCurrencyLabel! {
        didSet {
            creditCardSurplusLbl.font = UIFont.systemFont(ofSize: 15.0)
        }
    }
    
    @IBOutlet weak var creditCardDetailBtn: UIButton!
    
    // MARK: - Properties
    var amount: Double = 0.0 {
        didSet {
            creditCardSurplusLbl.currencyLabel(with: amount, and: curCode ?? "vi_VN")
        }
    }
    var curCode: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
