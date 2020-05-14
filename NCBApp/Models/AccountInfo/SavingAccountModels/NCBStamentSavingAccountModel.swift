//
//  NCBStamentSavingAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/18/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBStatementSavingAccountModel: NCBBaseModel {
    var acctNo  : String?
    var balance : Double?
    var ccy     : String?
    var intRate : String?
    var opnDate : String?
    
    override func mapping(map: Map) {
        acctNo  <- map["acctNo"]
        balance <- map["balance"]
        ccy     <- map["ccy"]
        intRate <- map["intRate"]
        opnDate <- map["opnDate"]
    }
}
