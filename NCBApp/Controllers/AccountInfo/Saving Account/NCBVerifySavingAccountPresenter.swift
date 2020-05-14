//
//  NCBVerifySavingAccountPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/20/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBVerifySavingAccountPresenterDelegate {
    @objc optional func confirmSavingAccountActionCompleted(success: String?, error: String?)
    @objc optional func getMsgIdFromOTPCompleted(msgId: String?, error: String?)
//    func postFinalSettlementSavingAccountCompleted(success: String?, error: String?)
//    func resendOTPCompleted(error: String?)
    @objc optional func generateOTPAcumulation(msgId: String?, error: String?)
}

class NCBVerifySavingAccountPresenter {
    
    var delegate: NCBVerifySavingAccountPresenterDelegate?
    
    func confirmSavingAccountAction(params: [String : Any]) {
        let apiSavingAccountService = NCBTotalSavingAccountService()
        apiSavingAccountService.confirmOpenSavingAccount(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.confirmSavingAccountActionCompleted?(success: resObj.body, error: nil)
            } else {
                self?.delegate?.confirmSavingAccountActionCompleted?(success: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.confirmSavingAccountActionCompleted?(success: nil, error: error)
        }
    }
    
    func generateOTPFinalSettlementAccount(params: [String : Any]) {
        let apiTotalSavingAccountService = NCBTotalSavingAccountService()
        apiTotalSavingAccountService.generateOTPFinalSettlementSavingAccount(params: params, success: { (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                self.delegate?.getMsgIdFromOTPCompleted?(msgId: resObj.body, error: nil)
            } else {
                self.delegate?.getMsgIdFromOTPCompleted?(msgId: nil, error: resObj.description)
            }
        }, failure: {[weak self] (error) in
            self?.delegate?.getMsgIdFromOTPCompleted?(msgId: nil, error: error)
        })
    }
    
    func generateOTPAcumulation(params: [String : Any]) {
        let apiTotalSavingAccountService = NCBTotalSavingAccountService()
        apiTotalSavingAccountService.generateOTPAcumulation(params: params, success: { (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            print(resObj.body)
            if resObj.code == ResponseCodeConstant.success {
                self.delegate?.generateOTPAcumulation?(msgId: resObj.body, error: nil)
            } else {
                self.delegate?.generateOTPAcumulation?(msgId: nil, error: resObj.description)
            }
        }, failure: {[weak self] (error) in
            self?.delegate?.generateOTPAcumulation?(msgId: nil, error: error)
        })
    }
    
}


