//
//  NCBBaseModel.swift
//  NCBApp
//
//  Created by Thuan on 4/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBBaseModel: NSObject, Mappable {
    
    override init() {
        super.init()
    }
    
    // MARK: - Properties
    
    // MARK: - Mappable
    
    required convenience init?(map: ObjectMapper.Map) {
        self.init()
    }
    
    func mapping(map: ObjectMapper.Map) {
        
    }
    
}
