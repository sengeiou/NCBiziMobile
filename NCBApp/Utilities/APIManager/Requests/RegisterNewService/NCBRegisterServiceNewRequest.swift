//
//  NCBRegisterServiceNewRequest.swift
//  NCBApp
//
//  Created by Thuan on 8/27/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBRegisterServiceNewRequest {
    case getPurposes
    case registerLoan(params: [String : Any])
    case getCardProducts
    case registerCardVisa(params: [String : Any])
}

extension NCBRegisterServiceNewRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getPurposes:
            return "/product-service/getInfoRegisterLoan"
        case .registerLoan(_):
            return "/product-service/registerLoan"
        case .getCardProducts:
            return "/product-service/get-list-card-product-visa"
        case .registerCardVisa(_):
            return "/product-service/create-card-visa"
        }
    }
    
    
    var method: Moya.Method {
        switch self {
        case .getPurposes:
            return .get
        case .registerLoan(_):
            return .post
        case .getCardProducts:
            return .get
        case .registerCardVisa(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getPurposes:
            return .requestPlain
        case .registerLoan(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getCardProducts:
            return .requestPlain
        case .registerCardVisa(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}
