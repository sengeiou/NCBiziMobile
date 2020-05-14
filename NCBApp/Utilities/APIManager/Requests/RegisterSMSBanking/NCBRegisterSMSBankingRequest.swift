//
//  NCBRegisterSMSBankingRequest.swift
//  NCBApp
//
//  Created by Van Dong on 14/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBRegisterSMSBankingRequest {
    case getFeeRegisterSMSBanking
    case getAccountRegisterSMS(params: [String : Any])
    case createOTPRegisterSMSBanking(params: [String : Any])
    case confirmRegisterSMSBanking(params: [String : Any])
}

extension NCBRegisterSMSBankingRequest: NCBTargetType {
    var path: String {
        switch self{
        case .getFeeRegisterSMSBanking:
            return "common-info-service/register/getSMSMonthlyFee"
        case .getAccountRegisterSMS(_):
            return "common-info-service/register/getAcountsRegistSMS"
        case .createOTPRegisterSMSBanking:
            return "common-info-service/register/generateOTPRegisterSMSBanking"
        case .confirmRegisterSMSBanking(_):
            return "common-info-service/register/registerSMSBanking"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .getFeeRegisterSMSBanking:
            return .get
        case .getAccountRegisterSMS(_):
            return .get
        case .createOTPRegisterSMSBanking(_):
            return .post
        case .confirmRegisterSMSBanking(_):
            return .post
        }
    }
    
    var task: Task {
        switch self{
        case .getFeeRegisterSMSBanking:
            return .requestPlain
        case .getAccountRegisterSMS(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .createOTPRegisterSMSBanking(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .confirmRegisterSMSBanking(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    
}
