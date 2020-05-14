//
//  NCBGetSavingConfigRequest.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

fileprivate let oauthUsername = "javadeveloperzone"
fileprivate let oauthPassword = "secret"

enum NCBApiGetTotalSavingAccountRequest {
    case getSavingConfig
    case getInterestAccount(params: [String : Any])
    case getListFinalSettlementSavingAccount(params: [String : Any])
    case getDetailFinalSettlementSavingAccount(params: [String : Any])
    case generateOTPFinalSettlementSavingAccount(params: [String : Any])
    case postFinalSettlementSavingAccount(params: [String : Any])
    case confirmFinalSettlementSavingAccount(params: [String : Any])
    case confirmOpenSavingAccount(params: [String : Any])
    case confirmAddtionalAmount(params:[ String : Any])
    case getCurrentRate(params: [String : Any])
    case generateOTPAcumulation (params: [String : Any])
}

extension NCBApiGetTotalSavingAccountRequest: NCBTargetType {
    
    var contentType: String {
        switch self {
        case .confirmOpenSavingAccount(_), .generateOTPFinalSettlementSavingAccount(_):
            return contentTypeJson
        default:
            return contentTypeUrlencoded
        }
    }
    
    var headers: [String : String]? {
        var headers: [String: String] = [:]
        headers["Authorization"] = authorization
        headers["Content-Type"] = contentType
        
        return headers
    }
    
    var path: String {
        switch self {
        case .getSavingConfig:
            return "saving-service/saving/getSavingOptionConfig"
        case .getInterestAccount(_):
            return "saving-service/saving/getRate"
        case .getListFinalSettlementSavingAccount(_):
            return "saving-service/saving/get-account-closure-saving"
        case .getDetailFinalSettlementSavingAccount(_):
            return "saving-service/saving/get-closure-saving-detail"
        case .generateOTPFinalSettlementSavingAccount(_):
            return "saving-service/saving/generateOTPSavingOnline"
        case .postFinalSettlementSavingAccount(_):
            return "saving-service/saving/closureSavingOnline"
        case .confirmFinalSettlementSavingAccount(_):
            return "saving-service/saving/closureSavingOnline"
        case .confirmOpenSavingAccount(_):
            return "saving-service/saving/open-saving"
        case .confirmAddtionalAmount(_):
            return "saving-service/saving/topupAccountSaving"
        case .getCurrentRate(_):
            return "saving-service/saving/getCurrentRate"
        case .generateOTPAcumulation(_):
            return "saving-service/saving/generateOTPAcumulation"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSavingConfig:
            return .get
        case .getInterestAccount(_):
            return .get
        case .getListFinalSettlementSavingAccount(_):
            return .get
        case .getDetailFinalSettlementSavingAccount(_):
            return .get
        case .generateOTPFinalSettlementSavingAccount(_):
            return .post
        case .postFinalSettlementSavingAccount(_):
            return .post
        case .confirmFinalSettlementSavingAccount(_):
            return .get
        case .confirmOpenSavingAccount(_):
            return .post
        case .confirmAddtionalAmount(_):
            return .post
        case .getCurrentRate(_):
            return .get
        case .generateOTPAcumulation(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getSavingConfig:
            return .requestParameters(parameters: [:], encoding: URLEncoding.init())
        case .getInterestAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .getListFinalSettlementSavingAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .getDetailFinalSettlementSavingAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .generateOTPFinalSettlementSavingAccount(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .postFinalSettlementSavingAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .confirmFinalSettlementSavingAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .confirmOpenSavingAccount(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .confirmAddtionalAmount(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.init())
        case .getCurrentRate(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .generateOTPAcumulation(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        }
    }
    
}
