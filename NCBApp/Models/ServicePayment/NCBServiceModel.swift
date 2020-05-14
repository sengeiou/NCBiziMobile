//
//  NCBServiceModel.swift
//  NCBApp
//
//  Created by Thuan on 6/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBServiceModel: NCBBaseModel {
    
    var serviceCode : String?
    var serviceName : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        serviceCode <- map["serviceCode"]
        serviceName <- map["serviceName"]
    }
}
