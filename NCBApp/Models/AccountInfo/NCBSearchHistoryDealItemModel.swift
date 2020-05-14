//
//  NCBSearchHistoryDealItemModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBSearchHistoryDealItemModel: NCBBaseModel {
    var acctno : String?
    var amount : Double?
    var curcode : String?
    var dorc : String?
    var message : String?
    var receiver : String?
    var seqno : Int?
    var transDate : Int?
    var transDateFormat : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        acctno <- map["acctno"]
        amount <- map["amount"]
        curcode <- map["curcode"]
        dorc <- map["dorc"]
        message <- map["message"]
        receiver <- map["receiver"]
        seqno <- map["seqno"]
        transDate <- map["transDate"]
        transDateFormat <- map["transDateFormat"]
    }
    func getAmount() -> Double?{
        if isNegativeNumb(dorc ?? "") {
            return -(amount ?? 0.0)
        } else {
            return amount ?? 0.0
        }
    }
}
