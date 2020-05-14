//
//  NCBApiSoftOTPRequest.swift
//  NCBApp
//
//  Created by Thuan on 1/17/20.
//  Copyright © 2020 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBApiSoftOTPRequest {
    case register(params: [String: Any])
    case resend(params: [String: Any])
}

extension NCBApiSoftOTPRequest: NCBTargetType {
    
    var headers: [String : String]? {
        var headers: [String: String] = [:]
        headers["Authorization"] = authorization
        headers["Content-Type"] = contentTypeUrlencoded
        return headers
    }
    
    var path: String {
        switch self {
        case .register(_):
            return "/common-info-service/register/request-soft-otp"
        case .resend(_):
            return "/common-info-service/register/request-active-code-soft-otp"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register(_):
            return .post
        case .resend(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .register(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .resend(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}
