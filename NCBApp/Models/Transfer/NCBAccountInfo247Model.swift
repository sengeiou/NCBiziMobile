//
//  NCBAccountInfo247Model.swift
//  NCBApp
//
//  Created by Thuan on 6/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


class NCBAccountInfo247Model : NCBBaseModel {
    
    var desc  : String?
    var bankCode   : String?
    var transTime  : String?
    var sysTrace    : String?
    var toAcctName : String?
    var resCode   : String?
    var fromAcct : String?
    var channelType : String?
    var transDate : String?
    var toAcct : String?
    var refNumber : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        desc <- map["description"]
        bankCode <- map["bankCode"]
        transTime <- map["transTime"]
        sysTrace <- map["sysTrace"]
        toAcctName <- map["toAcctName"]
        resCode <- map["resCode"]
        fromAcct <- map["fromAcct"]
        channelType <- map["channelType"]
        transDate <- map["transDate"]
        toAcct <- map["toAcct"]
        refNumber <- map["refNumber"]
    }
}
