//
//  NCBRegisterServiceNewService.swift
//  NCBApp
//
//  Created by Thuan on 8/27/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class NCBRegisterServiceNewService : NCBBaseService {
    
}

extension NCBRegisterServiceNewService {
    
    func getPurposes(success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBRegisterServiceNewRequest.getPurposes
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func registerLoan(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBRegisterServiceNewRequest.registerLoan(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func getCardProducts(success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBRegisterServiceNewRequest.getCardProducts
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func registerCardVisa(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBRegisterServiceNewRequest.registerCardVisa(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
}
