//
//  NCBUpdateCardStatusUnlockConfirmModel.swift
//  NCBApp
//
//  Created by ADMIN on 7/26/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBUpdateCardStatusUnlockConfirmModel: NCBBaseModel {
    
    var msgid : String?
    var cardName : String?
    var cardType : String?
    var cardNo : String?

    override func mapping(map: Map) {
        super.mapping(map: map)
    
        msgid <- map["msgid"]
        cardName <- map["cardName"]
        cardType <- map["cardType"]
        cardNo <- map["cardNo"]
    }
    

    
}
