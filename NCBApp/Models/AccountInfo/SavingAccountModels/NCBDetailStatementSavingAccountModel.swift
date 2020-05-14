//
//  NCBDetailStatementSavingAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/19/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBDetailStatementSavingAccountModel: NCBBaseModel {
    
    var account  : String?
    var balance  : Double?
    var ccy      : String?
    var interst  : Float?
    var openDate : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        account  <- map["account"]
        balance  <- map["balance"]
        ccy      <- map["ccy"]
        interst  <- map["interst"]
        openDate <- map["openDate"]
    }
    
    final func getMonthName() -> String {
        guard let dateStr = self.openDate else {
            return ""
        }
        
        guard let date = ddMMyyyyFormatter.date(from: dateStr) else {
            return ""
        }
        
        return monthYearFormatter.string(from: date)
    }
}
