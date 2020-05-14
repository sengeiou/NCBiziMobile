//
//  NCBCharityService.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class NCBCharityService: NCBBaseService {
    
}

extension NCBCharityService {
    
    func getCharityFundList(params: [String: Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBCharityRequest.getListCharityFundAccount(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
}
