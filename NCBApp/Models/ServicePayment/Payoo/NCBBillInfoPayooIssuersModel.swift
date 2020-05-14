//
//  NCBBillInfoPayooIssuersModel.swift
//  NCBApp
//
//  Created by Thuan on 6/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBBillInfoPayooIssuersModel: NCBBaseModel {
    
    var issuerName : String?
    var issuerId : String?
    var isOnline : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        issuerName <- map["issuerName"]
        issuerId <- map["issuerId"]
        isOnline <- map["isOnline"]
    }
    
}
