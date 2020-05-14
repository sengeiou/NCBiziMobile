//
//  NCBTransferLimitModel.swift
//  NCBApp
//
//  Created by Thuan on 7/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


class NCBTransferLimitModel : NCBBaseModel {
    
    var limit_faceid: Double?
    var quantity: Int?
    var promotion_name: String?
    var type_id: String?
    var percentage: Int?
    var to_date: String?
    var limit_daily: Double?
    var prd: String?
    var from_date: String?
    var promotion: String?
    var prd_name: String?
    var min: Double?
    var tran_type: String?
    var customer_type: String?
    var created_date: String?
    var max: Double?
    var id: Int?
    var limit_finger: Double?
    var created_by: String?
    var status: String?
    var ccy: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        limit_faceid <- map["limit_faceid"]
        quantity <- map["quantity"]
        promotion_name <- map["promotion_name"]
        type_id <- map["type_id"]
        percentage <- map["percentage"]
        to_date <- map["to_date"]
        limit_daily <- map["limit_daily"]
        prd <- map["prd"]
        from_date <- map["from_date"]
        promotion <- map["promotion"]
        prd_name <- map["prd_name"]
        min <- map["min"]
        tran_type <- map["tran_type"]
        customer_type <- map["customer_type"]
        created_date <- map["created_date"]
        max <- map["max"]
        id <- map["id"]
        limit_finger <- map["limit_finger"]
        created_by <- map["created_by"]
        status <- map["status"]
        ccy <- map["ccy"]
    }
    
}
