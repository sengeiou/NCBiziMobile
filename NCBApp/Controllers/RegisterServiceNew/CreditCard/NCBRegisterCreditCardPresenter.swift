//
//  NCBRegisterCreditCardPresenter.swift
//  NCBApp
//
//  Created by Thuan on 9/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBRegisterCreditCardPresenterDelegate {
    func getCardProductsCompleted(_ products: [NCBGetListCardProductVisaModel]?, error: String?)
    func registerCardVisaCompleted(error: String?)
}

class NCBRegisterCreditCardPresenter {
    
    var delegate: NCBRegisterCreditCardPresenterDelegate?
    
    func getCardProducts() {
        let service = NCBRegisterServiceNewService()
        service.getCardProducts(success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let products = Mapper<NCBGetListCardProductVisaModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getCardProductsCompleted(products, error: nil)
            } else {
                self?.delegate?.getCardProductsCompleted(nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getCardProductsCompleted(nil, error: error)
        }
    }
    
    func registerCardVisa(params: [String : Any]) {
        let service = NCBRegisterServiceNewService()
        service.registerCardVisa(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.registerCardVisaCompleted(error: nil)
            } else {
                self?.delegate?.registerCardVisaCompleted(error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.registerCardVisaCompleted(error: error)
        }
    }
    
}

