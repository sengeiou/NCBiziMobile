//
//  NCBBillInfoPayooServiceModel.swift
//  NCBApp
//
//  Created by Thuan on 6/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBBillInfoPayooServiceModel: NCBBaseModel {
    
    var serviceId : String?
    var serviceName : String?
    var issuers : [NCBBillInfoPayooIssuersModel]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        serviceId <- map["serviceId"]
        serviceName <- map["serviceName"]
        issuers <- map["issuers"]
    }
    
}
