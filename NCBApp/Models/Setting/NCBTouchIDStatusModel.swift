//
//  NCBTouchIDStatusModel.swift
//  NCBApp
//
//  Created by Thuan on 10/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBTouchIDStatusModel: NCBBaseModel {
    
    var userName: String?
    var touchidlogin: String?
    var touchid4transfer: String?
    var enableTouchid4transfer: Bool?
    var enableTouchid: Bool?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        userName <- map["userName"]
        touchidlogin <- map["touchidlogin"]
        touchid4transfer <- map["touchid4transfer"]
        enableTouchid4transfer <- map["enableTouchid4transfer"]
        enableTouchid <- map["enableTouchid"]
    }
    
}
