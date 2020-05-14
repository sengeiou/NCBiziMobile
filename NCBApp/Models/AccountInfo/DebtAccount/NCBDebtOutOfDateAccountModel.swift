//
//  NCBDebtOutOfDateAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/22/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBDebtOutOfDateAccountModel: NCBBaseModel {
    
    var ccy              : String?
    var contractNo       : String?
    var overduedAmount   : Int?
    var overduedInterest : Int?
    var paymentDate      : String?
    var penaltyAmount    : Int?

    override func mapping(map: Map) {
        super.mapping(map: map)
        
        ccy              <- map["ccy"]
        contractNo       <- map["contractNo"]
        overduedAmount   <- map["overduedAmount"]
        overduedInterest <- map["overduedInterest"]
        paymentDate      <- map["paymentDate"]
        penaltyAmount    <- map["penaltyAmount"]
    }
}
