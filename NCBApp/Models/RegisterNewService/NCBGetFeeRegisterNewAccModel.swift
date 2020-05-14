//
//  NCBGetFeeRegisterNewAccModel.swift
//  NCBApp
//
//  Created by ADMIN on 8/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBGetFeeRegisterNewAccModel: NCBBaseModel {
    var codeFee: String?
    var fee: Double?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        codeFee <- map["codeFee"]
        fee <- map["fee"]
    }
    
}
