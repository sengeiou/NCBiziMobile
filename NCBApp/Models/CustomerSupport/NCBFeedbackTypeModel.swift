//
//  NCBFeedbackTypeModel.swift
//  NCBApp
//
//  Created by Thuan on 8/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBFeedbackTypeModel: NCBBaseModel {
    
    var name: String?
    var value: String?
    var code: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["name"]
        value <- map["value"]
        code <- map["code"]
    }
}
