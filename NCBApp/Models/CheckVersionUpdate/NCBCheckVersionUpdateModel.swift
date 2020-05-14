//
//  NCBCheckVersionUpdateModel.swift
//  NCBApp
//
//  Created by Van Dong on 03/09/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBCheckVersionUpdateModel: NCBBaseModel {
    
    var version: String?
    var upgrade: Bool?
    var mandantory: Bool?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        version <- map["version"]
        upgrade <- map["upgrade"]
        mandantory <- map["mandantory"]
    }
    
}
