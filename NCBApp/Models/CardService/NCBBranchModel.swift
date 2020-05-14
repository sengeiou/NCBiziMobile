//
//  NCBBranchModel.swift
//  NCBApp
//
//  Created by ADMIN on 7/29/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBBranchModel: NCBBaseModel {
    
    var brn_code: String?
    var branch_name: String?
    var depart_code: String?
    var depart_name: String?
    var address: String?
    var phone: String?
    var fax: String?
    var latitude: String?
    var longitude: String?
    var url_img: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        brn_code <- map["brnCode"]
        branch_name <- map["branchName"]
        depart_code <- map["departCode"]
        depart_name <- map["departName"]
        address <- map["address"]
        phone <- map["phone"]
        fax <- map["fax"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        url_img <- map["urlImg"]
    }
    
}
