//
//  NCBChargeMoneyGenerateOTPPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/21/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBChargeMoneyGenerateOTPPresenterDelegate {
    func createOTPCodeCompleted(msgId: String?, error: String?)
}

class NCBChargeMoneyGenerateOTPPresenter {
    
    var delegate: NCBChargeMoneyGenerateOTPPresenterDelegate?
    
    func createOTPCode(params: [String : Any]) {
        let apiService = NCBChargeMoneyService()
        apiService.getTopupOTP(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.createOTPCodeCompleted(msgId: resObj.body, error: nil)
            } else {
                self?.delegate?.createOTPCodeCompleted(msgId: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.createOTPCodeCompleted(msgId: nil, error: error)
        }
    }
}
