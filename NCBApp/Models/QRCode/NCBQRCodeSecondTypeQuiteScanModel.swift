//
//  NCBQRCodeSecondTypeQuiteScanModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBQRCodeSecondTypeAnimatedScanModel: NCBBaseModel {
    var merchantName     : String?
    var transCodeType    : String?
    var merchantUnitName : String?
    var merchantCode     : String?
    var TID              : String?
    var productCode      : String?
    var dealCode         : String?
    var amount           : String?
    var moneyCode        : String?
    var settlementDate   : String?
    var content          : String?
    
    override func mapping(map: Map) {
        merchantName     <- map["merchantName"]
        transCodeType    <- map["transCodeType"]
        merchantUnitName <- map["merchantUnitName"]
        merchantCode     <- map["merchantCode"]
        TID              <- map["TID"]
        productCode      <- map["productCode"]
        dealCode         <- map["dealCode"]
        amount           <- map["amount"]
        moneyCode        <- map["moneyCode"]
        settlementDate   <- map["settlementDate"]
        content          <- map["content"]
    }
    
    public func getAmountFromQRData() -> Double {
        if let _amount = amount {
            if let _amountConverted = Double(_amount) {
                return _amountConverted
            } else {
                return 0.0
            }
        } else {
            return 0.0
        }
    }
}
