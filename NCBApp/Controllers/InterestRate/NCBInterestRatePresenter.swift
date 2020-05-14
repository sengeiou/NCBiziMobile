//
//  NCBInterestRatePresenter.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBInterestRatePresenterDelegate {
    func getInterestRatesCompleted(_ interestRate: NCBInterestRateModel?, error: String?)
}

class NCBInterestRatePresenter {
    
    var delegate: NCBInterestRatePresenterDelegate?
    
    func getInterestRates(params: [String : Any]) {
        let apiService = NCBExchangeRateService()
        apiService.getInterestRates(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let interestRate = Mapper<NCBInterestRateModel>().map(JSONString: resObj.body)
                self?.delegate?.getInterestRatesCompleted(interestRate, error: nil)
            } else {
                self?.delegate?.getInterestRatesCompleted(nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getInterestRatesCompleted(nil, error: error)
        }
    }
    
}
