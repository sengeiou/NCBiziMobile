//
//  NCBExchangeRateIModel.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBExchangeRateIModel: NCBBaseModel {
    
    var rateDetail: [NCBExchangeRateIModel]?
    var restInfoVND: [NCBInterestRateInfoModel]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        restInfoUSD <- map["restInfoUSD"]
        restInfoVND <- map["restInfoVND"]
    }
    
}
