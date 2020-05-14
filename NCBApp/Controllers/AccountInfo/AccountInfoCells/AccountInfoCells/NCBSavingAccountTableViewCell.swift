//
//  NCBSavingAccountTableViewCell.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/4/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

typealias NCBSavingAccountTableViewCellCallback = () -> (Void)

class NCBSavingAccountTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var totalLbl: UILabel! {
        didSet {
            totalLbl.text = "Tài khoản tiết kiệm"
            totalLbl.font = semiboldFont(size: 14)
            totalLbl.textColor = UIColor.init(hexString: "1A4C98")
        }
    }
    
    @IBOutlet weak var totalAmountVNDLbl: NCBCurrencyLabel! {
        didSet {
            totalAmountVNDLbl.font = regularFont(size: 12)
            totalAmountVNDLbl.textColor = UIColor.init(hexString: "6B6B6B")
        }
    }
    
    @IBOutlet weak var detailSavingAccountBtn: UIButton! {
        didSet {
            //detailSavingAccountBtn.setTitle("Xem chi tiết", for: .normal)
        }
    }
    
    // MARK: - Properties

    var savingAccountModel: NCBSavingAccountModel? {
        didSet {
            if let savingAccountModel = savingAccountModel {
                totalAmountVNDLbl.text = "\(savingAccountModel.getTotalBalance())\n\(savingAccountModel.getTotalBalance())"
            } else {
                totalAmountVNDLbl.text = 0.0.currencyFormatted
            }
        }
    }
    var listSavingAccount: [NCBSavingAccountModel]? {
        didSet {
            totalAmountVNDLbl.text = getBalance()
        }
    }
    
    var seeMoreSavingAccountInfoCallBack: NCBSavingAccountTableViewCellCallback!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        selectionStyle = .none
    }

    @IBAction func gotoDetail(_ sender: UIButton) {
//        seeMoreSavingAccountInfoCallBack()
    }

    fileprivate func getBalance() -> String {
        var balance = 0.0.currencyFormatted
        guard let listSavingAccount = listSavingAccount else {
            return balance
        }

        if listSavingAccount.count > 0 {
            balance = listSavingAccount[0].getTotalBalance()
        }

        if listSavingAccount.count > 1 {
            balance = balance + "\n\n\(listSavingAccount[1].getTotalBalance())"
        }

        return balance
    }

}
