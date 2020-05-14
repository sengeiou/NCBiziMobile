//
//  NCBOTPAuthenticationPresenter.swift
//  NCBApp
//
//  Created by Thuan on 5/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

enum TransferLimitType: Int {
    case min = 0
    case max
}

enum BalanceTransferType: Int {
    case transfer = 0
    case card
    case rechargeMoney
}

@objc protocol NCBOTPAuthenticationPresenterDelegate {
    @objc optional func otpAuthenticationCompleted(code: String?, error: String?)
    @objc optional func otpResendCompleted(error: String?, msgId: String?)
    @objc optional func getTransferLimitCompleted(error: String?)
    @objc optional func checkBalanceTransferCompleted(error: String?)
    @objc optional func refreshTokenCompleted(error: String?)
}

class NCBOTPAuthenticationPresenter {
    
    var delegate: NCBOTPAuthenticationPresenterDelegate?
    var transferLimitList: [NCBTransferLimitModel]?
    fileprivate var biometricIDAuth = BiometricIDAuth()
    var transferLimitValue = ""
    var approvalSuccessBody = ""
    var approvalSuccessCode = ""
    var approvalSuccessDescription = ""
    
    func otpAuthenticate(params: [String : Any], type: TransactionType) {
        let apiService = NCBApiOTPService()
        apiService.approvalTransferInfo(params: params, type: type, success: { [weak self] (response) in
        
            let resObj = DefaultRequestSuccessHandler(response)
            
            if resObj.code == ResponseCodeConstant.success || resObj.code == ResponseCodeConstant.t24TimeOuted {
                if type == .openAccountOnline {
                    self?.approvalSuccessBody = resObj.body
                }
                self?.approvalSuccessCode = resObj.code
                self?.approvalSuccessDescription = resObj.description
                self?.delegate?.otpAuthenticationCompleted?(code: nil, error: nil)
            } else {
                self?.delegate?.otpAuthenticationCompleted?(code: resObj.code, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.otpAuthenticationCompleted?(code: nil, error: error)
        }
    }
    
    func otpResend(params: [String : Any], type: TransactionType = .none) {
        let apiService = NCBApiOTPService()
        apiService.resendOTP(params: params, type: type, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let otp = Mapper<NCBGenerateOTPModel>().map(JSONString: resObj.body)
                self?.delegate?.otpResendCompleted?(error: nil, msgId: otp?.msgID)
            } else {
                self?.delegate?.otpResendCompleted?(error: resObj.description, msgId: nil)
            }
        }) { [weak self] (error) in
            self?.delegate?.otpResendCompleted?(error: error, msgId: nil)
        }
    }
    
    func getTransferLimit() {
        let params = [
            "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
            "username": NCBShareManager.shared.getUser()?.username ?? ""
        ]
        
        let apiService = NCBApiOTPService()
        apiService.getTransferLimit(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.transferLimitList = Mapper<NCBTransferLimitModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getTransferLimitCompleted?(error: nil)
            } else {
                self?.delegate?.getTransferLimitCompleted?(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getTransferLimitCompleted?(error: error)
        }
    }
    
    func exceedLimit(_ amount: Double, type: TransactionType) -> Bool {
        guard let transferLimitList = transferLimitList else {
            return false
        }
        
        for transferLimit in transferLimitList {
            if transferLimit.type_id == getTypeID(type) {
                var limit = 0.0
                switch biometricIDAuth.biometricType() {
                case .faceID:
                    limit = transferLimit.limit_faceid ?? 0.0
                default:
                    limit = transferLimit.limit_finger ?? 0.0
                }
                return (amount > limit)
            }
        }
        
        return false
    }
    
    func invalidTransferAmount(_ amount: Double, type: TransactionType, limitType: TransferLimitType) -> Bool {
        guard let transferLimitList = transferLimitList else {
            return false
        }
        
        for transferLimit in transferLimitList {
            if transferLimit.type_id == getTypeID(type) {
                switch limitType {
                case .min:
                    let min = transferLimit.min ?? 0.0
                    transferLimitValue = min.formattedWithDotSeparator
                    return (amount < min)
                case .max:
                    let max = transferLimit.max ?? 0.0
                    transferLimitValue = max.formattedWithDotSeparator
                    return (amount > max)
                }
            }
        }
        
        return false
    }
    
    fileprivate func getTypeID(_ type: TransactionType) -> String {
        switch type {
        case .internalTransfer:
            return "URT"
        case .citad:
            return "IBT"
        case .fast247:
            return "ISL"
        case .topupPhoneNumb:
            return "TOP"
        case .topupAirPay:
            return "EWL"
        case .payBillingNapas, .payBillingPayoo, .payBillingVNPAY:
            return "BILL"
        case .additionalSavingAccount:
            return "PLUS"
        case .creditCardPayment:
            return "VPMT"
        default:
            return ""
        }
    }
    
    func checkBalance(_ params: [String: Any], type: BalanceTransferType) {
        let apiService = NCBApiOTPService()
        apiService.checkBalance(params: params, type: type, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.checkBalanceTransferCompleted?(error: nil)
            } else {
                self?.delegate?.checkBalanceTransferCompleted?(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.checkBalanceTransferCompleted?(error: error)
        }
    }
    
    func refreshToken() {
        let params: [String: Any] = [
            "grant_type": "refresh_token",
            "refresh_token": NCBShareManager.shared.getRefreshToken() ?? ""
        ]
        
        let apiService = NCBApiOTPService()
        apiService.refreshToken(params: params, success: { [weak self] (response) in
            if let object = response.dictionaryObject {
                NCBShareManager.shared.setAccessToken(object["access_token"] as? String)
                NCBShareManager.shared.setRefreshToken(object["refresh_token"] as? String)
            }
            self?.delegate?.refreshTokenCompleted?(error: nil)
        }) { [weak self] (error) in
            self?.delegate?.refreshTokenCompleted?(error: error?.getMessage() ?? error)
        }
    }
    
}
