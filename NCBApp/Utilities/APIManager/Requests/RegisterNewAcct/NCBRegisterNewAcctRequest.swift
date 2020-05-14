//
//  NCBRegisterNewAcctRequest.swift
//  NCBApp
//
//  Created by ADMIN on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBRegisterNewAcctRequest {
    case getProductOpenAcountOnline(params: [String : Any])
    case getDescProductOpenAccountOnline(params: [String : Any])
    case getListTypeNiceNumber(params: [String : Any])
    case getNiceAccountInfo(params: [String : Any])
    case generateOTPOpenAccountOnline(params: [String : Any])
    case openAccountOnline(params: [String : Any])
   
}

extension NCBRegisterNewAcctRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getProductOpenAcountOnline(_):
            return "/common-info-service/register/getProductOpenAccountOnline"
        case .getDescProductOpenAccountOnline(_):
            return "/common-info-service/register/getDescProductOpenAccountOnline"
        case .getListTypeNiceNumber(_):
            return "/common-info-service/register/getListTypeNiceNumber"
        case .getNiceAccountInfo(_):
            return "/common-info-service/register/getNiceAccountInfo"
        case .generateOTPOpenAccountOnline(_):
            return "/common-info-service/register/generateOTPOpenAccountOnline"
        case .openAccountOnline(_):
            return "/common-info-service/register/openAccountOnline"
        }
    }
    
    
    var method: Moya.Method {
        switch self {
        case .getProductOpenAcountOnline(_):
            return .get
        case .getDescProductOpenAccountOnline(_):
            return .get
        case .getListTypeNiceNumber(_):
            return .get
        case .getNiceAccountInfo(_):
            return .get
        case .generateOTPOpenAccountOnline(_):
            return .post
        case .openAccountOnline(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getProductOpenAcountOnline(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getDescProductOpenAccountOnline(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getListTypeNiceNumber(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getNiceAccountInfo(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .generateOTPOpenAccountOnline(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .openAccountOnline(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}
