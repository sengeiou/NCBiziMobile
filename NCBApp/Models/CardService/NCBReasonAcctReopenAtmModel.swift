//
//  NCBReasonAcctReopenAtmModel.swift
//  NCBApp
//
//  Created by ADMIN on 8/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBReasonAcctReopenAtmModel: NCBBaseModel {
    var note: String?
    var param: String?
    var value: String?
    var code: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        note <- map["note"]
        param <- map["param"]
        value <- map["value"]
        code <- map["code"]
    }
    
    var codeExpired: Bool {
        return code == "EXPIRED"
    }
    
}
