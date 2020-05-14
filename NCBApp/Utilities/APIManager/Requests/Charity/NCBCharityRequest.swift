//
//  NCBCharityRequest.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBCharityRequest {
    case getListCharityFundAccount(params: [String : Any])
}

extension NCBCharityRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getListCharityFundAccount(_):
            return "/fund-transfer-service/transfer/get-charity-account"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getListCharityFundAccount(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getListCharityFundAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        }
    }
}
