//
//  NCBAirpayModel.swift
//  NCBApp
//
//  Created by ADMIN on 7/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBBenfitBossModel: NCBBaseModel {
    
    var menName : String?
    var providerCode : String?
    var status : String?
    var partner : String?
    var billNo : String?
    var providerName : String?
    var serviceCode : String?
    var type : String?
    var serviceName : String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        
        providerCode <- map["providerCode"]
        menName <- map["memName"]
        providerName <- map["providerName"]
        serviceName <- map["serviceName"]
        type <- map["type"]
        billNo <- map["billNo"]
        serviceCode <- map["serviceCode"]
        status <- map["status"]
        partner <- map["partner"]
        
    }
    
}
