//
//  NCBMenuIconModel.swift
//  NCBApp
//
//  Created by Thuan on 4/4/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

enum IconType: String {
    case accountInfo
    case transferInternal
    case transferInterbank
    case transfer247
    case payTheBill
    case rechargePhone
    case saving
    case searchTransaction
    case editFunction
    case charity
    case settlementSaving
    case rechargeSaving
    case qrpay
    case creditPayment
    case wallet
    case net
    case contact
    case support
}

class NCBMenuIconModel: NCBBaseModel, NSCopying {
    
    var title: String = ""
    var image: String = ""
    var imageDisabled: String = ""
    var type: String = ""
    var canRemove = true
    var existsForMain = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        image <- map["image"]
        image <- map["imageDisabled"]
        type <- map["type"]
        canRemove <- map["canRemove"]
        existsForMain <- map["existsForMain"]
    }
    
    // MARK: NSCoding
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = NCBMenuIconModel()
        copy.title = title
        copy.image = image
        copy.type = type
        copy.canRemove = canRemove
        copy.existsForMain = existsForMain
        return copy
    }
    
}
