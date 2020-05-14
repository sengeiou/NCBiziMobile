//
//  NCBParCardProductModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/18/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBParCardProduct: NCBBaseModel {
    
    var class_  : String?
    var issueFee   : String?
    var reissueFee  : String?
    var fileName    : String?
    var message : String?
    var f02   : String?
    var f05 : String?
    var linkUlr : String?
    var repinFee : String?
    var prdcode : String?
    var cardtype : String?
    var f03 : String?
    var activeFee : String?
    var changesttFee : String?
    var f04 : String?
    var status : String?
    var directddFee : String?
    var product : String?
    var f01 : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        class_ <- map["class_"]
        issueFee <- map["issueFee"]
        reissueFee <- map["reissueFee"]
        fileName <- map["fileName"]
        message <- map["message"]
        
        f02 <- map["f02"]
        f05 <- map["f05"]
        linkUlr <- map["linkUlr"]
        repinFee <- map["repinFee"]
        prdcode <- map["prdcode"]
        cardtype <- map["cardtype"]
        
        f03 <- map["f03"]
        activeFee <- map["activeFee"]
        changesttFee <- map["changesttFee"]
        f04 <- map["f04"]
        status <- map["status"]
        directddFee <- map["directddFee"]
        product <- map["product"]
        f01 <- map["f01"]

    }
}
