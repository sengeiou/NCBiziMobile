//
//  NCBGroupDetailSavingAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBGroupDetailSavingAccountModel: NCBBaseModel {
    var isavings      : [NCBGeneralSavingAccountInfoModel]?
    var totalBalGroup : Int?
    var grpName       : String?
    var isExpand       : Bool?
    
    override init() {
        self.isExpand = false
    }
    
    override func mapping(map: Map){
        isavings      <- map["isavings"]
        totalBalGroup <- map["totalBalGroup"]
        grpName       <- map["grpName"]
    }
}
