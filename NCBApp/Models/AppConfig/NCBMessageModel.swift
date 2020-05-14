//
//  NCBMessageModel.swift
//  NCBApp
//
//  Created by Thuan on 9/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBMessageModel: NCBBaseModel {
    
    var error: String?
    var type: String?
    var mes_en: String?
    var msg_code_1: String?
    var mes_vn: String?
    var create_date: String?
    var provider: String?
    var msg_code: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        error <- map["error"]
        type <- map["type"]
        mes_en <- map["mes_en"]
        msg_code_1 <- map["msg_code_1"]
        mes_vn <- map["mes_vn"]
        create_date <- map["create_date"]
        provider <- map["provider"]
        msg_code <- map["msg_code"]
    }
    
}
