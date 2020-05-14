//
//  NCBTouchIDRequest.swift
//  NCBApp
//
//  Created by Thuan on 6/4/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBApiTouchIDRequest {
    case register(params: [String: Any], type: TouchIDType)
    case delete(params: [String: Any], type: TouchIDType)
    case checkStatus(params: [String: Any])
}

extension NCBApiTouchIDRequest: NCBTargetType {
    
    var headers: [String : String]? {
        var headers: [String: String] = [:]
        headers["Authorization"] = authorization
        headers["Content-Type"] = contentTypeJson
        return headers
    }
    
    var path: String {
        switch self {
        case .register(_, let type):
            switch type {
            case .login:
                return "/api/v1/touchId/RegTouchId"
            case .transaction:
                return "/api/v1/touchId/RegTouchId4Transfer"
            }
        case .delete(_,  let type):
            switch type {
            case .login:
                return "/api/v1/touchId/DelTouchId"
            case .transaction:
                return "/api/v1/touchId/DelTouchId4Transfer"
            }
        case .checkStatus(_):
            return "/api/v1/touchId/settingTouchID"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register(_, _):
            return .post
        case .delete(_, _):
            return .post
        case .checkStatus(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .register(let params, _):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .delete(let params, _):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .checkStatus(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
}
