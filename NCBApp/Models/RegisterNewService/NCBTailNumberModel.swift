//
//  NCBTailNumberModel.swift
//  NCBApp
//
//  Created by ADMIN on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBTailNumberModel: NCBBaseModel {
    var value: String?
    var name:String?
    var descriptionTailNumber:String?
    override func mapping(map: Map) {
        super.mapping(map: map)
        value <- map["value"]
        name <- map["name"]
        descriptionTailNumber <- map["description"]
    }
    
}
