//
//  NCBDetailSavingAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/18/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBDetailSavingAccountModel: NCBBaseModel {
    var account      : String?
    var balance      : Double?
    var ccy          : String?
    var channel      : String?
    var interst      : Double?
    var matDate      : String?
    var openDate     : String?
    var prodName     : String?
    var savingNumber : String?
    var termDest     : String?
    var fdtrmcd      : String?
    
    override func mapping(map: Map){
        account      <- map["account"]
        balance      <- map["balance"]
        ccy          <- map["ccy"]
        channel      <- map["channel"]
        interst      <- map["interst"]
        matDate      <- map["matDate"]
        openDate     <- map["openDate"]
        prodName     <- map["prodName"]
        savingNumber <- map["savingNumber"]
        termDest     <- map["termDest"]

    }
}
