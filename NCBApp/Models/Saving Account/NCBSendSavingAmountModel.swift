//
//  NCBSendSavingAmountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

enum SendSavingFromValue: Int {
    case acummulate = 1
    case iSaving = 2
}

class NCBSendSavingAmountModel: NCBBaseModel {
    var lstInterestTerm : [NCBSendSavingItemModel]?
    var lstRollTypes : [NCBSendSavingItemModel]?
    var lstTerms : [NCBSendSavingItemModel]?
    var lstAccumulateInterestTerm: [NCBSendSavingItemModel]?
    
    override func mapping(map: Map) {
        lstAccumulateInterestTerm <- map["lstKyTinhLaiGG"]
        lstInterestTerm <- map["lstKyTinhLai"]
        lstRollTypes <- map["lstRollTypes"]
        lstTerms <- map["lstTerms"]
        
    }
}
