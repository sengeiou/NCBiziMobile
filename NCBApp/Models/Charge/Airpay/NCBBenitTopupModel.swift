//
//  NCBBenitTopupModel.swift
//  NCBApp
//
//  Created by ADMIN on 7/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//


import ObjectMapper

class NCBBenitTopupModel: NCBBaseModel {
    
    var benfitBoss : [NCBBenfitPhoneModel]?
    var benfitPhone : [NCBBenfitPhoneModel]?

    override func mapping(map: Map) {
        super.mapping(map: map)
        
        benfitBoss <- map["benfitBoss"]
        benfitPhone <- map["benfitPhone"]
    }
    
}
