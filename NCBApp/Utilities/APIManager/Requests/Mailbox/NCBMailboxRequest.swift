//
//  NCBMailboxRequest.swift
//  NCBApp
//
//  Created by ADMIN on 8/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBMailboxRequest {
    case getEmailInfo(params: [String : Any])
    case updateStatusEmail(params: [String : Any])
    case deleteEmail(params: [String : Any])
}

extension NCBMailboxRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getEmailInfo(_):
            return "/common-info-service/email/getEmailInfo"
        case .updateStatusEmail(_):
            return "/common-info-service/email/updateStatusEmail"
        case .deleteEmail(_):
            return "/common-info-service/email/deleteEmail"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getEmailInfo(_):
            return .get
        case .updateStatusEmail(_):
            return .put
        case .deleteEmail(_):
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getEmailInfo(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .updateStatusEmail(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .deleteEmail(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}
