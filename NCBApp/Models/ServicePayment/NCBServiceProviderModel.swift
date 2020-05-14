//
//  NCBServiceProviderModel.swift
//  NCBApp
//
//  Created by Thuan on 6/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

class NCBServiceProviderModel: NCBBaseModel {
    
    var partner : String?
    var providerCode : String?
    var providerName : String?
    var serviceCode : String?
    var status : String?
    
    //MARK: Local properties
    
    var customerCode : String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        partner <- map["partner"]
        providerCode <- map["providerCode"]
        providerName <- map["providerName"]
        serviceCode <- map["serviceCode"]
        status <- map["status"]
    }
    
    var billName: String {
        switch serviceCode {
        case PayType.NUOC.rawValue:
            return "Hoá đơn nước"
        case PayType.DIEN.rawValue:
            return "Hoá đơn điện"
        case PayType.DTCDTS.rawValue:
            return "Hoá đơn di động trả sau"
        case PayType.DTCDCD.rawValue:
            return "Hoá đơn điện thoại cố định"
        case PayType.CAP.rawValue:
            return "Hoá đơn truyền hình"
        case PayType.NET.rawValue:
            return "Hoá đơn Internet"
        default:
            return ""
        }
    }
}
