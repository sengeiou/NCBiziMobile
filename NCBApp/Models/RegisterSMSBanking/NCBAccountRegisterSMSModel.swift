//
//  NCBAccountRegisterSMSModel.swift
//  NCBApp
//
//  Created by Van Dong on 14/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBAccountRegisterSMSModel: NCBBaseModel{
    var acctNo: String?
    var acName: String?
    var curBal: Double?
    var curCode: String?
    var cifNo: Int?
    
    var isSelected = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        acctNo <- map["acctNo"]
        acName <- map["acName"]
        curBal <- map["curBal"]
        curCode <- map["curCode"]
        cifNo <- map["cifNo"]
    }
}
