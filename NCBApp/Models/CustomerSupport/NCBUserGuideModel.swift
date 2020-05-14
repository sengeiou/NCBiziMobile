//
//  NCBUserGuideModel.swift
//  NCBApp
//
//  Created by Van Dong on 08/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBUserGuideModel: NCBBaseModel{
    var link: String?
    var serviceId: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        link <- map["link"]
        serviceId <- map["serviceId"]

    }
}
