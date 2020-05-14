//
//  NCBAccountDetailTableViewCell.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/4/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBAccountDetailTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.font = UIFont.systemFont(ofSize: 15.0)
        }
    }
    @IBOutlet weak var detailLbl: UILabel! {
        didSet {
            detailLbl.font = UIFont.boldSystemFont(ofSize: 15.0)
        }
    }
    
    @IBOutlet weak var amountLbl: NCBCurrencyLabel! {
        didSet {
            amountLbl.font = boldFont(size: 15.0)
        }
    }
    
    // MARK: - Properties
    var detailTransactionHistoryModel: NCBDetailTransactionHistoryModel?
    var amount: Double? {
        didSet {
            amountLbl.currencyLabel(with: amount ?? 0.0, and: ccy.convertCurrencyUnit())
        }
    }
    var ccy: String = "VND"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
