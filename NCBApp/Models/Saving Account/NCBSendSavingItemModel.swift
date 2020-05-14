//
//  NCBSendSavingItemModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBSendSavingItemModel: NCBBaseModel {
    var code: String?
    var name : String?
    var type : String?
    var value : String?
    
    override func mapping(map: Map) {
        code <- map["code"]
        name <- map["name"]
        type <- map["type"]
        value <- map["value"]
    }
}
