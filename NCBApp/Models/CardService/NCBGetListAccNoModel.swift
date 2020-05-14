//
//  NCBGetListAccNoModel.swift
//  NCBApp
//
//  Created by ADMIN on 8/30/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBGetListAccNoModel: NCBBaseModel {
    var cifNo: String?
    var acName: String?
    var acctNo: String?
    var curCode: String?
    var categoryName: String?
    var categoryCode: String?
    var curBal: Double?
    var isOpenATM: Int?
    var isRequestOpen: Int?
    var isSelected = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        cifNo <- map["cifNo"]
        acName <- map["acName"]
        curCode <- map["curCode"]
        acctNo <- map["acctNo"]
        categoryName <- map["categoryName"]
        categoryCode <- map["categoryCode"]
        curBal <- map["curBal"]
        isOpenATM <- map["isOpenATM"]
        isRequestOpen <- map["isRequestOpen"]
    }
    func openATM()-> Bool {
        if let isOpenATM = isOpenATM{
            if isOpenATM == 1{
                return true
            }
        }
        return false
    }
    func isRequestOpenATM() -> Bool{
        if let isRequestOpen = isRequestOpen{
            if isRequestOpen == 1{
                return true
            }
        }
        return false
    }
    
}
