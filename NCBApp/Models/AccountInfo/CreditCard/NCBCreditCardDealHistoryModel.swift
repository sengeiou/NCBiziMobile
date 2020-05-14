//
//  NCBCreditCardDealHistoryModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBCreditCardDealHistoryModel: NCBBaseModel {
    var cardNo : String?
    var localAmount : Double?
    var localAmountSign : String?
    var localCurrency : String?
    var merchantdescription : String?
    var transactionDate : String?
    var transactionTime: String?
    
    override func mapping(map: Map) {
        
        cardNo <- map["cardNo"]
        localAmount <- map["localAmount"]
        localAmountSign <- map["localAmountSign"]
        localCurrency <- map["localCurrency"]
        merchantdescription <- map["merchantDescription"]
        transactionDate <- map["transactionDate"]
        transactionTime <- map["transactionTime"]
    }
    
    var isNegative: Bool {
        return (localAmountSign == "-")
    }
    
    func getAmount() -> Double?{
        if isNegative {
            return -(localAmount ?? 0.0)
        } else {
            return localAmount ?? 0.0
        }
    }
    
    var getAmountColor: UIColor {
        return isNegative ? ColorName.amountRedText.color! : ColorName.amountBlueText.color!
    }
    
    var getTransactionTime: String {
//        var strTime = ""
        var strDate = ""
        
//        if let varTime = transactionTime, let date = HHmmssSSS.date(from: varTime.appending("0")) {
//            strTime = hh24mmFormatter.string(from: date)
//        }
        
        if let varDate = transactionDate, let date = yyyyMMdd.date(from: varDate) {
            strDate = ddMMyyyyFormatter.string(from: date)
        }
        
//        if strTime.count > 0 {
//            return "\(strTime) - \(strDate)"
//        }
        
        return strDate
    }
}
