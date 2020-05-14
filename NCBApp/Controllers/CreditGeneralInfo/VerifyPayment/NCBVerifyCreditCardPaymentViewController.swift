//
//  NCBVerifyCreditCardPaymentViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBVerifyCreditCardPaymentViewController: NCBTransactionInformationViewController {
    
    //MARK: Properties
    
    var amount: Double?
    var creditCardInfo: NCBCreditCardModel?
    var sourceAccount: NCBDetailPaymentAccountModel?
    fileprivate var p: NCBVerifyCreditCardPaymentPresenter?
    fileprivate var isOTP = true
    fileprivate var msgId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBVerifyCreditCardPaymentViewController {
    
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
        
        p = NCBVerifyCreditCardPaymentPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Thông tin giao dịch")
    }
    
    override func verifyAction() {
        isOTP = true
        doConfirm()
    }
    
    override func verifyWithTouchID() {
        isOTP = false
        doConfirm()
    }
    
    override func otpViewDidSelectAccept(_ otp: String) {
        doApproval(otp)
    }
    
    override func otpViewDidSelectResend() {
        let params: [String: Any] = [
            "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
            "debitAccountNo": sourceAccount?.acctNo ?? "",
            "cardNo": creditCardInfo?.cardno ?? "",
            "amount": amount ?? 0.0
        ]
        otpResend(msgId: msgId, params: params, type: .creditCardPayment)
    }
    
    override func otpAuthenticateSuccessfully() {
        showPaymentCompleted()
    }
    
}

extension NCBVerifyCreditCardPaymentViewController {
    
    fileprivate func doConfirm() {
        guard let creditCardInfo = creditCardInfo else {
            return
        }
        
        guard let sourceAccount = sourceAccount else {
            return
        }
        
        SVProgressHUD.show()
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUserID()
        params["cifno"] = NCBShareManager.shared.getUser()?.cif ?? ""
        params["debitAccountNo"] = sourceAccount.acctNo ?? ""
        params["closingDate"] = creditCardInfo.closingDate ?? ""
        params["cardNo"] = creditCardInfo.cardno ?? ""
        params["amount"] = amount ?? 0.0
        params["lang"] = TransactionLangType.VI.rawValue
        if !isOTP {
            params["typeConfirm"] = getConfirmType()
            params["valueConfirm"] = NCBKeychainService.loadTransactionTouchID()
        } else {
            params["typeConfirm"] = TransactionConfirmType.OTP.rawValue
            params["valueConfirm"] = ""
        }
        p?.doConfirm(params: params)
    }
    
    fileprivate func doApproval(_ otp: String) {
        guard let creditCardInfo = creditCardInfo else {
            return
        }
        
        guard let sourceAccount = sourceAccount else {
            return
        }
        
        SVProgressHUD.show()
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUserID()
        params["cifno"] = NCBShareManager.shared.getUser()?.cif ?? ""
        params["debitAccountNo"] = sourceAccount.acctNo ?? ""
        params["closingDate"] = creditCardInfo.closingDate ?? ""
        params["cardNo"] = creditCardInfo.cardno ?? ""
        params["amount"] = amount ?? 0.0
        params["lang"] = TransactionLangType.VI.rawValue
        params["typeConfirm"] = TransactionConfirmType.OTP.rawValue
        params["valueConfirm"] = otp
        params["msgid"] = msgId
        otpAuthenticate(params: params, type: .creditCardPayment)
    }
    
    fileprivate func showPaymentCompleted() {
        let vc = NCBCreditCardPaymentCompletedViewController()
        vc.creditCardInfo = creditCardInfo
        vc.sourceAccount = sourceAccount
        vc.amount = amount
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension NCBVerifyCreditCardPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension NCBVerifyCreditCardPaymentViewController: NCBVerifyCreditCardPaymentPresenterDelegate {
    
    func confirmCompleted(msgId: String?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        self.msgId = msgId ?? ""
        
        if isOTP {
            showOTP()
            return
        }
        
        showPaymentCompleted()
    }
    
}
