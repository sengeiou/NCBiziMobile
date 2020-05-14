//
//  NCBTermOfUseModel.swift
//  NCBApp
//
//  Created by Thuan on 9/26/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBTermOfUseModel: NCBBaseModel {
    
    var status: String?
    var provisionLink: String?
    var provisionName: String?
    var id: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        status <- map["status"]
        provisionLink <- map["provisionLink"]
        provisionName <- map["provisionName"]
        id <- map["id"]
    }
    
}
