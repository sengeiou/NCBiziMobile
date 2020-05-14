//
//  NCBQRTransferHistoryItemModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/11/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBQRTransferHistoryItemModel: NCBBaseModel {
    var bookDate     : String?
    var marchantName : String?
    var amount       : String?
    var ccy          : String?
    var id           : String?
    
    override func mapping(map: Map) {
        bookDate     <- map["bookDate"]
        marchantName <- map["marchantName"]
        amount       <- map["amount"]
        ccy          <- map["ccy"]
        id           <- map["id"]
    }
}
