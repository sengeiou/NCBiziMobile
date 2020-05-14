//
//  NCBBaseVerifyTransactionViewController.swift
//  NCBApp
//
//  Created by Thuan on 5/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

let codeOTPError1st = "OTP-1"
let codeOTPError2nd = "OTP-2"
let codeOTPError3rd = "OTP-3"

class NCBBaseVerifyTransactionViewController: NCBBaseViewController {
    
    //MARK: Properties
    
    var otpAuthPresenter: NCBOTPAuthenticationPresenter?
    var exceedLimit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otpAuthPresenter = NCBOTPAuthenticationPresenter()
        otpAuthPresenter?.delegate = self
        
//        p?.getTransferLimit()
    }
    
    func otpAuthenticate(params: [String : Any], type: TransactionType) {
        SVProgressHUD.show()
        otpAuthPresenter?.otpAuthenticate(params: params, type: type)
    }
    
    func otpResend(msgId: String) {
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUser()!.username ?? ""
        params["msgid"] = msgId
        params["lang"] = TransactionLangType.VI.rawValue
        
        SVProgressHUD.show()
        otpAuthPresenter?.otpResend(params: params)
    }
    
    func otpResend(msgId: String, params: [String: Any], type: TransactionType) {
        var newParams = params
        newParams["username"] = NCBShareManager.shared.getUserID()
        newParams["msgid"] = msgId
        newParams["lang"] = TransactionLangType.VI.rawValue
        
        SVProgressHUD.show()
        otpAuthPresenter?.otpResend(params: newParams, type: type)
    }
    
}

extension NCBBaseVerifyTransactionViewController {
    
    @objc func otpAuthenticateSuccessfully() {
        
    }
    
    @objc func otpAuthenticateFailure() {
        
    }
    
}

extension NCBBaseVerifyTransactionViewController: NCBOTPAuthenticationPresenterDelegate {
    
    func otpAuthenticationCompleted(code: String?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            if code == codeOTPError3rd {
                showError(msg: error) { [weak self] in
//                    doLogout()
                    self?.userLogout()
                }
            } else if code == ResponseCodeConstant.systemError {
                otpAuthenticateFailure()
                showError(msg: error) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                otpAuthenticateFailure()
                showAlert(msg: error)
            }
            return
        }
        
        otpAuthenticateSuccessfully()
    }
    
    func otpResendCompleted(error: String?, msgId: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        showAlert(msg: "Gửi lại mã xác thực OTP thành công!")
    }
    
    func refreshTokenCompleted(error: String?) {
        
    }
    
}
