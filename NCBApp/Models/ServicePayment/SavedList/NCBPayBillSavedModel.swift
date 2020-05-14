//
//  NCbPayBillSavedModel.swift
//  NCBApp
//
//  Created by Thuan on 6/11/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBPayBillSavedModel: NCBBaseModel {
    
    var billNo : String?
    var providerName : String?
    var providerCode : String?
    var serviceName : String?
    var serviceCode : String?
    var status : String?
    var partner : String?
    var memName : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        billNo <- map["billNo"]
        providerName <- map["providerName"]
        providerCode <- map["providerCode"]
        serviceName <- map["serviceName"]
        serviceCode <- map["serviceCode"]
        status <- map["status"]
        partner <- map["partner"]
        memName <- map["memName"]
    }
}
