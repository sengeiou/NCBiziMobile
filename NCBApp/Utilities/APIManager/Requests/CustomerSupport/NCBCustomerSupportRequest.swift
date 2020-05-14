//
//  NCBCustomerSupportRequest.swift
//  NCBApp
//
//  Created by Van Dong on 08/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBCustomerSupportRequest {
    case getQuestionAnswer(params: [String : Any])
    case getUserGuide(params: [String : Any])
    case getCustomerInfomation(params: [String : Any])
    case getDataOptionFeedback
    case sendFeedback(params: [String : Any])
}

extension NCBCustomerSupportRequest: NCBTargetType {
    var path: String {
        switch self{
        case .getQuestionAnswer(_):
            return "product-service/getQuestionAnswer"
        case .getUserGuide(_):
            return "product-service/guideline"
        case .getCustomerInfomation(_):
            return "/api/v1/info/usr/EBUser/"
        case .getDataOptionFeedback:
            return "/product-service/getDataOptionFeedback"
        case .sendFeedback(_):
            return "/product-service/feedback"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .getQuestionAnswer(_):
            return .get
        case .getUserGuide(_):
            return .get
        case .getCustomerInfomation(_):
            return .get
        case .getDataOptionFeedback:
            return .get
        case .sendFeedback(_):
            return .post
        }
    }
    
    var task: Task {
        switch self{
        case .getQuestionAnswer(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getUserGuide(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getCustomerInfomation(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getDataOptionFeedback:
            return .requestPlain
        case .sendFeedback(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    
}
