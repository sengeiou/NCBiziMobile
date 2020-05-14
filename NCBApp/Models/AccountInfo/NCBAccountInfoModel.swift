//
//  NCBAccountInfoModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBAccountInfoModel: NCBBaseModel {
    var acName        : String?
    var acctNo        : String?
    var categoryCode  : String?
    var categoryName  : String?
    var cifNo         : Int?
    var curBal        : Double?
    var curCode       : String?
    var limit         : Double?
    var lockBal       : Double?
    var opnDate       : Int?
    var opnDateFormat : String?
    var status        : String?
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        acName        <- map["acName"]
        acctNo        <- map["acctNo"]
        categoryCode  <- map["categoryCode"]
        categoryName  <- map["categoryName"]
        cifNo         <- map["cifNo"]
        curBal        <- map["curBal"]
        curCode       <- map["curCode"]
        limit         <- map["limit"]
        lockBal       <- map["lockBal"]
        opnDate       <- map["opnDate"]
        opnDateFormat <- map["opnDateFormat"]
        status        <- map["status"]
    }

}
