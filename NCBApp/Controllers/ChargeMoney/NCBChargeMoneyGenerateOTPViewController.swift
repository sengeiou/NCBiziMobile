//
//  NCBChargeMoneyGenerateOTPViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/21/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBChargeMoneyGenerateOTPViewController: NCBTransactionInformationViewController {

    var sourceAccount: NCBDetailPaymentAccountModel?
    var amount: String?
    var targetNumber: String?   //  Phone number or airpay number
    var memName: String?
    var params: [String : Any] = [:]
    var transactionType = TransactionType.topupPhoneNumb
    var didSaveUser: Bool = true
    
    fileprivate var msgId: String?
    fileprivate var p: NCBChargeMoneyGenerateOTPPresenter?
    fileprivate var presenter: NCBChargeMoneyPhoneNumberPresenter?
    fileprivate var serviceCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func verifyAction() {
        createOTPCode()
    }
    
    override func verifyWithTouchID() {
        additionalSavingAccountService(nil)
    }
    
    override func otpViewDidSelectAccept(_ otp: String) {
        additionalSavingAccountService(otp)
    }
    
    override func otpViewDidSelectResend() {
        
//        if let id = msgId, !id.isEmpty {
//            otpResend(msgId: id)
//        }
        createOTPCode()
    }
    
    override func otpAuthenticateSuccessfully() {
        showSuccessScreen()
    }
    
}

extension NCBChargeMoneyGenerateOTPViewController {
    
    fileprivate func showSuccessScreen() {
        saveService()
        
        let _vc = NCBChargeMoneyCompletedViewController()
        
        _vc.sourceAccount = sourceAccount
        _vc.amount = amount
        _vc.targetNumber = targetNumber
        _vc.transactionType = transactionType
        self.navigationController?.pushViewController(_vc, animated: true)
    }
    
}

extension NCBChargeMoneyGenerateOTPViewController {
    
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
        
        p = NCBChargeMoneyGenerateOTPPresenter()
        p?.delegate = self
        
        switch transactionType {
        case .topupPhoneNumb:
            serviceCode = "TOPUP-CARD"
        case .topupAirPay:
            serviceCode = "TOPUP-VI"
        default:
            break
        }
        
        presenter = NCBChargeMoneyPhoneNumberPresenter()
        presenter?.delegate = self
        
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Thông tin giao dịch")
    }
    
    fileprivate func doResendOTP() {
        guard let msgId = msgId else {
            return
        }
        
        otpResend(msgId: msgId)
    }
    
    fileprivate func createOTPCode() {
        
        SVProgressHUD.show()
        params["msgId"] = msgId
        p?.createOTPCode(params: params)
    }
    
    fileprivate func additionalSavingAccountService(_ otp: String?) {
        
        if let otp = otp {
            params["confirmType"] = TransactionConfirmType.OTP.rawValue
            params["confirmValue"] = otp
            params["msgId"] = msgId
        } else {
            params["confirmType"] = getConfirmType()
            params["confirmValue"] = NCBKeychainService.loadTransactionTouchID()
            params["msgId"] = ""
        }
        
        SVProgressHUD.show()
        otpAuthenticate(params: params, type: transactionType)
    }
    
    fileprivate func saveService() {
        if !didSaveUser {
            return
        }
        
        switch transactionType {
        case .topupPhoneNumb:
            if let phone = targetNumber {
                presenter?.saveService(memName: memName ?? "", providerCode: "", serviceCode: serviceCode, billNo: phone, type: serviceCode, isActive: true)
            }
        case .topupAirPay:
            if let airplayNumber = targetNumber {
                presenter?.saveService(memName: memName ?? "", providerCode: "", serviceCode: serviceCode, billNo: airplayNumber, type: serviceCode, isActive: true)
            }
        default:
            break
        }
        
    }

}

extension NCBChargeMoneyGenerateOTPViewController: NCBChargeMoneyGenerateOTPPresenterDelegate {
    
    func createOTPCodeCompleted(msgId: String?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let _ = self.msgId {
            showAlert(msg: "Gửi lại mã xác thực OTP thành công!")
            return
        }
        
        self.msgId = msgId
        showOTP()
    }
}

extension NCBChargeMoneyGenerateOTPViewController: NCBChargeMoneyPhoneNumberPresenterDelegate {
    func chargePhoneNumbCompleted(success: String?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
        print(success ?? "")
    }
}

extension NCBChargeMoneyGenerateOTPViewController: UITableViewDelegate, UITableViewDataSource {
    
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
