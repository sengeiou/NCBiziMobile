//
//  NCBBillInfoDetailPayooModel.swift
//  NCBApp
//
//  Created by Thuan on 6/11/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBBillInfoDetailPayooModel: NCBBaseModel {
    
    var billId : String?
    var expireDate : String?
    var custId : String?
    var serviceId : Int?
    var adress : String?
    var amount : Double?
    var providerId : String?
    var range : String?
    var isPrepaid : String?
    var mont : String?
    var fee : String?
    var custName: String?
    var monthAmount : Double?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        billId <- map["billId"]
        expireDate <- map["expireDate"]
        custId <- map["custId"]
        serviceId <- map["serviceId"]
        adress <- map["adress"]
        amount <- map["amount"]
        providerId <- map["providerId"]
        range <- map["range"]
        isPrepaid <- map["isPrepaid"]
        mont <- map["mont"]
        fee <- map["fee"]
        custName <- map["custName"]
        monthAmount <- map["monthAmount"]
    }
    
}
