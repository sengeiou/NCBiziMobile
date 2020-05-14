//
//  QRCodeModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/4/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBQRCodeFirstTypeAnimatedScanModel: NCBBaseModel {
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
}
