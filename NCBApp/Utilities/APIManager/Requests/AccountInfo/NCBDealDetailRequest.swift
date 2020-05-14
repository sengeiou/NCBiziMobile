//
//  NCBDealRequest.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBDealRequest {
    case getListDealStatement(params: [String : Any])
    case getTopTenDeal(params: [String: Any])
    case getDealHistory(params: [String: Any])
    case getDealDetail(params: [String: Any])
    case getListDealHistoryOnSearch(params: [String: Any])
    case searchTransactionByCif(params: [String: Any])
}

extension NCBDealRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getListDealStatement(_):
             return "/common-info-service/account/history-account-ca"
        case .getTopTenDeal(_):
            return "/common-info-service/account/top-history-account-ca"
        case .getDealHistory(_):
            return "/common-info-service/account/detail-transaction-account-ca"
        case .getDealDetail(_):
            return "/common-info-service/account/detail-transaction-account-ca"
        case .getListDealHistoryOnSearch(_):
            return "/common-info-service/account/search-transaction-account-ca"
        case .searchTransactionByCif(_):
            return "/common-info-service/account/get-transaction-by-cif"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getListDealStatement(_):
            return .get
        case .getTopTenDeal(_):
            return .get
        case .getDealHistory(_):
            return .get
        case .getDealDetail(_):
            return .get
        case .getListDealHistoryOnSearch(_):
            return .get
        case .searchTransactionByCif(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getListDealStatement(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getTopTenDeal(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getDealHistory(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getDealDetail(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getListDealHistoryOnSearch(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .searchTransactionByCif(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
}
