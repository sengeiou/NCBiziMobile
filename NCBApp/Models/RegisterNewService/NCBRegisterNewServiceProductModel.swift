//
//  NCBRegisterNewServiceProductModel.swift
//  NCBApp
//
//  Created by ADMIN on 8/13/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


class NCBRegisterNewServiceProductModel: NCBBaseModel {
    var name: String?
    var value: String?
    var descriptionProduct: String?
    var openNormalAcct: Bool?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        value <- map["value"]
        descriptionProduct <- map["description"]
        openNormalAcct <- map["openNormalAcct"]
    }
    
}
