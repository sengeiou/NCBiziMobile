//
//  NCBDebtAccountRequest.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBDebtAccountRequest {
    case getListDebtAccount(params: [String : Any])
    case getDetailDebtAccount(params: [String : Any])
}

extension NCBDebtAccountRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getDetailDebtAccount(_):
            return "loan-service/loan/loan-detail"
        case .getListDebtAccount:
            return "loan-service/loan/find-account-loan"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getListDebtAccount(_):
            return .get
        case .getDetailDebtAccount(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getListDebtAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .getDetailDebtAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        }
    }
}
