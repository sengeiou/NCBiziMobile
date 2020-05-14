//
//  NCBCustomerInfomationModel.swift
//  NCBApp
//
//  Created by Van Dong on 12/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBCustomerInfomationModel: NCBBaseModel {
    var fullName: String?
    var cifno: String?
    var cifname: String?
    var birthday: String?
    var email: String?
    var idno: String?
    var iddate: String?
    var idplace: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        fullName <- map["fullName"]
        cifno <- map["cifno"]
        cifname <- map["cifname"]
        birthday <- map["birthday"]
        email <- map["email"]
        idno <- map["idno"]
        iddate <- map["iddate"]
        idplace <- map["idplace"]
    }
}

