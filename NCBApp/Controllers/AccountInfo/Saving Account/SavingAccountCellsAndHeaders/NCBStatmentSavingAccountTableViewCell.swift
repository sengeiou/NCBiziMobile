//
//  NCBStatmentSavingAccountTableViewCell.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/18/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBStatmentSavingAccountTableViewCell: NCBBaseTableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel! {
        didSet {
            dateLbl.font = regularFont(size: 10)
            dateLbl.textColor = UIColor(hexString: "7F7F7F")
        }
    }
    
    @IBOutlet weak var amountLbl: UILabel! {
        didSet {
            amountLbl.font = semiboldFont(size: 12)
            amountLbl.textColor = ColorName.amountBlueText.color
        }
    }

    @IBOutlet weak var interestRateLbl: UILabel! {
        didSet {
            interestRateLbl.font = regularFont(size: 10)
            interestRateLbl.textColor = UIColor(hexString: "7F7F7F")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(_ item: NCBDetailStatementSavingAccountModel) {
        if let openDate = item.openDate, let date = ddMMyyyyFormatter.date(from: openDate) {
            dateLbl.text = ddMMyy.string(from: date)
        }
        amountLbl.text = Double(item.balance ?? 0).currencyFormatted
        interestRateLbl.text = "Lãi suất thời điểm gửi: \(item.interst ?? 0.0)%"
    }
    
}
