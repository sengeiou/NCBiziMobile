//
//  NCBInterestRateInfoModel.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBInterestRateInfoModel: NCBBaseModel {
    
    var period_6m: String?
    var period_3m: String?
    var period_1m: String?
    var period_first: String?
    var term: String?
    var period_last: String?
    var period_12m: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        period_6m <- map["period_6m"]
        period_3m <- map["period_3m"]
        period_1m <- map["period_1m"]
        period_first <- map["period_first"]
        term <- map["term"]
        period_last <- map["period_last"]
        period_12m <- map["period_12m"]
    }
    
}
