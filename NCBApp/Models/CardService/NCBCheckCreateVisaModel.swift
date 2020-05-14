//
//  NCBCheckCreateVisaModel.swift
//  NCBApp
//
//  Created by ADMIN on 9/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBCheckCreateVisaModel: NCBBaseModel {
    var param: String?
    var note: String?
    var id: Int?
    var value: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        param <- map["param"]
        note <- map["note"]
        value <- map["value"]
        id <- map["id"]
    }
}
