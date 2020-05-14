//
//  NCBMenuRequest.swift
//  NCBApp
//
//  Created by ADMIN on 8/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBMenuRequest {
    case getHotline(params: [String : Any])
}

extension NCBMenuRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getHotline(_):
            return "/product-service/getHotline"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHotline(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getHotline(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}
