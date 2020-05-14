//
//  NCBCharityOrganizationModel.swift
//  NCBApp
//
//  Created by Thuan on 5/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


class NCBCharityOrganizationModel : NCBBaseModel {
    
    var accname : String?
    var accno : String?
    var bnkcode : String?
    var bnkcodegt : String?
    var bnkcodett : String?
    var bnkname : String?
    var brncodegt : AnyObject?
    var brncodett : AnyObject?
    var brnname : String?
    var status : String?
    var txntype : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        accname <- map["accname"]
        accno <- map["accno"]
        bnkcode <- map["bnkcode"]
        bnkcodegt <- map["bnkcodegt"]
        bnkcodett <- map["bnkcodett"]
        bnkname <- map["bnkname"]
        brncodegt <- map["brncodegt"]
        brncodett <- map["brncodett"]
        brnname <- map["brnname"]
        status <- map["status"]
        txntype <- map["txntype"]
    }
}
