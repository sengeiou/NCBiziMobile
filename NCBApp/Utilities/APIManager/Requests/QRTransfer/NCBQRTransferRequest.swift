//
//  QRTransferRequest.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBQRTransferRequest {
    case getListQRTransferHistory(params: [String : Any])
    case getDetailQRTransfer(params: [String : Any])
}

extension NCBQRTransferRequest: NCBTargetType {
    
    var path: String {
        switch self {
        case .getListQRTransferHistory(_):
            return "/qrcode-service/qrcode/getHistoryTranQRCode"
        case .getDetailQRTransfer(_):
            return "/qrcode-service/qrcode/getHistoryTranQRCode"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getListQRTransferHistory(_):
            return .get
        case .getDetailQRTransfer(_):
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getListQRTransferHistory(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getDetailQRTransfer(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
}
