//
//  NCBTargetType.swift
//  NCBApp
//
//  Created by Thuan on 4/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Moya

fileprivate let oauthUsername = "javadeveloperzone"
fileprivate let oauthPassword = "secret"
let contentTypeJson = "application/json"
let contentTypeUrlencoded = "application/x-www-form-urlencoded"

var basicAuthorization: String {
    let passwordString = "\(oauthUsername):\(oauthPassword)"
    let passwordData = passwordString.data(using: .utf8)
    let base64EncodedCredential = passwordData?.base64EncodedString(options: .lineLength64Characters)

    if let base64EncodedCredential = base64EncodedCredential {
        let authString = "Basic \(base64EncodedCredential)"
        return authString
    }

    return ""
}

var authorization: String {
    if let token = NCBShareManager.shared.getAccessToken() {
        return "Bearer \(token)"
    }

    return basicAuthorization
}

public protocol NCBTargetType: TargetType {
    
}

extension NCBTargetType {
    
    public var baseURL: URL {
        return URL(string: StringConstant.rootUrl)!
    }
    
    public var headers: [String : String]? {
        var headers: [String: String] = [:]
        headers["Authorization"] = authorization
        headers["Content-Type"] = "application/x-www-form-urlencoded"
        
        return headers
    }
    
    public var sampleData: Data {
        return Data()
    }

}
