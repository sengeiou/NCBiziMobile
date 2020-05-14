//
//  NCBLoanPurposeModel.swift
//  NCBApp
//
//  Created by Thuan on 8/27/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBLoanPurposeModel: NCBBaseModel {
    
    var code: String?
    var name:String?
    var value:String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        code <- map["code"]
        name <- map["name"]
        value <- map["value"]
    }
    
}
