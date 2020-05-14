//
//  NCBCreditCardPaymentOptionalModel.swift
//  NCBApp
//
//  Created by Thuan on 8/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBCreditCardPaymentOptionalModel: NCBBaseModel {
    
    var endPeriodValue: Double?
    var mindue : Double?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        endPeriodValue <- map["endPeriodValue"]
        mindue <- map["mindue"]
    }
}
