//
//  NCBBannerModel.swift
//  NCBApp
//
//  Created by Van Dong on 30/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

enum BannerCodeType: String {
    case FLASH
    case HOME_POPUP
    case HOME_BANNER
    case TOPUP_BANNER
    case PAY_BANNER
    case CARD_BANNER
    case LOGIN_POPUP
    case TRANSFER_BANNER
    case NEW
}

enum BannerActionType: String {
    case URT
    case IBT
    case ISL
    case BILL
    case OPEN
    case SERVICE
    case TOP
    case EWL
}

class NCBBannerModel: NCBBaseModel {
    
    var id: Int?
    var bannerCode: String?
    var urlImg: String?
    var urlImgEn: String?
    var urlImgVn: String?
    var createdDate: String?
    var action: String?
    var oneTimeShow: Bool?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        id <- map["id"]
        bannerCode <- map["bannerCode"]
        action <- map["action"]
        urlImg <- map["urlImg"]
        urlImgEn <- map["urlImgEn"]
        urlImgVn <- map["urlImgVn"]
        createdDate <- map["createdDate"]
        oneTimeShow <- map["oneTimeShow"]
    }
    
}
