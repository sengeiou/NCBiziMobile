//
//  NCBQRTransferHistoryDetailModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBQRTransferHistoryDetailModel: NCBBaseModel {
    var bookDate     : String?
    var marchantName : String?
    var amount       : String?
    var ccy          : String?
    var billNo       : String?
    var accountNo    : String?
    var recevingAddr : String?
    var merchantNo   : String?
    
    override func mapping(map: Map) {
        bookDate     <- map["bookDate"]
        marchantName <- map["marchantName"]
        amount       <- map["amount"]
        ccy          <- map["ccy"]
        billNo       <- map["billNo"]
        accountNo    <- map["accountNo"]
        recevingAddr <- map["recevingAddr"]
        merchantNo   <- map["merchantNo"]
    }
}
