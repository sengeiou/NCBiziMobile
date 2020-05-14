//
//  NCBGroupSavingAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBGroupSavingAccountModel: NCBBaseModel {
    var isavingGroup : [NCBGroupDetailSavingAccountModel]?
    var totalBalance : Double?
    var totalBalanceUSD: Double?
    var curCode      : String?
    
    override func mapping(map : Map){
        super.mapping(map: map)

        isavingGroup    <- map["isavingGroup"]
        totalBalance    <- map["totalBalance"]
        totalBalanceUSD <- map["totalBalanceUSD"]
        curCode         <- map["ccy"]
    }

    var getTotalBalance: String {
        return "\((totalBalance ?? 0.0).formattedWithDotSeparator) VND"
    }

    var getTotalBalanceUSD: String {
        return "\((totalBalanceUSD ?? 0.0).formattedWithDotSeparator) USD"
    }
}
