//
//  NCBCreditCardPaymentPresenter.swift
//  NCBApp
//
//  Created by Thuan on 8/5/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBCreditCardPaymentPresenterDelegate {
    @objc optional func getBillDateCompleted(billDate: String?, error: String?)
    @objc optional func getPaymentOptionalCompleted(optional: NCBCreditCardPaymentOptionalModel?, error: String?)
    @objc optional func getCardInfoCompleted(card: NCBCreditCardModel?, error: String?)
}

class NCBCreditCardPaymentPresenter {
    
    var delegate: NCBCreditCardPaymentPresenterDelegate?
    
    func getBillDate(params: [String : Any]) {
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.getBillDate(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.getBillDateCompleted?(billDate: resObj.body, error: nil)
            } else {
                self?.delegate?.getBillDateCompleted?(billDate: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getBillDateCompleted?(billDate: nil, error: error)
        }
    }
    
    func getPaymentOptional(params: [String : Any]) {
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.getPaymentOptional(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let model = Mapper<NCBCreditCardPaymentOptionalModel>().map(JSONString: resObj.body)
                self?.delegate?.getPaymentOptionalCompleted?(optional: model, error: nil)
            } else {
                self?.delegate?.getPaymentOptionalCompleted?(optional: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getPaymentOptionalCompleted?(optional: nil, error: error)
        }
    }
    
    func getCardInfo(params: [String : Any]) {
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.getCardInfo(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let card = Mapper<NCBCreditCardModel>().map(JSONString: resObj.body)
                self?.delegate?.getCardInfoCompleted?(card: card, error: nil)
            } else {
                self?.delegate?.getCardInfoCompleted?(card: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getCardInfoCompleted?(card: nil, error: error)
        }
    }
    
}
