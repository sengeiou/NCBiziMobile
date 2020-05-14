//
//  NCBGetListCardProductVisaModel.swift
//  NCBApp
//
//  Created by ADMIN on 8/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBGetListCardProductVisaModel: NCBBaseModel {
    var cardProduct: String?
    var cardClass: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        cardProduct <- map["cardProduct"]
        cardClass <- map["cardClass"]
    }
    
    func getProductName() -> String {
        return "\(cardProduct ?? "") - \(cardClass ?? "")"
    }
    
}
