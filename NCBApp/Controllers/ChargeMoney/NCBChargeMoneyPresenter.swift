//
//  NCBChargeMoneyPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/19/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBChargeMoneyPresenterDelegate {
    func getTopupTypeCompleted(success: String?, error: String?)
}

class NCBChargeMoneyPresenter {
    
    var delegate: NCBChargeMoneyPresenterDelegate?
    
    func chargeAirpay(params: [String : Any]) {
        let apiService = NCBChargeMoneyService()
        apiService.chargeAirpay(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.getTopupTypeCompleted(success: resObj.body, error: nil)
            } else {
                self?.delegate?.getTopupTypeCompleted(success: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getTopupTypeCompleted(success: nil, error: error)
        }
    }
}
