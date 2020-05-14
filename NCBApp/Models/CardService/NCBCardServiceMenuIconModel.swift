//
//  File.swift
//  NCBApp
//
//  Created by ADMIN on 7/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

enum CardServiceMenuIcon: Int {
    case cardPayment = 0
    case onlinePayment
    case openLockActivateCard
    case autoDebtDeduction
    case registrationCard
    case resupplyPIN
}

class NCBCardServiceMenuIconModel: NCBBaseModel, NSCopying {
    
    var title: String = ""
    var image: String = ""
    var type: CardServiceMenuIcon = .cardPayment
    var canRemove = true
    var existsForMain = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        title <- map["title"]
        image <- map["image"]
        type <- map["type"]
        canRemove <- map["canRemove"]
        existsForMain <- map["existsForMain"]
    }
    
    // MARK: NSCoding
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = NCBCardServiceMenuIconModel()
        copy.title = title
        copy.image = image
        copy.type = type
        copy.canRemove = canRemove
        copy.existsForMain = existsForMain
        return copy
    }
    
}

