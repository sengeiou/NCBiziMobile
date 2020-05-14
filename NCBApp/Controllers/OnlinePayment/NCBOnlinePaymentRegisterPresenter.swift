//
//  NCBOnlinePaymentRegisterPresenter.swift
//  NCBApp
//
//  Created by Thuan on 8/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBOnlinePaymentRegisterPresenterDelegate {
    func confirmCompleted(msgId: String?, error: String?)
    func unregisterCompleted(error: String?)
}

class NCBOnlinePaymentRegisterPresenter {
    
    var delegate: NCBOnlinePaymentRegisterPresenterDelegate?
    
    func doConfirm(params: [String : Any]) {
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.registerEcomConfirm(params: params, success: { [weak self] (response) in
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
    
    func unregisterEcom(params: [String : Any]) {
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.unregisterEcom(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.unregisterCompleted(error: nil)
            } else {
                self?.delegate?.unregisterCompleted(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.unregisterCompleted(error: error)
        }
    }
    
}
