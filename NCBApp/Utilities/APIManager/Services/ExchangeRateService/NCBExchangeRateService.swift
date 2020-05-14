//
//  NCBExchangeRateService.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class NCBExchangeRateService : NCBBaseService {
    
}

extension NCBExchangeRateService {
    
    func getInterestRates(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBExchangeRateRequest.getInterestRates(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func getExchangeRates(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBExchangeRateRequest.getExchangeRates(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func getAllBranch(success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBExchangeRateRequest.getAllBranch
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func getATM(success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBExchangeRateRequest.getATM
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
}
