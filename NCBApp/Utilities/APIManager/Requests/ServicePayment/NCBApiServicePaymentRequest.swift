//
//  NCBApiServicePaymentRequest.swift
//  NCBApp
//
//  Created by Thuan on 6/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBApiServicePaymentRequest {
    case getServiceList(params: [String: Any])
    case getServiceListProvider(params: [String: Any])
    case getBillInfoPayoo(params: [String: Any])
    case getBillInfoVNPAY(params: [String: Any])
    case getBillInfoNapas(params: [String: Any])
    case createOTPCode(params: [String: Any], type: PayBillOTPType)
    case saveService(params: [String: Any])
    case getSavedList(params: [String: Any])
    case getAutoPayBillList(params: [String: Any])
    case getAutoPayBillDetail(params: [String: Any])
    case deleteAutoPayBill(params: [String: Any])
}

extension NCBApiServicePaymentRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getServiceList(_):
            return "/payment-service/paybill/list-serviceMbapp"
        case .getServiceListProvider(_):
            return "/payment-service/paybill/list-service-provider"
        case .getBillInfoPayoo(_):
            return "/payment-service/paybill/getBillingInfoPayoo"
        case .getBillInfoVNPAY(_):
            return "/payment-service/paybill/getBillingInfoVNPAY"
        case .getBillInfoNapas(_):
            return "/payment-service/paybill/getBillingInfoNapas"
        case .createOTPCode(_, let type):
            switch type {
            case .payBill:
                return "/payment-service/paybill/generateOTPPaymentBill"
            case .autoPayBill:
                return "/payment-service/paybill/generateOTPAutoPayBill"
            }
        case .saveService(_):
            return "/payment-service/paybill/save-thuhuong"
        case .getSavedList(_):
            return "/payment-service/paybill/getThuHuongData"
        case .getAutoPayBillList(_):
            return "/payment-service/paybill/getListAutoPayBill"
        case .getAutoPayBillDetail(_):
            return "/payment-service/paybill/getDetailAutoPayBill"
        case .deleteAutoPayBill(_):
            return "/payment-service/paybill/deleteAutoPayBill"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getServiceList(_):
            return .get
        case .getServiceListProvider(_):
            return .get
        case .getBillInfoPayoo(_):
            return .get
        case .getBillInfoVNPAY(_):
            return .get
        case .getBillInfoNapas(_):
            return .get
        case .createOTPCode(_, _):
            return .post
        case .saveService(_):
            return .post
        case .getSavedList(_):
            return .get
        case .getAutoPayBillList(_):
            return .get
        case .getAutoPayBillDetail(_):
            return .get
        case .deleteAutoPayBill(_):
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getServiceList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getServiceListProvider(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getBillInfoPayoo(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getBillInfoVNPAY(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getBillInfoNapas(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .createOTPCode(let params, _):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .saveService(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getSavedList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getAutoPayBillList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getAutoPayBillDetail(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .deleteAutoPayBill(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}
