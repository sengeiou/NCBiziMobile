//
//  NCBBillInfoNapasModel.swift
//  NCBApp
//
//  Created by Thuan on 6/19/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBBillInfoNapasModel: NCBBaseModel {
    
    var amount : Double?
    var resCode : String?
    var systemTrace : String?
    var serviceCode : String?
    
    //MARK: Local properties
    
    var customerCode : String?
    var customerName : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        amount <- map["amount"]
        resCode <- map["resCode"]
        systemTrace <- map["systemTrace"]
        serviceCode <- map["serviceCode"]
    }
    
    func getPeriod() -> String {
        return ""//monthYearFormatter.string(from: Date())
    }
}
