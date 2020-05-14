//
//  NCBChargeAirpayPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/19/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBChargeAirpayPresenterDelegate {
    func chargeAirpayCompleted(success: String?, error: String?)
    func getBenitTopup(success: [NCBBenitTopupModel]?, error: String?)
}

class NCBChargeAirpayPresenter {
    
    var delegate: NCBChargeAirpayPresenterDelegate?
    
    func chargeAirpay(params: [String : Any]) {
        let apiService = NCBChargeMoneyService()
        apiService.chargeAirpay(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.chargeAirpayCompleted(success: resObj.body, error: nil)
            } else {
                self?.delegate?.chargeAirpayCompleted(success: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.chargeAirpayCompleted(success: nil, error: error)
        }
    }
    
    func getBenitTopup(params: [String : Any]) {
        let apiService = NCBChargeMoneyService()
        apiService.getBenitTopup(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            //print(params)
            print(resObj.body)
            if resObj.code == ResponseCodeConstant.success {
                 let dataModels = Mapper<NCBBenitTopupModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getBenitTopup(success: dataModels, error: nil)
            } else {
                self?.delegate?.getBenitTopup(success: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getBenitTopup(success: nil, error: error)
        }
    }
}
