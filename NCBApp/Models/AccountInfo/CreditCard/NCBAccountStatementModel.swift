//
//  NCBAccountStatementModel.swift
//  NCBApp
//
//  Created by Thuan on 7/26/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBAccountStatementModel: NCBBaseModel {
    var closingBalance: Double?
    var closingBalanceSign : String?
    var openingBalanceSign : String?
    var openingBalance : Double?
    var lstPreCrCardHistory : [NCBCreditCardDealHistoryModel]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        closingBalance <- map["closingBalance"]
        closingBalanceSign <- map["closingBalanceSign"]
        openingBalanceSign <- map["openingBalanceSign"]
        openingBalance <- map["openingBalance"]
        lstPreCrCardHistory <- map["lstPreCrCardHistory"]
    }
    
    var getOpeningBalance: String {
        if let openingBalance = openingBalance, openingBalance > 0 {
            return "\(openingBalance.currencyFormatted)"
        }
        return "\(openingBalanceSign ?? "")\((openingBalance ?? 0).currencyFormatted)"
    }
    
    var getClosingBalance: String {
        if let closingBalance = closingBalance, closingBalance > 0 {
            return "\(closingBalance.currencyFormatted)"
        }
        return "\(closingBalanceSign ?? "")\((closingBalance ?? 0).currencyFormatted)"
    }
}
