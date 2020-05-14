//
//  NCBVerifyCreditCardPaymentPresenter.swift
//  NCBApp
//
//  Created by Thuan on 8/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBVerifyCreditCardPaymentPresenterDelegate {
    func confirmCompleted(msgId: String?, error: String?)
}

class NCBVerifyCreditCardPaymentPresenter {
    
    var delegate: NCBVerifyCreditCardPaymentPresenterDelegate?
    
    func doConfirm(params: [String : Any]) {
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.cardPaymentConfirm(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dict = resObj.body.convertToDictionary()
                self?.delegate?.confirmCompleted(msgId: dict?["msgid"] as? String, error: nil)
            } else {
                self?.delegate?.confirmCompleted(msgId: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.confirmCompleted(msgId: nil, error: error)
        }
    }
    
}
