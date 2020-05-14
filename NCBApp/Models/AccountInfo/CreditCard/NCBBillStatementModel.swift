//
//  NCBBillStatementModel.swift
//  NCBApp
//
//  Created by Thuan on 7/26/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBBillStatementModel: NCBBaseModel {
    var id: Int?
    var cifno : String?
    var duedate : String?
    var updatedate : String?
    var cardno : String?
    var bildate : String?
    var cardname : String?
    var updateflag : Int?
    var closingbalance : Int?
    var mindue : Int?
    
    override func mapping(map: Map) {
        id <- map["id"]
        cifno <- map["cifno"]
        duedate <- map["duedate"]
        updatedate <- map["updatedate"]
        cardno <- map["cardno"]
        bildate <- map["bildate"]
        cardname <- map["cardname"]
        updateflag <- map["updateflag"]
        closingbalance <- map["closingbalance"]
        mindue <- map["mindue"]
    }
}
