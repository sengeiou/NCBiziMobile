//
//  NCBDestinationAccountModel.swift
//  NCBApp
//
//  Created by Thuan on 5/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


class NCBDestinationAccountModel : NCBBaseModel {
    
    var accountName  : String?
    var region   : String?
    var bankName  : String?
    var branchid    : String?
    var bankid : String?
    var currency   : String?
    var accountNumber : String?
    var bankShortName : String?
    var cif : String?
    var branchName : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        accountName <- map["accountName"]
        region <- map["region"]
        bankName <- map["bankName"]
        branchid <- map["branchid"]
        currency <- map["currency"]
        accountNumber <- map["accountNumber"]
        bankShortName <- map["bankShortName"]
        cif <- map["cif"]
        branchName <- map["branchName"]
    }
}
