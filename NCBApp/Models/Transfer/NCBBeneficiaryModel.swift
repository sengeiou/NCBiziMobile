//
//  NCBBeneficiaryModel.swift
//  NCBApp
//
//  Created by Thuan on 4/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


class NCBBeneficiaryModel : NCBBaseModel {
    
    var benId: Int?
    var benBankName  : String?
    var accountName   : String?
    var memName  : String?
    var curCode  : String?
    var benBank  : String?
    var province  : String?
    var provinceName  : String?
    var accountNo  : String?
    var branch  : String?
    var branchName  : String?
    var typeTransfer: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        benId <- map["benId"]
        benBankName <- map["benBankName"]
        accountName <- map["accountName"]
        memName <- map["memName"]
        curCode <- map["curCode"]
        benBank <- map["benBank"]
        province <- map["province"]
        provinceName <- map["provinceName"]
        accountNo <- map["accountNo"]
        branch <- map["branch"]
        branchName <- map["branchName"]
        typeTransfer <- map["typeTransfer"]
    }
    
    var isCard: Bool {
        if typeTransfer == "CK247-CARD" {
            return true
        }
        
        return false
    }
    
    func getMemName() -> String? {
        return (((memName?.count ?? 0) > 0) ? memName : accountName)
    }
}
