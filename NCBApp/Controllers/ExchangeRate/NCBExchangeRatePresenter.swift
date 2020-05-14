//
//  NCBExchangeRatePresenter.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBExchangeRatePresenterDelegate {
    func getExchangeRatesCompleted(_ exchangeRate: NCBExchangeRateModel?, error: String?)
}

class NCBExchangeRatePresenter {
    
    var delegate: NCBExchangeRatePresenterDelegate?
    
    func getExchangeRates(params: [String : Any]) {
        let apiService = NCBExchangeRateService()
        apiService.getExchangeRates(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let exchangeRate = Mapper<NCBExchangeRateModel>().map(JSONString: resObj.body)
                self?.delegate?.getExchangeRatesCompleted(exchangeRate, error: nil)
            } else {
                self?.delegate?.getExchangeRatesCompleted(nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getExchangeRatesCompleted(nil, error: error)
        }
    }
    
}
