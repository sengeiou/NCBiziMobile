//
//  NCBBillInfoPayooModel.swift
//  NCBApp
//
//  Created by Thuan on 6/11/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBBillInfoPayooModel: NCBBaseModel {
    
    var transTime : String?
    var resCode : String?
    var contactPhone : String?
    var paymentRule : Int?
    var sysTraceEx : String?
    var ecommerceDesc : String?
    var channelType : String?
    var contactAddress : String?
    var invoiceNo : String?
    var vietUnionId : String?
    var matchServiceCount : String?
    var contactName : String?
    var sysTrace : String?
    var viewOptions : String?
    var descriptionCode : String?
    var billInfo: [NCBBillInfoDetailPayooModel]?
    var customer: [NCBBillInfoPayooCustomerModel]?
    var customerInfo : String?
    var services: [NCBBillInfoPayooServiceModel]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        transTime <- map["transTime"]
        resCode <- map["resCode"]
        contactPhone <- map["contactPhone"]
        paymentRule <- map["paymentRule"]
        sysTraceEx <- map["sysTraceEx"]
        ecommerceDesc <- map["ecommerceDesc"]
        channelType <- map["channelType"]
        contactAddress <- map["contactAddress"]
        invoiceNo <- map["invoiceNo"]
        vietUnionId <- map["vietUnionId"]
        matchServiceCount <- map["matchServiceCount"]
        contactName <- map["contactName"]
        sysTrace <- map["sysTrace"]
        viewOptions <- map["viewOptions"]
        descriptionCode <- map["descriptionCode"]
        billInfo <- map["billInfo"]
        customer <- map["customer"]
        customerInfo <- map["customerInfo"]
        services <- map["services"]
    }
    
    func getBillPeriod() -> String {
        var period = ""
        
        guard let billInfo = billInfo else {
            return ""
        }
        
        for item in billInfo {
            period.append(item.mont ?? "")
            period.append(",")
        }
        
        if period.count > 1 {
            period.removeLast()
        }
        
        return period
    }
    
    func getAmount() -> Double {
        var amount = 0.0
        
        guard let billInfo = billInfo else {
            return amount
        }
        
        for item in billInfo {
            amount += item.amount ?? 0.0
        }
        
        return amount
    }
    
    func getBillDetail() -> NCBBillInfoDetailPayooModel? {
        return billInfo?.first
    }

}
