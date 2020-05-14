//
//  NCBAdditionalSavingAmountModel.swift
//  NCBApp
//
//  Created by ADMIN on 7/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBAdditionalSavingAmountModel: NCBBaseModel {
    var body : String?
    var code : String?
    var descriptionString : String?
    
    
    override func mapping(map: Map) {
        
        body <- map["body"]
        code <- map["code"]
        descriptionString <- map["description"]
        
    }
}
