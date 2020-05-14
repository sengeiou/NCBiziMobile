//
//  NCBDetailFinalSettlementSavingAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBDetailSettlementSavingAccountModel: NCBBaseModel {
    var acctNo         : String?
    var calAmt         : Double?
    var calRate        : Double?
    var ccy            : String?
    var intrate        : Float?
    var kyLinhlai      : String?
    var matDate        : String?
    var openDate       : String?
    var payoutPr       : String?
    var principal      : Double?
    var savingNumber   : String?
    var term           : String?
    var typeId         : String?
    var rootAcct       : String?
    var channel        : String?
    var closureConfirm : Bool?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        acctNo         <- map["acctNo"]
        calAmt         <- map["calAmt"]
        calRate        <- map["calRate"]
        ccy            <- map["ccy"]
        intrate        <- map["intrate"]
        kyLinhlai      <- map["kyLinhlai"]
        matDate        <- map["matDate"]
        openDate       <- map["openDate"]
        payoutPr       <- map["payoutPr"]
        principal      <- map["principal"]
        savingNumber   <- map["savingNumber"]
        term           <- map["term"]
        typeId         <- map["typeId"]
        rootAcct       <- map["rootAcct"]
        channel        <- map["channel"]
        closureConfirm <- map["closureConfirm"]
    }

    func getCalAmt() -> String {
        if let calAmt = calAmt {
            return calAmt.formattedWithDotSeparator + " \(ccy ?? "")"
        }
        return ""
    }

    func getSurplus() -> String {
        if let calAmt = calAmt, let calRate = calRate {
            return (calAmt - calRate).formattedWithDotSeparator + " \(ccy ?? "")"
        }
        return ""
    }

}
