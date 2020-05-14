//
//  NCBSourceAccountModel.swift
//  NCBApp
//
//  Created by Thuan on 4/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


class NCBSourceAccountModel : NCBBaseModel {
    
    var accountName   : String?
    var accountNumber  : String?
    var accountTotal: Double?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
    }
}
