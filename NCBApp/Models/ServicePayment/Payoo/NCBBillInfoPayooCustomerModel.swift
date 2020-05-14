//
//  NCBBillInfoPayooCustomerModel.swift
//  NCBApp
//
//  Created by Thuan on 6/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBBillInfoPayooCustomerModel: NCBBaseModel {
    
    var area : String?
    var custId : String?
    var custName : String?
    var houseNo : Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        area <- map["area"]
        custId <- map["custId"]
        custName <- map["custName"]
        houseNo <- map["houseNo"]
    }
    
}
