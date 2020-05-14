//
//  NCBSavingAccountRequest.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBSavingAccountRequest {
    case getGroupSavingAccount(params: [String : Any])
    case getListSavingAccountFollowMoneyUnit(params: [String : Any])
    case getDetailSavingAccount(params: [String : Any])
    case getDetailStatementSavingAccount(params: [String : Any])
    case getAllSavingAccount(params: [String : Any])
    case getSavingHistory(params: [String: Any])
    case getCurrentRate(params: [String : Any])
}

extension NCBSavingAccountRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getGroupSavingAccount:
            return "saving-service/saving/find-account-saving"
        case .getListSavingAccountFollowMoneyUnit:
            return "saving-service/saving/get-total-saving"
        case .getDetailSavingAccount:
            return "saving-service/saving/get-saving-detail"
        case .getDetailStatementSavingAccount:
            return "saving-service/saving/get-closure-saving-detail"
        case .getAllSavingAccount:
            return "saving-service/saving/getAllAcctSaving"
        case .getSavingHistory:
            return "saving-service/saving/saving-history"
        case .getCurrentRate(_):
            return "saving-service/saving/getCurrentRate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getGroupSavingAccount(_):
            return .get
        case .getListSavingAccountFollowMoneyUnit(_):
            return .get
        case .getDetailSavingAccount(_):
            return .get
        case .getDetailStatementSavingAccount(_):
            return .get
        case .getAllSavingAccount(_):
            return .get
        case .getSavingHistory(_):
            return .get
        case .getCurrentRate(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getGroupSavingAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .getListSavingAccountFollowMoneyUnit(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .getDetailSavingAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .getDetailStatementSavingAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .getAllSavingAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .getSavingHistory(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        case .getCurrentRate(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.init())
        }
    }
    
}
