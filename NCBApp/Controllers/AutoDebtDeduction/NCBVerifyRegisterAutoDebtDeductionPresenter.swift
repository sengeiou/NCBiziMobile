//
//  NCBVerifyRegisterAutoDebtDeductionPresenter.swift
//  NCBApp
//
//  Created by Thuan on 8/14/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBVerifyRegisterAutoDebtDeductionPresenterDelegate {
    func confirmCompleted(msgId: String?, error: String?)
}

class NCBVerifyRegisterAutoDebtDeductionPresenter {
    
    var delegate: NCBVerifyRegisterAutoDebtDeductionPresenterDelegate?
    
    func doConfirm(params: [String : Any]) {
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.autoDebtDeductionConfirm(params: params, success: { [weak self] (response) in
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
