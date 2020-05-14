//
//  NCBDealStatementModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/15/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBDealStatementContentModel: NCBBaseModel {
    var actno : String?
    var amount : Double?
    var curCode : String?
    var ddtxn : String?
    var ddtxnDesc : String?
    var destAcctName : String?
    var destAcctNo : String?
    var dorc : String?
    var message : String?
    var seqno : Int?
    var txndate : String?
    var txndateFormat : String?
    
    override func mapping(map: Map) {
        actno <- map["actno"]
        amount <- map["amount"]
        curCode <- map["curCode"]
        ddtxn <- map["ddtxn"]
        ddtxnDesc <- map["ddtxnDesc"]
        destAcctName <- map["destAcctName"]
        destAcctNo <- map["destAcctNo"]
        dorc <- map["dorc"]
        message <- map["message"]
        seqno <- map["seqno"]
        txndate <- map["txndate"]
        txndateFormat <- map["txndateFormat"]
    }
    
    func getAmount() -> Double?{
        if isNegativeNumb(dorc ?? "") {
            return -(amount ?? 0.0)
        } else {
            return amount ?? 0.0
        }
    }
    
    final func getMonthName() -> String {
        guard let date = self.txndateFormat else {
            return ""
        }
        
        guard let month = ddMMyyyyFormatter.date(from: date)?.month else {
            return ""
        }
        
        switch month {
        case MonthFromName.January.rawValue: return "Tháng 1"
        case MonthFromName.February.rawValue: return "Tháng 2"
        case MonthFromName.March.rawValue: return "Tháng 3"
        case MonthFromName.April.rawValue: return "Tháng 4"
        case MonthFromName.May.rawValue: return "Tháng 5"
        case MonthFromName.June.rawValue: return "Tháng 6"
        case MonthFromName.July.rawValue: return "Tháng 7"
        case MonthFromName.August.rawValue: return "Tháng 8"
        case MonthFromName.September.rawValue: return "Tháng 9"
        case MonthFromName.October.rawValue: return "Tháng 10"
        case MonthFromName.November.rawValue: return "Tháng 11"
        case MonthFromName.December.rawValue: return "Tháng 12"
        default:
            return MonthFromName.Other.rawValue
        }
    }
}
