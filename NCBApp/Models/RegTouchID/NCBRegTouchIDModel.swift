//
//  NCBRegTouchIDModel.swift
//  NCBApp
//
//  Created by Thuan on 6/5/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBRegTouchIDModel: NCBBaseModel {
    
    var mid : String?
    var code : String?
    var des : String?
    var touchIdAvai : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        mid <- map["mid"]
        code <- map["code"]
        des <- map["des"]
        touchIdAvai <- map["touchIdAvai"]
    }
}
