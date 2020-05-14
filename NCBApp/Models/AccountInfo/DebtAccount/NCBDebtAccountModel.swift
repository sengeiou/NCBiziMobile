//
//  NCBDebtAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBDebtAccountModel: NCBBaseModel {
    var acctno  : String?
    var amount  : Double?
    var curcode : String?
    
    override func mapping(map: Map) {
        acctno  <- map["contractNo"]
        amount  <- map["amount"]
        curcode <- map["curcode"]
    }
}
