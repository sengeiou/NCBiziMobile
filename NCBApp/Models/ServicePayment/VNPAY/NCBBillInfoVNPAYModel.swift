//
//  NCBBillInfoVNPAYModel.swift
//  NCBApp
//
//  Created by Thuan on 6/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBBillInfoVNPAYModel: NCBBaseModel {
    
    var providerCode : String?
    var sysTrace : String?
    var resCode : String?
    var amount : Double?
    var customerCode : String?
    var fullname : String?
    var serviceCode : String?
    var address : String?
    var billInfo: [NCBBillPeriodVNPAYModel]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        providerCode <- map["providerCode"]
        sysTrace <- map["systemTrace"]
        resCode <- map["resCode"]
        amount <- map["amount"]
        customerCode <- map["customerCode"]
        fullname <- map["fullname"]
        serviceCode <- map["serviceCode"]
        address <- map["address"]
        billInfo <- map["billInfo"]
    }
    
    func getBillPeriod() -> String {
        var period = ""
        
        guard let billInfo = billInfo else {
            return ""
        }
        
        for item in billInfo {
            period.append(item.billPeriod ?? "")
            period.append(",")
        }
        
        if period.count > 1 {
            period.removeLast()
        }
        
        return period
    }
}
