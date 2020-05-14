//
//  NCBApiSoftOTPService.swift
//  NCBApp
//
//  Created by Thuan on 1/17/20.
//  Copyright © 2020 tvo. All rights reserved.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class NCBApiSoftOTPService: NCBBaseService {
    
}

extension NCBApiSoftOTPService {
    
    func register(params: [String: Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBApiSoftOTPRequest.register(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func resend(params: [String: Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBApiSoftOTPRequest.resend(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
}
