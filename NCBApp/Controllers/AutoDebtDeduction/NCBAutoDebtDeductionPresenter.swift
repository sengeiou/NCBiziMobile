//
//  NCBAutoDebtDeductionPresenter.swift
//  NCBApp
//
//  Created by Thuan on 9/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBAutoDebtDeductionPresenterDelegate {
    func checkAutoDebitCompleted(error: String?)
}

class NCBAutoDebtDeductionPresenter {
    
    var delegate: NCBAutoDebtDeductionPresenterDelegate?
    
    func checkAutoDebit(params: [String : Any]) {
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.checkCardAutoDebit(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.checkAutoDebitCompleted(error: nil)
            } else {
                self?.delegate?.checkAutoDebitCompleted(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.checkAutoDebitCompleted(error: error)
        }
    }
    
}
