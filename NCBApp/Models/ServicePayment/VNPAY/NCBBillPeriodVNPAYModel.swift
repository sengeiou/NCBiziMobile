//
//  NCBBillPeriodVNPAYModel.swift
//  NCBApp
//
//  Created by Thuan on 6/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBBillPeriodVNPAYModel: NCBBaseModel {
    
    var billPeriod : String?
    var billCode : String?
    var amount : Double?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        billPeriod <- map["billPeriod"]
        billCode <- map["billCode"]
        amount <- map["amount"]
    }
}
