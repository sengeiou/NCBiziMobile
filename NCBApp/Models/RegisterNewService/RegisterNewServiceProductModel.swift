//
//  RegisterNewServiceProductModel.swift
//  NCBApp
//
//  Created by ADMIN on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//


import Foundation
import ObjectMapper

class RegisterNewServiceProductModel: NCBBaseModel {
    var title: String?

    
    override func mapping(map: Map) {
        super.mapping(map: map)
        title <- map["title"]
    }
    
}
