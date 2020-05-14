//
//  NCBRegisterSMSBankingPresenter.swift
//  NCBApp
//
//  Created by Van Dong on 14/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBRegisterSMSBankingPresenterDelegate {
    @objc optional func getFeeRegisterSMSBanking(services: NCBFeeRegisterSMSBankingModel?, error: String?)
    @objc optional func getAccountRegisterSMS(services: [NCBAccountRegisterSMSModel]?, error: String?)
    @objc optional func getListAccount(services: NCBAccountRegisterSMSModel?, error: String?)
    @objc optional func createOTPRegisterSMSBanking(msgId: String?, error: String?)
    @objc optional func confirmRegisterSMSBanking(code: String?, error: String?)
}

class NCBRegisterSMSBankingPresenter {
    var delegate: NCBRegisterSMSBankingPresenterDelegate?
    // phí đk sms banking
    func getFeeRegisterSMSBanking() {
        let apiService = NCBRegisterSMSBankingService()
        apiService.getFeeRegisterSMSBanking(success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBFeeRegisterSMSBankingModel>().map(JSONString: resObj.body)
                self?.delegate?.getFeeRegisterSMSBanking?(services: services, error: nil)
            } else {
                self?.delegate?.getFeeRegisterSMSBanking?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getFeeRegisterSMSBanking?(services: nil, error: error)
        }
    }
    // tài khoản chưa đk sms
    func getAccountRegisterSMS(params: [String: Any]) {
        let apiService = NCBRegisterSMSBankingService()
        apiService.getAccountRegisterSMS(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBAccountRegisterSMSModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getAccountRegisterSMS?(services: services, error: nil)
            } else {
                self?.delegate?.getAccountRegisterSMS?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getAccountRegisterSMS?(services: nil, error: error)
        }
    }
    
    //OTP
    func createOTPRegisterSMSBanking(params: [String: Any]){
        let apiService = NCBRegisterSMSBankingService()
        apiService.createOTPRegisterSMSBanking(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                self?.delegate?.createOTPRegisterSMSBanking?(msgId: resObj.body, error: nil)
            } else {
             self?.delegate?.createOTPRegisterSMSBanking?(msgId: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.createOTPRegisterSMSBanking?(msgId: nil, error: error)
        }
    }
    // Confirm
    func confirmRegisterSMSBanking(params: [String: Any]){
        let apiService = NCBRegisterSMSBankingService()
        apiService.confirmRegisterSMSBanking(params: params, success: { [weak self] (response) in
            
            let resObj = DefaultRequestSuccessHandler(response)
            
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.confirmRegisterSMSBanking?(code: nil, error: nil)
            } else {
                self?.delegate?.confirmRegisterSMSBanking?(code: resObj.code, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.confirmRegisterSMSBanking?(code: nil, error: error)
        }
    }
}
