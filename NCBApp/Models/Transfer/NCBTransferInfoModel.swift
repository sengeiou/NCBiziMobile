//
//  NCBTransferInfoModel.swift
//  NCBApp
//
//  Created by Thuan on 5/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


class NCBTransferInfoModel : NCBBaseModel {
    
    var flagBenefit  : Bool?
    var amount   : Double?
//    var transferType  : String?
    var creditCif    : String?
    var debitAcct : String?
    var minimumBalance   : String?
    var fee : Double?
    var workingBalance : String?
    var narrative : String?
    var creditAcct : String?
    var debitCif : String?
    var creditName: String?
    var creditBankCode: String?
    var creditBankName: String?
    var creditBranchCode: String?
    var creditBranchName: String?
    var creditProvinceCode: String?
    var creditProvinceName: String?
    var duty: String?
    
    //MARK: Local properties
    
    var memName: String?
    
    // Charity
    
    var txntype: String?
    var bnkcode: String?
    
    //24/7
    
//    var benBankCode: String?
//    var benBankAcctCard: String?
//    var benName: String?
    var typeTransfer: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        flagBenefit <- map["flagBenefit"]
        amount <- map["amount"]
//        transferType <- map["transferType"]
        creditCif <- map["creditCif"]
        debitAcct <- map["debitAcct"]
        minimumBalance <- map["minimumBalance"]
        fee <- map["fee"]
        workingBalance <- map["workingBalance"]
        narrative <- map["narrative"]
        creditAcct <- map["creditAcct"]
        debitCif <- map["debitCif"]
        creditName <- map["creditName"]
        creditBankCode <- map["creditBankCode"]
        creditBankName <- map["creditBankName"]
        creditBranchCode <- map["creditBranchCode"]
        creditBranchName <- map["creditBranchName"]
        creditProvinceCode <- map["creditProvinceCode"]
        creditProvinceName <- map["creditProvinceName"]
        duty <- map["duty"]
        
        txntype <- map["txntype"]
        bnkcode <- map["bnkcode"]
        
//        benBankCode <- map["benBankCode"]
//        benBankAcctCard <- map["benBankAcctCard"]
//        benName <- map["benName"]
        typeTransfer <- map["typeTransfer"]
    }
}
