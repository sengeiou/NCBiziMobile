//
//  NCBSavingAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBSavingAccountModel: NCBBaseModel {
    
    var ccy          : String?
    var totalBalance : Double?
    
    override func mapping(map: Map) {
        super.mapping(map: map)

        ccy          <- map["ccy"]
        totalBalance <- map["totalBalance"]
    }

    func getTotalBalance() -> String {
        if let value = totalBalance {
            return value.formattedWithDotSeparator + " \(ccy ?? "")"
        }
        return ""
    }

}
