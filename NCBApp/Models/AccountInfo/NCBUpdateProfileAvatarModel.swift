//
//  NCBUpdateProfileAvatarModel.swift
//  NCBApp
//
//  Created by ADMIN on 9/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBUpdateProfileAvatarModel: NCBBaseModel {
    var username : String?
    var imgname : String?
    var imgdata : String?
    var isupdate : Bool?

    override func mapping(map: Map) {
        username <- map["username"]
        imgname <- map["imgname"]
        imgdata <- map["imgdata"]
        isupdate <- map["isupdate"]

    }
}
