//
//  NCBGetQuestionAnswerModel.swift
//  NCBApp
//
//  Created by Van Dong on 08/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBQuestionAnswerModel: NCBBaseModel{
    var answer: String?
    var question: String?
    var productCode: String?
    var productName: String?
    var isOpened = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        answer <- map["answer"]
        question <- map["question"]
        productCode <- map["productCode"]
        productName <- map["productName"]
    }
}
