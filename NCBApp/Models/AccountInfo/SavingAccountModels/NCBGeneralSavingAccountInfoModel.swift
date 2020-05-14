//
//  NCBGeneralSavingAccountInfoModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBGeneralSavingAccountInfoModel: NCBBaseModel {
    var account      : String?
    var balance      : Double?
    var ccy          : String?
    var dueDate      : String?
    var savingNumber : String?
    var termDest     : String?
    var type         : String?
    var accountName  : String?
    var channel: String?
    var accountType: String?
    
    var isSelected = false
    
    override func mapping(map: Map){
        super.mapping(map: map)
        
        account      <- map["account"]
        balance      <- map["balance"]
        ccy          <- map["ccy"]
        dueDate      <- map["dueDate"]
        savingNumber <- map["savingNumber"]
        termDest     <- map["termDest"]
        type         <- map["type"]
        accountName  <- map["accountName"]
        channel  <- map["channel"]
        accountType  <- map["accountType"]
    }
    
    func getBalanceDisplay() -> String {
        if let balance = balance {
            return balance.formattedWithDotSeparator + " \(ccy ?? "")"
        }
        return ""
    }
    
    func getDueDate() -> Date {
        if let dueDate = dueDate {
            return ddMMyyyyFormatter.date(from: dueDate) ?? Date()
        }
        return Date()
    }
    
}
