//
//  NCBConfigMbappPKModel.swift
//  NCBApp
//
//  Created by Thuan on 8/30/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


class NCBConfigMbappPKModel : NCBBaseModel {
    
    var code: String?
    var value  : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        code <- map["code"]
        value <- map["value"]
    }
    
}
