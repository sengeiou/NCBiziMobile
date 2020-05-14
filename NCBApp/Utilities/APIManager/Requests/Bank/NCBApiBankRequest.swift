//
//  NCBApiBankRequest.swift
//  NCBApp
//
//  Created by Thuan on 5/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBApiBankRequest {
    case getBankList(params: [String: Any], type: BankServiceType)
    case getBankProvinceList(params: [String: Any])
    case getBankBranchList(params: [String: Any])
}

extension NCBApiBankRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getBankList(_, let type):
            switch type {
            case .fundTransfer:
                return "/fund-transfer-service/transfer/list-bank-transfer"
            case .payment:
                return "/payment-service/transfer/list-bank-transfer"
            }
        case .getBankProvinceList(_):
            return "/fund-transfer-service/transfer/list-province-transfer"
        case .getBankBranchList(_):
            return "/fund-transfer-service/transfer/list-branch-transfer"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBankList(_):
            return .get
        case .getBankProvinceList(_):
            return .get
        case .getBankBranchList(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getBankList(let params, _):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getBankProvinceList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getBankBranchList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}
