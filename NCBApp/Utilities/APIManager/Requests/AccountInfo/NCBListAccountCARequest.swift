//
//  NCBListAccountCARequest.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBAccountRequest {
    case getListAccountCA(params: [String : Any])
    case getAccountDetail(params: [String: Any])
}

extension NCBAccountRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getListAccountCA(_):
            return "/common-info-service/account/find-account-by-cif"
        case .getAccountDetail(_):
            return "/common-info-service/account/detail-info-account-ca"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getListAccountCA(_):
            return .get
        case .getAccountDetail(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getListAccountCA(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getAccountDetail(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}
