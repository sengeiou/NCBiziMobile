//
//  NCBOpenLockCardDetailViewController.swift
//  NCBApp
//
//  Created by ADMIN on 7/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBOpenLockCardDetailViewController: NCBBaseVerifyTransactionViewController  {
    
    // MARK: - Outlets
    
    var opt = ""
    var msgid = ""
    
    // MARK: - Properties
    
    var cardData: NCBCardModel!
    var presenter: NCBCardServicePresenter?
    
    fileprivate let touchMe = BiometricIDAuth()
    fileprivate var otpVC = R.storyboard.bottomSheet.ncbotpViewController()!
  
    var confirmType = TransactionConfirmType.OTP.rawValue
    var activeType = CardServiceActiveType.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupData(data:NCBCardModel) {
        cardData = data
        activeType = cardData.getActiveType()
        
    }
    
    func doConfirm(_ confirmType: String){
        
        var params: [String: Any] = [:]
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["userId"] = NCBShareManager.shared.getUser()!.username
        params["cardNo"] = cardData.cardno
        params["confirmType"] = confirmType
        params["lang"] = TransactionLangType.VI.rawValue
        params["msgid"] = ""
        
        SVProgressHUD.show()
        switch confirmType {
        case TransactionConfirmType.OTP.rawValue:
            params["confirmValue"] = opt
        default:
            params["confirmValue"] = NCBKeychainService.loadTransactionTouchID()
        }
        if activeType == CardServiceActiveType.open{
            presenter?.updateCardStatusUnlockConfirm(params: params)
        }else{
            presenter?.cardActiveConfirm(params: params)
        }
    }
    
}

extension NCBOpenLockCardDetailViewController {
    override func setupView() {
        super.setupView()
        presenter = NCBCardServicePresenter()
        presenter?.delegate = self
        
        commonCreditCardInfoView?.setData(cardData)
        
        let type = cardData.getActiveType()
        switch type {
        case .open:
            if let _vc = R.storyboard.cardService.ncbNewOpenCardConfirmViewController() {
                _vc.setupData(data: cardData)
                _vc.delegate = self
                showBottomSheet(controller: _vc, size: 325)
            }
            break
        case .lock:
            if let _vc = R.storyboard.cardService.ncbLockCardConfirmViewController() {
                _vc.setupData(data: cardData)
                _vc.delegate = self
                showBottomSheet(controller: _vc, size: 247)
            }
            break
        case .activate:
            if let _vc = R.storyboard.cardService.ncbNewOpenCardConfirmViewController() {
                _vc.setupData(data: cardData)
                _vc.delegate = self
                showBottomSheet(controller: _vc, size: 325)
            }
            break
        default:
            break
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Mở khoá/kích hoạt thẻ")
    }
    
    func converDate(str:String) ->String  {
        let date = yyyyMMdd.date(from: str)
        if let date = date {
            return MMyy.string(from: date)
        }
        return ""
    }
    
    override func otpAuthenticateSuccessfully() {
        if let vc = R.storyboard.onlinePayment.ncbCardCompletedServiceViewController() {
            if activeType == CardServiceActiveType.open{
                vc.setData(cardData, type: .openCard)
            }else{
                vc.setData(cardData, type: .activeCard)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension NCBOpenLockCardDetailViewController:NCBLockCardConfirmViewControllerDelegate{
    func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func lock() {
        var params: [String: Any] = [:]
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["userId"] = NCBShareManager.shared.getUser()!.username
        params["cardNo"] = cardData.cardno
        print(params)
        SVProgressHUD.show()
        presenter?.updateCardStatusLock(params: params)
     
    }
    
    func refuse() {
         self.navigationController?.popViewController(animated: true)
    }
}

extension NCBOpenLockCardDetailViewController:NCBNewOpenCardConfirmViewControllerDelegate {
    func faceId() {
//        if !isOpenTransactionTouchID {
//            showAlert(msg: "Vui lòng kích hoạt xác nhận giao dịch bằng \(touchMe.biometricSuffix) tại phần cài đặt trong ứng dụng")
//            return
//        }
        
        if !checkBioAvailable(touchMe, isOpen: isOpenTransactionTouchID) {
            return
        }
        
        touchMe.evaluate { [weak self] (error, msg) in
            if error == biometricSuccessCode {
                self?.doConfirm(getConfirmType())
            } else {
                if let msg = msg {
                    self?.showAlert(msg: msg)
                }
            }
        }
        
    }
    
    func optConfirm() {
       confirmType = TransactionConfirmType.OTP.rawValue
       self.doConfirm(confirmType)
    }
}

extension NCBOpenLockCardDetailViewController:NCBOTPViewControllerDelegate{
    func otpDidSelectAccept(_ otp: String) {
        var params: [String: Any] = [:]
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["userId"] = NCBShareManager.shared.getUser()!.username
        params["cardNo"] = cardData.cardno
        params["confirmType"] = confirmType
        params["confirmValue"] = otp
        params["lang"] = "vi"
        params["msgid"] = msgid
        print(params)
        
        if activeType == CardServiceActiveType.open{
             otpAuthenticate(params: params, type: TransactionType.updateCardStatusUnlockApproval)
        }else{
             otpAuthenticate(params: params, type: TransactionType.cardActiveApproval)
        }
    }
    
    func otpDidSelectResend() {
        if activeType == CardServiceActiveType.open {
            let params: [String: Any] = [
                "userId": NCBShareManager.shared.getUserID(),
                "cardNo": cardData?.cardno ?? ""
            ]
            
            otpResend(msgId: msgid, params: params, type: .updateCardStatusUnlockApproval)
        } else {
            let params: [String: Any] = [
                "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
                "userId": NCBShareManager.shared.getUserID(),
                "cardNo": cardData?.cardno ?? ""
            ]
            
            otpResend(msgId: msgid, params: params, type: .cardActiveApproval)
        }
    }
}

extension NCBOpenLockCardDetailViewController: NCBCardServicePresenterDelegate {
    
    func updateCardStatusLock(services: String?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            if let vc = R.storyboard.onlinePayment.ncbCardCompletedServiceViewController() {
                vc.setData(cardData, type: .lockCard)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func cardActiveConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            if confirmType == TransactionConfirmType.OTP.rawValue{
                if let msg = services?.msgid {
                    self.msgid = msg
                    showBottomSheet(controller: otpVC, size: NumberConstant.otpViewHeight, disablePanGesture: true)
                    otpVC.delegate = self
                }
            }else{
                if let vc = R.storyboard.onlinePayment.ncbCardCompletedServiceViewController() {
                    vc.setData(cardData, type: .activeCard)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func updateCardStatusUnlockConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?) {
        
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        if confirmType == TransactionConfirmType.OTP.rawValue{
            if let msg = services?.msgid {
                self.msgid = msg
                showBottomSheet(controller: otpVC, size: 270, disablePanGesture: true)
                otpVC.delegate = self
            }
        }else{
            if let vc = R.storyboard.onlinePayment.ncbCardCompletedServiceViewController() {
                vc.setData(cardData, type: .openCard)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
     
    }
    
    func getCrCardList(services: [NCBCardModel]?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }
    }
    
}




