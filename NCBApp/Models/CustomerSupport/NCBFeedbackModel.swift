//
//  NCBFeedbackModel.swift
//  NCBApp
//
//  Created by Thuan on 8/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBFeedbackModel: NCBBaseModel {
    
    var lstFeedbackType: [NCBFeedbackTypeModel]?
    var lstProductService: [NCBFeedbackTypeModel]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        lstFeedbackType <- map["lstFeedbackType"]
        lstProductService <- map["lstProductService"]
    }
}
