//
//  NCBRegisterSMSBankingService.swift
//  NCBApp
//
//  Created by Van Dong on 14/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class NCBRegisterSMSBankingService : NCBBaseService {
    
}
extension NCBRegisterSMSBankingService{
    //phí đk sms banking
    func getFeeRegisterSMSBanking(success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBRegisterSMSBankingRequest.getFeeRegisterSMSBanking
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    // tài khoản chưa đk sms
    func getAccountRegisterSMS(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBRegisterSMSBankingRequest.getAccountRegisterSMS(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    // OTP
    func createOTPRegisterSMSBanking(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBRegisterSMSBankingRequest.createOTPRegisterSMSBanking(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    //confirm
    func confirmRegisterSMSBanking(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBRegisterSMSBankingRequest.confirmRegisterSMSBanking(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
}
