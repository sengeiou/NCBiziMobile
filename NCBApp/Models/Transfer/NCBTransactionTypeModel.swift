//
//  NCBTransactionTypeModel.swift
//  NCBApp
//
//  Created by Thuan on 8/30/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


class NCBTransactionTypeModel : NCBBaseModel {
    
    var desc: String?
    var name  : String?
    var sort  : Int?
    var type  : String?
    var configMbappPK  : NCBConfigMbappPKModel?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        desc <- map["description"]
        name <- map["name"]
        sort <- map["sort"]
        type <- map["type"]
        configMbappPK <- map["configMbappPK"]
    }
    
}
