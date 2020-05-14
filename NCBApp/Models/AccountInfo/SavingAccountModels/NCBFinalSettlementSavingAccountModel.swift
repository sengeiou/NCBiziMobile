//
//  NCBFinalSettlementSavingAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/15/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBFinalSettlementSavingAccountModel: NCBBaseModel {
    var account      : String?
    var balance      : Double?
    var ccy          : String?
    var dueDate      : String?
    var prdName      : String?
    var savingNumber : String?
    var termDest     : String?
    var typeId       : String?
    var channel      : String?
    
    var isSelected = false
    
    override func mapping(map: Map) {
        account      <- map["account"]
        balance      <- map["balance"]
        ccy          <- map["ccy"]
        dueDate      <- map["dueDate"]
        prdName      <- map["prdName"]
        savingNumber <- map["savingNumber"]
        termDest     <- map["termDest"]
        typeId       <- map["typeId"]
        channel      <- map["channel"]
    }

    func getBalance() -> String {
        if let balance = balance {
            return balance.formattedWithDotSeparator + " \(ccy ?? "")"
        }
        return ""
    }
}

