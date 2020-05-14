//
//  NCBGetFeeAcctReopenAtmModel.swift
//  NCBApp
//
//  Created by ADMIN on 8/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBGetFeeAcctReopenAtmModel: NCBBaseModel {
    var codeFee: String?
    var fee: Double?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        codeFee <- map["codeFee"]
        fee <- map["fee"]
    }
    
}
