//
//  NCBAutoPayBillDetailModel.swift
//  NCBApp
//
//  Created by Thuan on 6/13/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBAutoPayBillDetailModel: NCBBaseModel {
    
    var acctNo : String?
    var acctName : String?
    var billNo : String?
    var providerName : String?
    var serviceName : String?
    var timeDky : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        acctNo <- map["acctNo"]
        acctName <- map["acctName"]
        billNo <- map["billNo"]
        providerName <- map["providerName"]
        serviceName <- map["serviceName"]
        timeDky <- map["timeDky"]
    }
}
