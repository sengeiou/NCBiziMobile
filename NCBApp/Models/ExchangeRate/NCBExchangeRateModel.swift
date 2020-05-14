//
//  NCBExchangeRateModel.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBExchangeRateModel: NCBBaseModel {
    
    var rateDetail: [NCBExchangeRateInfoModel]?
    var effectDate: String?
    var everageRate: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        rateDetail <- map["rateDetail"]
        effectDate <- map["effectDate"]
        everageRate <- map["everageRate"]
    }
    
}
