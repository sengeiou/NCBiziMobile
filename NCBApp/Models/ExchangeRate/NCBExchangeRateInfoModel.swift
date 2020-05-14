//
//  NCBExchangeRateInfoModel.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBExchangeRateInfoModel: NCBBaseModel {
    
    var rateFullname: String?
    var rateShortname: String?
    var rateBuyCash: String?
    var rateBuyTransfer: String?
    var rateSell: String?
    var rateSellTransfer: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        rateFullname <- map["rateFullname"]
        rateShortname <- map["rateShortname"]
        rateBuyCash <- map["rateBuyCash"]
        rateBuyTransfer <- map["rateBuyTransfer"]
        rateSell <- map["rateSell"]
        rateSellTransfer <- map["rateSellTransfer"]
    }
    
}
