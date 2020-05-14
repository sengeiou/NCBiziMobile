//
//  NCBReturnNumberModel.swift
//  NCBApp
//
//  Created by ADMIN on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBReturnNumberModel: NCBBaseModel {
    
    var accountNo:String?
    var acctType: String?
    var serviceFee: Double?
    var chargCode: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        accountNo <- map["accountNo"]
        acctType <- map["acctType"]
        serviceFee <- map["serviceFee"]
        chargCode <- map["chargCode"]
    }
    
}
