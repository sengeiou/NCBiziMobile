//
//  NCBExchangeRateRequest.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBExchangeRateRequest {
    case getInterestRates(params: [String : Any])
    case getExchangeRates(params: [String : Any])
    case getAllBranch
    case getATM
}

extension NCBExchangeRateRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getInterestRates(_):
            return "/product-service/getInterestRates"
        case .getExchangeRates(_):
            return "/product-service/getExchangeRates"
        case .getAllBranch:
            return "/product-service/getAllBranch"
        case .getATM:
            return "/product-service/getATMLocator"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getInterestRates(_):
            return .get
        case .getExchangeRates(_):
            return .get
        case .getAllBranch:
            return .get
        case .getATM:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getInterestRates(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getExchangeRates(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getAllBranch:
            return .requestPlain
        case .getATM:
            return .requestPlain
        }
        
        
    }
    
}
