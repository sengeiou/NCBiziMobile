//
//  NCBCreditCardRequest.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBCreditCardRequest {
    case getListCreditCard(params: [String : Any])
    case getHistoryCrCardList(params: [String: Any])
    case getBillStatementList(params: [String: Any])
    case getAccountStatementList(params: [String: Any])
    case getBillDate(params: [String: Any])
    case getPaymentOptional(params: [String: Any])
    case cardPaymentConfirm(params: [String: Any])
    case getCardInfo(params: [String: Any])
    case registerEcomConfirm(params: [String: Any])
    case unregisterEcom(params: [String: Any])
    case autoDebtDeductionConfirm(params: [String: Any])
    case checkCardAutoDebit(params: [String: Any])
}

extension NCBCreditCardRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getListCreditCard:
            return "card-service/card/get-CrCardList"
        case .getHistoryCrCardList:
            return "card-service/card/get-history-crCardList"
        case .getBillStatementList:
            return "card-service/card/get-bill-account-statement-list"
        case .getAccountStatementList:
            return "card-service/card/get-account-statement-list"
        case .getBillDate:
            return "card-service/card/get-bill-date"
        case .getPaymentOptional:
            return "card-service/card/get-payment-optional"
        case .cardPaymentConfirm:
            return "card-service/card/payment-card-confirm"
        case .getCardInfo:
            return "card-service/card/get-info-card"
        case .registerEcomConfirm:
            return "card-service/card/register-ecomm-confirm"
        case .unregisterEcom:
            return "card-service/card/unregister-ecomm"
        case .autoDebtDeductionConfirm:
            return "card-service/card/card-auto-debit-confirm"
        case .checkCardAutoDebit:
            return "card-service/card/check-card-auto-debit"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getListCreditCard(_):
            return .get
        case .getHistoryCrCardList(_):
            return .get
        case .getBillStatementList(_):
            return .get
        case .getAccountStatementList(_):
            return .get
        case .getBillDate(_):
            return .get
        case .getPaymentOptional(_):
            return .get
        case .cardPaymentConfirm(_):
            return .post
        case .getCardInfo(_):
            return .post
        case .registerEcomConfirm(_):
            return .post
        case .unregisterEcom(_):
            return .post
        case .autoDebtDeductionConfirm(_):
            return .post
        case .checkCardAutoDebit(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getListCreditCard(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getHistoryCrCardList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getBillStatementList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getAccountStatementList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getBillDate(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getPaymentOptional(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .cardPaymentConfirm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getCardInfo(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .registerEcomConfirm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .unregisterEcom(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .autoDebtDeductionConfirm(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .checkCardAutoDebit(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
}
