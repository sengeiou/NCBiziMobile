//
//  NCBApiUserRequest.swift
//  NCBApp
//
//  Created by Thuan on 4/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

enum NCBApiUserRequest {
    case userLogin(params: [String: Any])
    case userGetProfile(deviceId: String)
    case updatePass(params: [String : Any])
    case updatePass4Active(params: [String : Any])
    case generateLoginOTP(params: [String : Any])
    case validateLoginOTP(params: [String : Any])
    case updateProfileStatus(params: [String : Any])
    case needUpdatePass
    case verifyOldPass(params: [String : Any])
    case updateProfileAvatar(params: [String : Any])
    case logout
   
    
}

extension NCBApiUserRequest: NCBTargetType {
    
    var contentType: String {
        switch self {
        case .userLogin(_), .userGetProfile(_):
            return contentTypeUrlencoded
        default:
            return contentTypeJson
        }
    }
    
    var headers: [String : String]? {
        var headers: [String: String] = [:]
        headers["Authorization"] = authorization
        headers["Content-Type"] = contentType
        
        return headers
    }
    
    var path: String {
        switch self {
        case .userLogin(_):
            return "/oauth/token"
        case .userGetProfile(let deviceId):
            return "api/v1/info/usr/profile/\(deviceId)"
        case .updatePass(_):
            return "/api/v1/info/usr/updatePass"
        case .updatePass4Active(_):
            return "/api/v1/info/usr/updatePass4Active"
        case .generateLoginOTP(_):
            return "/api/v1/info/usr/generateotp"
        case .validateLoginOTP(_):
            return "/api/v1/info/usr/validotp"
        case .updateProfileStatus(_):
            return "/api/v1/info/usr/updateProfileStatus"
        case .needUpdatePass:
            return "/api/v1/info/usr/needUpdatePass"
        case .verifyOldPass(_):
            return "/api/v1/account/verifyOldPass"
        case .updateProfileAvatar(_):
            return "/api/v1/info/usr/updateProfileAvatar"
        case .logout:
            return "/oauth/revoke-token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .userLogin(_):
            return .post
        case .userGetProfile(_):
            return .get
        case .updatePass(_):
            return .post
        case .updatePass4Active(_):
            return .post
        case .generateLoginOTP(_):
            return .post
        case .validateLoginOTP(_):
            return .post
        case .updateProfileStatus(_):
            return .post
        case .needUpdatePass:
             return .get
        case .verifyOldPass:
             return .post
        case .updateProfileAvatar(_):
            return .post
        case .logout:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .userLogin(let params):
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .userGetProfile(_):
            return .requestPlain
        case .updatePass(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .updatePass4Active(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .generateLoginOTP(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .validateLoginOTP(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .updateProfileStatus(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .needUpdatePass:
            return .requestPlain
        case .verifyOldPass(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .updateProfileAvatar(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .logout:
            return .requestPlain
        }
    }
    
}
