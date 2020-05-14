//
//  NCBConfirmTransferInfoModel.swift
//  NCBApp
//
//  Created by Thuan on 5/13/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

enum OtpLevelType: String {
    case basic = "BASIC"
    case advanced = "ADVANCE"
}

class NCBConfirmTransferInfoModel : NCBBaseModel {
    
    var debitAcct  : String?
    var msgid   : String?
    var amount  : Double?
    var goal    : String?
    var creditAcct : String?
    var otpLevel: String?
    var challenge: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        debitAcct <- map["debitAcct"]
        msgid <- map["msgid"]
        amount <- map["amount"]
        goal <- map["goal"]
        creditAcct <- map["creditAcct"]
        otpLevel <- map["otpLevel"]
        challenge <- map["challenge"]
    }
    
    var isAdvancedSoftOtp: Bool {
        return otpLevel == OtpLevelType.advanced.rawValue
    }
}
