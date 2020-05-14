//
//  NCBSettingsPresenter.swift
//  NCBApp
//
//  Created by Thuan on 6/4/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBSettingsPresenterDelegate {
    func registerForLoginCompleted(error: String?, msg: String?)
    func deleteForLoginCompleted(error: String?, msg: String?)
    func registerForTransactionCompleted(error: String?, msg: String?)
    func deleteForTransactionCompleted(error: String?, msg: String?)
    func checkStatusCompleted(status: NCBTouchIDStatusModel?, error: String?)
    func registerSoftOTPCompleted(error: String?, msgId: String?)
    func resendSoftOTPCompleted(error: String?, msgId: String?)
}

class NCBSettingsPresenter {
    
    var delegate: NCBSettingsPresenterDelegate?
    
    func registerForLogin(params: [String: Any]) {
        let touchIDService = NCBApiTouchIDService()
        touchIDService.register(params: params, type: .login, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                NCBKeychainService.saveLoginTouchID(data: resObj.body)
                self?.delegate?.registerForLoginCompleted(error: nil, msg: resObj.description)
            } else {
                self?.delegate?.registerForLoginCompleted(error: resObj.description, msg: nil)
            }
        }) { [weak self] (error) in
            self?.delegate?.registerForLoginCompleted(error: error, msg: nil)
        }
    }
    
    func deleteForLogin(params: [String: Any]) {
        let touchIDService = NCBApiTouchIDService()
        touchIDService.delete(params: params, type: .login, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                NCBKeychainService.removeLoginTouchID()
                self?.delegate?.deleteForLoginCompleted(error: nil, msg: resObj.description)
            } else {
                self?.delegate?.deleteForLoginCompleted(error: resObj.description, msg: nil)
            }
        }) { [weak self] (error) in
            self?.delegate?.deleteForLoginCompleted(error: error, msg: nil)
        }
    }
    
    func registerForTransaction(params: [String: Any]) {
        let touchIDService = NCBApiTouchIDService()
        touchIDService.register(params: params, type: .transaction, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                NCBKeychainService.saveTransactionTouchID(data: resObj.body)
                self?.delegate?.registerForTransactionCompleted(error: nil, msg: resObj.description)
            } else {
                self?.delegate?.registerForTransactionCompleted(error: resObj.description, msg: nil)
            }
        }) { [weak self] (error) in
            self?.delegate?.registerForTransactionCompleted(error: error, msg: nil)
        }
    }
    
    func deleteForTransaction(params: [String: Any]) {
        let touchIDService = NCBApiTouchIDService()
        touchIDService.delete(params: params, type: .transaction, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                NCBKeychainService.removeTransactionTouchID()
                self?.delegate?.deleteForTransactionCompleted(error: nil, msg: resObj.description)
            } else {
                self?.delegate?.deleteForTransactionCompleted(error: resObj.description, msg: nil)
            }
        }) { [weak self] (error) in
            self?.delegate?.deleteForTransactionCompleted(error: error, msg: nil)
        }
    }
    
    func checkStatus(params: [String: Any]) {
        let touchIDService = NCBApiTouchIDService()
        touchIDService.checkStatus(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let status = Mapper<NCBTouchIDStatusModel>().map(JSONString: resObj.body)
                self?.delegate?.checkStatusCompleted(status: status, error: nil)
            } else {
                self?.delegate?.checkStatusCompleted(status: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.checkStatusCompleted(status: nil, error: error)
        }
    }
    
    func registerSoftOTP(params: [String: Any]) {
        let service = NCBApiSoftOTPService()
        service.register(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dict = resObj.body.convertToDictionary()
                self?.delegate?.registerSoftOTPCompleted(error: nil, msgId: dict?["msgid"] as? String)
            } else {
                self?.delegate?.registerSoftOTPCompleted(error: resObj.description, msgId: nil)
            }
        }) { [weak self] (error) in
            self?.delegate?.registerSoftOTPCompleted(error: error, msgId: nil)
        }
    }
    
    func resendSoftOTP(params: [String: Any]) {
        let service = NCBApiSoftOTPService()
        service.resend(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dict = resObj.body.convertToDictionary()
                self?.delegate?.resendSoftOTPCompleted(error: nil, msgId: dict?["msgid"] as? String)
            } else {
                self?.delegate?.resendSoftOTPCompleted(error: resObj.description, msgId: nil)
            }
        }) { [weak self] (error) in
            self?.delegate?.resendSoftOTPCompleted(error: error, msgId: nil)
        }
    }
    
}
