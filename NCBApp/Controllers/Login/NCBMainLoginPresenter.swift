//
//  NCBMainLoginPresenter.swift
//  NCBApp
//
//  Created by Thuan on 4/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBMainLoginPresenterDelegate {
    @objc optional func loginCompleted(error: String?)
    @objc optional func getProfileCompleted(error: String?)
    @objc optional func updatePasswordCompleted(success: String?, error: String?)
    @objc optional func changePassWhenActiveCompleted(success: String?, error: String?)
    @objc optional func generateLoginOTPCompleted(msgId: String?, error: String?)
    @objc optional func validateLoginOTPCompleted(success: String?, error: String?)
    @objc optional func updateProfileStatusCompleted(success: String?, error: String?)
    @objc optional func changePassGenerateOtp(services: NCBGenerateOTPModel?, error: String?)
    @objc optional func needUpdatePass(error: String?)
    @objc optional func verifyOldPass(error: String?)
}

class NCBMainLoginPresenter: NSObject {
    
    var delegate: NCBMainLoginPresenterDelegate?
    
    func userLogin(params: [String: Any]) {
        let apiUserService = NCBApiUserService()
        apiUserService.userLogin(params: params, success: { [weak self] (response) in
            if let object = response.dictionaryObject {
                NCBShareManager.shared.setAccessToken(object["access_token"] as? String)
                NCBShareManager.shared.setRefreshToken(object["refresh_token"] as? String)
            }
            self?.delegate?.loginCompleted?(error: nil)
        }) { [weak self] (error) in
            self?.delegate?.loginCompleted?(error: error?.getMessage() ?? error)
        }
    }
    
    func userGetProfile() {
        let apiUserService = NCBApiUserService()
        apiUserService.userGetProfile(deviceId: getUUID(), success: { [weak self] (response) in
            if let object = response.dictionaryObject {
                
                let userModel = Mapper<NCBUserModel>().map(JSONObject: object)
                NCBShareManager.shared.setUser(userModel)
                self?.delegate?.getProfileCompleted?(error: nil)
            }
        }) { [weak self] (error) in
            self?.delegate?.getProfileCompleted?(error: error?.getMessage() ?? error)
        }
    }
    
    func updatePassword(params: [String : Any]) {
        let apiUserService = NCBApiUserService()
        apiUserService.updatePassword(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            print(resObj)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                self?.delegate?.updatePasswordCompleted?(success: resObj.body, error: nil)
            } else {
                self?.delegate?.updatePasswordCompleted?(success: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.updatePasswordCompleted?(success: nil, error: error)
        }
    }
    
    func updatePass4Active(params: [String : Any]) {
        let apiUserService = NCBApiUserService()
        apiUserService.updatePass4Active(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.changePassWhenActiveCompleted?(success: resObj.body, error: nil)
            } else {
                self?.delegate?.changePassWhenActiveCompleted?(success: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.changePassWhenActiveCompleted?(success: nil, error: error)
        }
    }
    func generateotp(params: [String : Any]) {
        let apiUserService = NCBApiUserService()
        apiUserService.generateotp(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dict = resObj.body.convertToDictionary()
                self?.delegate?.generateLoginOTPCompleted?(msgId: dict?["msgID"] as? String, error: nil)
            } else {
                self?.delegate?.generateLoginOTPCompleted?(msgId: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.generateLoginOTPCompleted?(msgId: nil, error: error)
        }
    }
    
    func changePassGenerateOtp(params: [String : Any]) {
        let apiUserService = NCBApiUserService()
        apiUserService.generateotp(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBGenerateOTPModel>().map(JSONString: resObj.body)
                self?.delegate?.changePassGenerateOtp?(services: services, error: nil)
            } else {
                 self?.delegate?.changePassGenerateOtp?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.changePassGenerateOtp?(services: nil, error: error)
        }
    }
    
    func validotp(params: [String : Any]) {
        let apiUserService = NCBApiUserService()
        apiUserService.validotp(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.validateLoginOTPCompleted?(success: resObj.body, error: nil)
            } else {
                self?.delegate?.validateLoginOTPCompleted?(success: resObj.code, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.validateLoginOTPCompleted?(success: nil, error: error)
        }
    }
    func updateProfileStatus(params: [String : Any]) {
        let apiUserService = NCBApiUserService()
        apiUserService.updateProfileStatus(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.updateProfileStatusCompleted?(success: resObj.body, error: nil)
            } else {
                 self?.delegate?.updateProfileStatusCompleted?(success: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.updateProfileStatusCompleted?(success: nil, error: error)
        }
    }
    
    func needUpdatePass() {
        let apiUserService = NCBApiUserService()
        apiUserService.needUpdatePass(success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                 self?.delegate?.needUpdatePass?(error: nil)
            } else {
                self?.delegate?.needUpdatePass?(error: resObj.body)
            }
        }) { [weak self] (error) in
            self?.delegate?.needUpdatePass?(error: error)
        }
    }
    func verifyOldPass(params: [String : Any]) {
        let apiUserService = NCBApiUserService()
        apiUserService.verifyOldPass(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.verifyOldPass?(error: nil)
            } else {
                self?.delegate?.verifyOldPass?(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.verifyOldPass?(error: error)
        }
    }
    
}



