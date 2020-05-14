//
//  NCBDetailTransactionHistoryModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/11/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBDetailTransactionHistoryModel: NCBBaseModel {
    var amount          : Float?
    var curCode         : String?
    var destinationAcc  : String?
    var message         : String?
    var origin          : String?
    var receiver        : String?
    var resourceAcc     : String?
    var transDate       : String?
    var transDateFormat : String?
    var transType       : String?
    var transTypeDesc   : String?
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        amount          <- map["amount"]
        curCode         <- map["curCode"]
        destinationAcc  <- map["destination_acc"]
        message         <- map["message"]
        origin          <- map["origin"]
        receiver        <- map["receiver"]
        resourceAcc     <- map["resource_acc"]
        transDate       <- map["transDate"]
        transDateFormat <- map["transDateFormat"]
        transType       <- map["transType"]
        transTypeDesc   <- map["transTypeDesc"]
    }
}
