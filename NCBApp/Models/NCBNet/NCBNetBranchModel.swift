//
//  NCBNetBranchModel.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBNetBranchModel: NCBBaseModel {
    
    var phone: String?
    var name: String?
    var departName: String?
    var address: String?
    var longitude: String?
    var fax: String?
    var latitude: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        phone <- map["phone"]
        name <- map["name"]
        departName <- map["departName"]
        address <- map["address"]
        longitude <- map["longitude"]
        fax <- map["fax"]
        latitude <- map["latitude"]
    }
    
    var getDisplayName: String {
        if let name = name {
            return name
        }
        
        return departName ?? ""
    }
    
}
