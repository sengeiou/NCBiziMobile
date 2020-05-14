//
//  NCBMailboxModel.swift
//  NCBApp
//
//  Created by ADMIN on 8/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//


import Foundation
import ObjectMapper


class NCBMailboxModel: NCBBaseModel {
    var emailId: String?
    var contentTitle:String?
    var content :String?
    var status: String?
    var createdDate = ""
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        emailId <- map["emailId"]
        contentTitle <- map["contentTitle"]
        content <- map["content"]
        status <- map["status"]
        createdDate <- map["createdDate"]
    }
    
    func isRead() -> Bool{
        if let status = status{
            if status.trim == "01"{
                return false
            }else{
                return true
            }
        }
        return false
    }
    
    func getCreatedDate() -> String {
        if let date = yyyyMMddHHmmssFormatter.date(from: createdDate) {
            return dateTimeFormatter.string(from: date)
        }
        return createdDate
    }
    
}
