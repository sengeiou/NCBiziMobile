//
//  NCBAppConfigRequest.swift
//  NCBApp
//
//  Created by Thuan on 9/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBAppConfigRequest {
    case getBanner(params: [String : Any])
    case getVersion(params: [String : Any])
    case getAllMessage
    case termOfUse(code: String)
}

extension NCBAppConfigRequest: NCBTargetType{
    var path: String {
        switch self{
        case .getBanner(_):
            return "product-service/getBanners"
        case .getVersion(_):
            return "product-service/getVersion"
        case .getAllMessage:
            return "product-service/get-notification"
        case .termOfUse(_):
            return "product-service/useOfTerm"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .getBanner(_):
            return .get
        case .getVersion(_):
            return .get
        case .getAllMessage:
            return .get
        case .termOfUse(_):
            return .get
        }
    }
    
    var task: Task {
        switch self{
        case .getBanner(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getVersion(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getAllMessage:
            return .requestPlain
        case .termOfUse(let code):
            return .requestParameters(parameters: ["code": code], encoding: URLEncoding.default)
        }
    }
    
}
