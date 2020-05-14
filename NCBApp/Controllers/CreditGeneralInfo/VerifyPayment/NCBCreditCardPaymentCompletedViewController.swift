//
//  NCBCreditCardPaymentCompletedViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBCreditCardPaymentCompletedViewController: NCBTransactionSuccessfulViewController {
    
    var amount: Double?
    var creditCardInfo: NCBCreditCardModel?
    var sourceAccount: NCBDetailPaymentAccountModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func continueAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension NCBCreditCardPaymentCompletedViewController {
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = UIColor.white
        
        lbAmountValue.text = amount?.currencyFormatted
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
    
}

extension NCBCreditCardPaymentCompletedViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        header?.lbSourceAccount.text = "Từ tài khoản"
        header?.lbSourceAccountValue.text = sourceAccount?.acctNo
        
        header?.lbDestAccount.text = "Đến số thẻ"
        header?.lbDestAccountValue.text = creditCardInfo?.cardno?.cardHidden
        
        header?.lbDestName.text = creditCardInfo?.cardname
        header?.lbBankName.text = ""
        
        return header
    }
    
}
