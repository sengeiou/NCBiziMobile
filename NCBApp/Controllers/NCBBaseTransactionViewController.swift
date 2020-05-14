//
//  NCBBaseTransactionViewController.swift
//  NCBApp
//
//  Created by Thuan on 5/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

class NCBBaseTransactionViewController: NCBBaseViewController {
    
    fileprivate var accountPresenter: NCBGeneralAccountPresenter?
    fileprivate var authPresenter: NCBOTPAuthenticationPresenter?
    var listPaymentAccount: [NCBDetailPaymentAccountModel] = []
    var sourceAccount: NCBDetailPaymentAccountModel?
    
    var getSourcePaymentCode: PaymentControlCode {
        if self.isKind(of: NCBInternalTransferViewController.self) {
            return .CKNB
        }
        
        if self.isKind(of: NCBISavingsViewController.self) || self.isKind(of: NCBAddSavingAmountViewController.self) {
            return .SAVING
        }
        
        if self.isKind(of: NCBCreditCardPaymentCardHolderViewController.self)
            || self.isKind(of: NCBCreditCardPaymentOtherCardViewController.self)
            || self.isKind(of: NCBRegisterAutoDebtDeductionViewController.self)
            || self.isKind(of: NCBRegistrationCardReissueViewController.self)
            || self.isKind(of: NCBRegistrationResupplyPINViewController.self)
        {
            return .CARD
        }
        
        if self.isKind(of: NCBServicePaymentViewController.self)
            || self.isKind(of: NCBAutoPaymentRegisterViewController.self)
        {
            return .BIllING
        }
        
        if self.isKind(of: NCBChargeAirpayViewController.self)
            || self.isKind(of: NCBChargeMoneyPhoneNumberViewController.self)
        {
            return .TOPUP
        }
        
        if self.isKind(of: NCBRegisterVidAcctDetailViewController.self) {
            return .REGISTER
        }
        
        return .OTHER
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NCBShareManager.shared.areTrading = true
        
        accountPresenter = NCBGeneralAccountPresenter()
        accountPresenter?.delegate = self
        
        authPresenter = NCBOTPAuthenticationPresenter()
        authPresenter?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NCBShareManager.shared.areTrading = true
    }
    
    override func backAction(sender: UIButton) {
        NCBShareManager.shared.areTrading = false
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NCBBaseTransactionViewController {
    
    override func setupView() {
        super.setupView()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
}

extension NCBBaseTransactionViewController {
    
    func getSourceAccountPaymentList() {
        refreshToken()
    }
    
    func refreshToken() {
        SVProgressHUD.show()
        authPresenter?.refreshToken()
    }
    
    @objc func checkBalanceResult(_ result: Bool) {
        
    }

    @objc func defaultSourceAccount() {
        if listPaymentAccount.count == 0 {
            return
        }
        
        let result = listPaymentAccount.sorted() {
            ($0.curBal ?? 0.0) > ($1.curBal ?? 0.0)
        }
        
        listPaymentAccount = result
        sourceAccount = result[0]
        sourceAccount?.isSelected = true
        loadDefaultSourceAccount()
    }
    
    
    @objc func loadDefaultSourceAccount() {
        
    }
    
    func exceedLimit(_ amount: Double, type: TransactionType) -> Bool {
        return authPresenter?.exceedLimit(amount, type: type) ?? false
    }
    
    func invalidTransferAmount(_ amount: Double, type: TransactionType, limitType: TransferLimitType) -> Bool {
        return authPresenter?.invalidTransferAmount(amount, type: type, limitType: limitType) ?? false
    }
    
    var transferLimitValue: String {
        return authPresenter?.transferLimitValue ?? ""
    }
    
    func getListCreditCard(_ cardType: String) {
        let params: [String : Any] = [
            "userId": NCBShareManager.shared.getUser()?.username ?? "",
            "cifno": NCBShareManager.shared.getUser()?.cif ?? 0,
            "cardType": cardType
        ]
        
        accountPresenter?.getListCreditCard(params: params)
    }
    
    func checkBalanceTransfer(sourceAcct: String, destAcct: String, amount: Double, transType: String, flagCharity: Bool = false) {
        let params: [String: Any] = [
            "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "debitAcct": sourceAcct,
            "creditAcct": destAcct,
            "amount": amount,
            "transType": transType,
            "flagCharity": flagCharity ? "1" : "0"
        ]
        authPresenter?.checkBalance(params, type: .transfer)
    }
    
    func checkBalanceCard(debitAccountNo: String, amount: Double) {
        let params: [String: Any] = [
            "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
            "username": NCBShareManager.shared.getUser()?.username ?? "",
            "debitAccountNo": debitAccountNo,
            "amount": amount,
        ]
        authPresenter?.checkBalance(params, type: .card)
    }
    
    func checkBalanceRechargeMoney(acctNo: String, amt: Double) {
        let params: [String: Any] = [
            "acctNo": acctNo,
            "amt": amt,
        ]
        authPresenter?.checkBalance(params, type: .rechargeMoney)
    }
    
}

extension NCBBaseTransactionViewController: NCBGeneralAccountPresenterDelegate {
    
    func getListPaymentAccountCompleted(listPaymentAccount: [NCBDetailPaymentAccountModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        self.listPaymentAccount = listPaymentAccount ?? []
        
        defaultSourceAccount()
    }
    
}

extension NCBBaseTransactionViewController: NCBOTPAuthenticationPresenterDelegate {
    
    func getTransferLimitCompleted(error: String?) {
//        if let error = error {
//            showAlert(msg: error)
//            return
//        }
    }
    
    func checkBalanceTransferCompleted(error: String?) {
        checkBalanceResult(error == nil)
        if let error = error {
            showAlert(msg: error)
        }
    }
    
    func refreshTokenCompleted(error: String?) {
//        if let error = error {
//            SVProgressHUD.dismiss()
//            showAlert(msg: error)
//            return
//        }
        authPresenter?.getTransferLimit()
        if !NCBShareManager.shared.areTrading || sourceAccount == nil {
            accountPresenter?.getListPaymentAccount(getSourcePaymentCode)
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
}
