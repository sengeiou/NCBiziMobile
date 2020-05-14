//
//  NCBGenerateOTPModel.swift
//  NCBApp
//
//  Created by ADMIN on 8/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBGenerateOTPModel: NCBBaseModel {
    
    var userFullName: String?
    var otpType: String?
    var msgID: String?
    var userid: String?
    var lang: String?
    var otp: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        userFullName <- map["userFullName"]
        otpType <- map["otpType"]
        msgID <- map["msgID"]
        userid <- map["userid"]
        lang <- map["lang"]
        otp <- map["otp"]
    }
    
}

