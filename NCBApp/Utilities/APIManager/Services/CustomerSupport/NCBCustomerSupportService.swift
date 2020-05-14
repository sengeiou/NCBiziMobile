//
//  NCBQuestionAnswerService.swift
//  NCBApp
//
//  Created by Van Dong on 08/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class NCBCustomerSupportService : NCBBaseService {
    
}

extension NCBCustomerSupportService {
    //câu hỏi thường gặp
    func getQuestionAnswer(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBCustomerSupportRequest.getQuestionAnswer(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    //hướng dẫn sử dụng
    func getUserGuide(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBCustomerSupportRequest.getUserGuide(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    // thông tin khách hàng
    func getCustomerInfomation(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBCustomerSupportRequest.getCustomerInfomation(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func getDataOptionFeedback(success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBCustomerSupportRequest.getDataOptionFeedback
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func sendFeedback(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBCustomerSupportRequest.sendFeedback(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
}
