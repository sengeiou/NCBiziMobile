//
//  NCBSavingAccountRequestRepair.swift
//  NCBApp
//
//  Created by Van Dong on 23/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBSavingAccountRequestRepair{
    case createOTPSavingAccountAddAmount(params: [String : Any])
}

extension NCBSavingAccountRequestRepair: NCBTargetType{
    var path: String {
        switch self {
        case .createOTPSavingAccountAddAmount(_):
            return "saving-service/saving/generateOTPAcumulation"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .createOTPSavingAccountAddAmount(_):
            return .post
        }
    }
    
    var task: Task {
        switch self{
        case .createOTPSavingAccountAddAmount(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
}
