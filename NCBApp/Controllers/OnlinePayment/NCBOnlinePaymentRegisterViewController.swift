//
//  NCBOnlinePaymentRegisterViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBOnlinePaymentRegisterViewController: NCBBaseVerifyTransactionViewController {
    
    //MARK: Properties
    
    var card: NCBCardModel?
    fileprivate var p: NCBOnlinePaymentRegisterPresenter?
    fileprivate var isOTP = true
    fileprivate var msgId = ""
    fileprivate var otpVC = R.storyboard.bottomSheet.ncbotpViewController()!
    fileprivate var registeredECOM: Bool {
        return card?.registeredECOM ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBOnlinePaymentRegisterViewController {
    
    override func setupView() {
        super.setupView()
        
        commonCreditCardInfoView?.setData(card)
        
        if let vc = R.storyboard.onlinePayment.ncbOnlinePaymentVerifyViewController() {
            vc.delegate = self
            vc.registeredECOM = registeredECOM
            showBottomSheet(controller: vc, size: 315, disablePanGesture: true)
        }
        
        p = NCBOnlinePaymentRegisterPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Dịch vụ thanh toán trực tuyến")
    }
    
}

extension NCBOnlinePaymentRegisterViewController {
    
    fileprivate func showOTP() {
        showBottomSheet(controller: otpVC, size: NumberConstant.otpViewHeight, disablePanGesture: true)
        otpVC.delegate = self
    }
    
    fileprivate func showSuccessScreen() {
        if let vc = R.storyboard.onlinePayment.ncbCardCompletedServiceViewController() {
            vc.setData(card, type: registeredECOM ? .unregisterEcom : .registerEcom)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func doUnregister() {
        guard let card = card else {
            return
        }
        
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUserID()
        params["cifNo"] = NCBShareManager.shared.getUser()?.cif ?? ""
        params["cardNo"] = card.cardno ?? ""
        params["cardType"] = card.cardtype ?? ""
        
        SVProgressHUD.show()
        p?.unregisterEcom(params: params)
    }
    
    fileprivate func doConfirm() {
        guard let card = card else {
            return
        }
        
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUserID()
        params["cifNo"] = NCBShareManager.shared.getUser()?.cif ?? ""
        params["cardNo"] = card.cardno ?? ""
        params["cardType"] = card.cardtype ?? ""
        params["allowFlag"] = card.registeredECOM ? "0" : "1"
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
        
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUserID()
        params["cifNo"] = NCBShareManager.shared.getUser()?.cif ?? ""
        params["cardNo"] = card.cardno ?? ""
        params["cardType"] = card.cardtype ?? ""
        params["allowFlag"] = card.registeredECOM ? "0" : "1"
        params["lang"] = TransactionLangType.VI.rawValue
        params["confirmType"] = TransactionConfirmType.OTP.rawValue
        params["confirmValue"] = otp
        params["msgid"] = msgId
        
        SVProgressHUD.show()
        otpAuthenticate(params: params, type: .registerEcom)
    }
    
    override func otpAuthenticateSuccessfully() {
        showSuccessScreen()
    }
    
    override func otpAuthenticateFailure() {
        otpVC.clear()
    }
    
}

extension NCBOnlinePaymentRegisterViewController: NCBOnlinePaymentVerifyViewControllerDelegate {
    
    func onlinePaymentVerifyOTP() {
        if registeredECOM {
            doUnregister()
        } else {
            isOTP = true
            doConfirm()
        }
    }
    
    func onlinePaymentVerifyTouchID(_ touchMe: BiometricIDAuth) {
        isOTP = false
//        if !isOpenTransactionTouchID {
//            showAlert(msg: "Vui lòng kích hoạt xác nhận giao dịch bằng \(touchMe.biometricSuffix) tại phần cài đặt trong ứng dụng")
//            return
//        }
        
        if !checkBioAvailable(touchMe, isOpen: isOpenTransactionTouchID) {
            return
        }
        
        touchMe.evaluate { [weak self] (error, msg) in
            if error == biometricSuccessCode {
                self?.doConfirm()
            } else {
                if let msg = msg {
                    self?.showAlert(msg: msg)
                }
            }
        }
    }
    
    func onlinePaymentCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension NCBOnlinePaymentRegisterViewController: NCBOTPViewControllerDelegate {
    
    func otpDidSelectAccept(_ otp: String) {
        doApproval(otp)
    }
    
    func otpDidSelectResend() {
//        otpResend(msgId: msgId)
        let params: [String: Any] = [
            "cardNo": card?.cardno ?? ""
        ]
        otpResend(msgId: msgId, params: params, type: .registerEcom)
    }
    
}

extension NCBOnlinePaymentRegisterViewController: NCBOnlinePaymentRegisterPresenterDelegate {
    
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
    
    func unregisterCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        showSuccessScreen()
    }
    
}
