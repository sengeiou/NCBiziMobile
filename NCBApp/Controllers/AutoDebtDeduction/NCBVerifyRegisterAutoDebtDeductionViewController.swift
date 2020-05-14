//
//  NCBVerifyRegisterAutoDebtDeductionViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/14/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum VerifyAutoDebtDeductionType: Int {
    case register = 0
    case unregister
    case update
}

class NCBVerifyRegisterAutoDebtDeductionViewController: NCBTransactionInformationViewController {
    
    var sourceAccount: NCBDetailPaymentAccountModel?
    var card: NCBCardModel?
    var level: String = ""
    var type: VerifyAutoDebtDeductionType = .register
    fileprivate var p: NCBVerifyRegisterAutoDebtDeductionPresenter?
    fileprivate var msgId: String = ""
    fileprivate var isOTP = true
    fileprivate var serviceCode: String {
        switch type {
        case .register:
            return AutoDebtActionType.CREATE.rawValue
        case .unregister:
            return AutoDebtActionType.CANCEL.rawValue
        case .update:
            return AutoDebtActionType.UPDATE.rawValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
//        otpResend(msgId: msgId)
        let params: [String: Any] = [
            "cif": NCBShareManager.shared.getUser()?.cif ?? "",
            "userId": NCBShareManager.shared.getUserID(),
            "cardNo": card?.cardno ?? "",
            "acctNo": sourceAccount?.acctNo ?? "",
            "serviceCode": serviceCode
        ]
        otpResend(msgId: msgId, params: params, type: .autoDebtDeduction)
    }
    
    override func otpAuthenticateSuccessfully() {
        showSuccessScreen()
    }
    
}

extension NCBVerifyRegisterAutoDebtDeductionViewController {
    
    override func setupView() {
        super.setupView()
        
        hiddenHeaderView()
        
        infoTblView.register(UINib(nibName: R.nib.ncbVerifyTransactionGeneralInfoTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbVerifyTransactionGeneralInfoTableViewCellID.identifier)
        infoTblView.separatorStyle = .none
        infoTblView.estimatedSectionHeaderHeight = 120
        infoTblView.sectionHeaderHeight = UITableView.automaticDimension
        infoTblView.estimatedRowHeight = 60
        infoTblView.rowHeight = UITableView.automaticDimension
        infoTblView.delegate = self
        infoTblView.dataSource = self
        
        p = NCBVerifyRegisterAutoDebtDeductionPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        switch type {
        case .register:
            setHeaderTitle("Đăng ký trích nợ tự động")
        case .unregister:
            setHeaderTitle("Huỷ dịch vụ trích nợ tự động")
        case .update:
            setHeaderTitle("Thay đổi thông tin trích nợ")
        }
    }
    
}

extension NCBVerifyRegisterAutoDebtDeductionViewController {
    
    fileprivate func doConfirm() {
        guard let card = card else {
            return
        }
        
        guard let sourceAccount = sourceAccount else {
            return
        }
        
        var params: [String: Any] = [:]
        params["userId"] = NCBShareManager.shared.getUserID()
        params["cifNo"] = NCBShareManager.shared.getUser()?.cif ?? ""
        params["cardNo"] = card.cardno ?? ""
        params["acctNo"] = sourceAccount.acctNo ?? ""
        params["autoDebit"] = "YES"
        params["repayMode"] = level
        switch type {
        case .register:
            params["serviceCode"] = AutoDebtActionType.CREATE.rawValue
        case .unregister:
            params["serviceCode"] = AutoDebtActionType.CANCEL.rawValue
        case .update:
            params["serviceCode"] = AutoDebtActionType.UPDATE.rawValue
        }
        params["lang"] = TransactionLangType.VI.rawValue
        if !isOTP {
            params["confirmType"] = getConfirmType()
            params["confirmValue"] = NCBKeychainService.loadTransactionTouchID()
        } else {
            params["confirmType"] = TransactionConfirmType.OTP.rawValue
            params["confirmValue"] = ""
        }
        
        SVProgressHUD.show()
        p?.doConfirm(params: params)
    }
    
    fileprivate func doApproval(_ otp: String) {
        guard let card = card else {
            return
        }
        
        guard let sourceAccount = sourceAccount else {
            return
        }
        
        var params: [String: Any] = [:]
        params["userId"] = NCBShareManager.shared.getUserID()
        params["cifNo"] = NCBShareManager.shared.getUser()?.cif ?? ""
        params["cardNo"] = card.cardno ?? ""
        params["acctNo"] = sourceAccount.acctNo ?? ""
        params["autoDebit"] = "YES"
        params["repayMode"] = level
        params["serviceCode"] = serviceCode
        params["lang"] = TransactionLangType.VI.rawValue
        params["confirmType"] = TransactionConfirmType.OTP.rawValue
        params["confirmValue"] = otp
        params["msgid"] = msgId
        
        SVProgressHUD.show()
        otpAuthenticate(params: params, type: .autoDebtDeduction)
    }
    
    fileprivate func showSuccessScreen() {
        if let vc = R.storyboard.onlinePayment.ncbCardCompletedServiceViewController() {
            vc.setData(card, type: (type == .register) ? .registerAutoDebtDeduction : .updateAutoDebtDeduction)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBVerifyRegisterAutoDebtDeductionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbVerifyTransactionGeneralInfoTableViewCellID.identifier, for: indexPath) as! NCBVerifyTransactionGeneralInfoTableViewCell
        cell.lbContent.text = "Mức trích nợ tự động:\n\(level)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = R.nib.ncbVerifyTransactionAccountInfoTableViewCell.firstView(owner: self)
        
        header?.lbSourceAccount.text = "Tài khoản trích nợ tự động"
        header?.lbSourceAccountValue.text = sourceAccount?.acctNo
        
        header?.lbDestAccount.text = "Số thẻ"
        header?.lbDestAccountValue.text = card?.cardno?.cardHidden
        
        header?.lbDestName.text = ""
        header?.lbBankName.text = ""
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension NCBVerifyRegisterAutoDebtDeductionViewController: NCBVerifyRegisterAutoDebtDeductionPresenterDelegate {
    
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
        
        showSuccessScreen()
    }
    
}
