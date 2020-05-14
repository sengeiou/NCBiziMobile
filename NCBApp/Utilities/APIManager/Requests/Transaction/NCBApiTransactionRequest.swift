//
//  NCBApiTransactionRequest.swift
//  NCBApp
//
//  Created by Thuan on 5/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBApiTransactionRequest {
    case checkDestinationAccount(params: [String: Any])
    case pushTransactionInfo(params: [String: Any], type: TransactionType)
    case confirmTransactionInfo(params: [String: Any], type: TransactionType)
    case getInfoAccount247(params: [String: Any])
    case findTypeTransaction
}

extension NCBApiTransactionRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .checkDestinationAccount(_):
            return "/fund-transfer-service/transfer/get-info-destination-account"
        case .pushTransactionInfo(_, let type):
            switch type {
            case .internalTransfer:
                return "/fund-transfer-service/transfer/push-internal-transfer"
            case .citad:
                return "/fund-transfer-service/transfer/push-citad-transfer"
            case .charity:
                return "/fund-transfer-service/transfer/push-charity-transfer"
            case .fast247:
                return "/payment-service/transfer/push-247-transfer"
            default:
                return ""
            }
        case .confirmTransactionInfo(_, let type):
            switch type {
            case .internalTransfer:
                return "/fund-transfer-service/transfer/confirm-internal-transfer"
            case .citad:
                return "/fund-transfer-service/transfer/confirm-citad-transfer"
            case .charity:
                return "/fund-transfer-service/transfer/confirm-charity-transfer"
            case .fast247:
                return "/payment-service/transfer/confirm-247-transfer"
            default:
                return ""
            }
        case .getInfoAccount247(_):
            return "/payment-service/transfer/get-info-account-247"
        case .findTypeTransaction:
            return "/common-info-service/account/find-type-transaction"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkDestinationAccount(_):
            return .post
        case .pushTransactionInfo(_, _):
            return .post
        case .confirmTransactionInfo(_, _):
            return .post
        case .getInfoAccount247(_):
            return .post
        case .findTypeTransaction:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .checkDestinationAccount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .pushTransactionInfo(let params, _):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .confirmTransactionInfo(let params, _):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getInfoAccount247(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .findTypeTransaction:
            return .requestPlain
        }
    }
    
}
