//
//  NCBDealStatementModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBDealStatementModel: NCBBaseModel {
    var content : [NCBDetailHistoryDealItemModel]?
    var first : Bool?
    var last : Bool?
    var number : Int?
    var numberOfElements : Int?
    var size : Int?
    var sort : String?
    var totalElements : Int?
    var totalPages : Int?
    
    override func mapping(map: Map) {
        content <- map["content"]
        first <- map["first"]
        last <- map["last"]
        number <- map["number"]
        numberOfElements <- map["numberOfElements"]
        size <- map["size"]
        sort <- map["sort"]
        totalElements <- map["totalElements"]
        totalPages <- map["totalPages"]
    }
}
