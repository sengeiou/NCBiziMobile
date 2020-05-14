//
//  NCBOpenSavingAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/20/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBOpenSavingAccountModel: NCBBaseModel {
    var amount : String?
    var benAcct : String?
    var branchCode : String?
    var ccy : String?
    var cifNo : String?
    var debitAcct : String?
    var dest : String?
    var fdend : String?
    var interest : String?
    var officeCode : String?
    var tellerId : String?
    var term : String?
    var termStr: String?
    var typeId: String?
    
    override func mapping(map: Map) {
        amount <- map["amount"]
        benAcct <- map["benAcct"]
        branchCode <- map["branchCode"]
        ccy <- map["ccy"]
        cifNo <- map["cifNo"]
        debitAcct <- map["debitAcct"]
        dest <- map["dest"]
        fdend <- map["fdend"]
        interest <- map["interest"]
        officeCode <- map["officeCode"]
        tellerId <- map["tellerId"]
        term <- map["term"]
        termStr <- map["termStr"]
        typeId <- map["typeId"]
    }
}
