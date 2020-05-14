//
//  File.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/19/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBChargeMoneyRequest {
    case getTopupService(params: [String : Any])
    case getTopupCardValues
    case getTopupOTP(params: [String : Any])
    case getBenitTopup(params: [String : Any])
    
}

extension NCBChargeMoneyRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getTopupService(_):
            return "/payment-service/paybill/list-serviceMbapp"
        case .getTopupCardValues:
            return "/payment-service/topup/topupCardValues"
        case .getTopupOTP(_):
            return "/payment-service/topup/generateOTPTopup"
        case .getBenitTopup(_):
            return "/payment-service/topup/getBenitTopup"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTopupService(_):
            return .get
        case .getTopupCardValues:
            return .get
        case .getTopupOTP(_):
            return .post
        case .getBenitTopup(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getTopupService(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getTopupCardValues:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
        case .getTopupOTP(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getBenitTopup(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
        
        
    }
    
}
