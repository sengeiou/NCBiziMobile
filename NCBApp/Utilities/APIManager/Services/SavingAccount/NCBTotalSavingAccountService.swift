//
//  NCBGetSavingConfigService.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SwiftyJSON
import TSCollection
import Alamofire
import ObjectMapper

class NCBTotalSavingAccountService: NCBBaseService {
    
}

extension NCBTotalSavingAccountService {
    
    func getSavingConfig(success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBApiGetTotalSavingAccountRequest.getSavingConfig
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func getInterestRate(params: [String: Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBApiGetTotalSavingAccountRequest.getInterestAccount(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func getListFinalSettlementSavingAccount(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBApiGetTotalSavingAccountRequest.getListFinalSettlementSavingAccount(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func getDetailFinalSettlementSavingAccount(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBApiGetTotalSavingAccountRequest.getDetailFinalSettlementSavingAccount(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func generateOTPFinalSettlementSavingAccount(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let postRequest = NCBApiGetTotalSavingAccountRequest.generateOTPFinalSettlementSavingAccount(params: params)
        TSApiManager.shared.request(api: postRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func postFinalSettlementSavingAccount(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let postRequest = NCBApiGetTotalSavingAccountRequest.postFinalSettlementSavingAccount(params: params)
        TSApiManager.shared.request(api: postRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func confirmFinalSettlementSavingAccount(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBApiGetTotalSavingAccountRequest.confirmFinalSettlementSavingAccount(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func confirmOpenSavingAccount(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let postRequest = NCBApiGetTotalSavingAccountRequest.confirmOpenSavingAccount(params: params)
        TSApiManager.shared.request(api: postRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    func confirmAdditionalAmountSavingAccount(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let postRequest = NCBApiGetTotalSavingAccountRequest.confirmAddtionalAmount(params: params)
        TSApiManager.shared.request(api: postRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func getCurrentRate(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let getRequest = NCBApiGetTotalSavingAccountRequest.getCurrentRate(params: params)
        TSApiManager.shared.request(api: getRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    func generateOTPAcumulation(params: [String : Any], success: RequestSuccessWithDataClosure? = nil, failure: RequestFailureClosure? = nil) {
        let postRequest = NCBApiGetTotalSavingAccountRequest.generateOTPAcumulation(params: params)
        TSApiManager.shared.request(api: postRequest,
                                    nextHandler: { (response) in
                                        success?(response)
        }) { (errorResponse) in
            let error = DefaultRequestFailureHandler(errorResponse)
            failure?(error)
        }
    }
    
    
    
    
    
    
    
}
