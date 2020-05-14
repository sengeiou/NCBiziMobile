//
//  NCBChargeMoneyCompletedViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/22/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBChargeMoneyCompletedViewController: NCBTransactionSuccessfulViewController {
    
    var sourceAccount: NCBDetailPaymentAccountModel?
    var amount: String?
    var targetNumber: String?   //  Phone number or airpay number
    var transactionType = TransactionType.topupPhoneNumb
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBChargeMoneyCompletedViewController {
    
    override func setupView() {
        super.setupView()
        
        switch transactionType {
        case .topupPhoneNumb:
            lbAmountTitle.text = "Mệnh giá nạp tiền"
            lbAmountValue.text = amount
        case .topupAirPay:
            lbAmountTitle.text = "Số tiền nạp"
            lbAmountValue.text = amount
        default:
            break
        }
        lbFee.text = ""
        
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Giao dịch thành công")
    }
    
    override func continueAction() {
        switch transactionType {
        case .topupPhoneNumb:
            gotoSpecificallyController(NCBChargeMoneyPhoneNumberViewController.self)
        case .topupAirPay:
            gotoSpecificallyController(NCBChargeAirpayViewController.self)
        default:
            break
        }
    }
    
}

extension NCBChargeMoneyCompletedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        switch transactionType {
        case .topupPhoneNumb:
            header?.lbSourceAccount.text = "Từ tài khoản"
            header?.lbSourceAccountValue.text = sourceAccount?.acctNo
            
            header?.lbDestAccount.text = "Số điện thoại nhận"
            header?.lbDestAccountValue.text = targetNumber
            
            header?.lbDestName.text = ""
            header?.lbBankName.text = ""
            
        case .topupAirPay:
            
            header?.lbSourceAccount.text = "Từ tài khoản"
            header?.lbSourceAccountValue.text = sourceAccount?.acctNo
            
            header?.lbDestAccount.text = "Số ví Airpay"
            header?.lbDestAccountValue.text = targetNumber
            
            header?.lbDestName.text = ""
            header?.lbBankName.text = ""
            
        default:
            break
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
