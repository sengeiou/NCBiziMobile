//
//  NCBApiBeneficiaryRequest.swift
//  NCBApp
//
//  Created by Thuan on 5/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBApiBeneficiaryRequest {
    case getBeneficiaryList(params: [String: Any])
    case updateBeneficiary(params: [String: Any])
    case deleteBeneficiary(params: [String: Any])
    case createBeneficiary(params: [String: Any])
}

extension NCBApiBeneficiaryRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getBeneficiaryList(_):
            return "/fund-transfer-service/transfer/find-beneficiaries-by-cif"
        case .updateBeneficiary(_):
            return "/payment-service/transfer/edit-beneficiaries"
        case .deleteBeneficiary(_):
            return "/payment-service/transfer/delete-beneficiaries"
        case .createBeneficiary(_):
            return "/payment-service/transfer/add-beneficiaries"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBeneficiaryList(_):
            return .get
        case .updateBeneficiary(_):
            return .post
        case .deleteBeneficiary(_):
            return .post
        case .createBeneficiary(_):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getBeneficiaryList(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .updateBeneficiary(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .deleteBeneficiary(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .createBeneficiary(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}
