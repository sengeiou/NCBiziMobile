//
//  NCBFeeRegisterSMSBankingModel.swift
//  NCBApp
//
//  Created by Van Dong on 14/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBFeeRegisterSMSBankingModel: NCBBaseModel{
    var ccy: String?
    var amount: Int?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        ccy <- map["ccy"]
        amount <- map["amount"]
    }
}
