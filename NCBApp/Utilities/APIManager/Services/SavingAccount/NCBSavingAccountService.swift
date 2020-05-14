//
//  NCBSavingAccountService.swift
//  NCBApp
//
//  Created by Van Dong on 23/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class NCBSavingAccountServiceRepair : NCBBaseService {
    
}
extension NCBSavingAccountServiceRepair{
    func createOTPSavingAccountAddAmount(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBSavingAccountRequestRepair.createOTPSavingAccountAddAmount(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
}
