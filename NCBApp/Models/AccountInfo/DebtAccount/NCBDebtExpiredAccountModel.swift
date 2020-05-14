//
//  NCBDebtExpiredAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/22/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBDebtExpiredAccountModel: NCBBaseModel {
    
    var ccy                 : String?
    var contractNo          : String?
    var fstReleaseDate      : String?
    var interestPaymentDate : String?
    var interestRate        : Float?
    var matDate             : String?
    var nextInterestAmount  : Int?
    var nextPaymentAmount   : Int?
    var orgCurBalance       : Int?
    var paymentDate         : String?
    
    override func mapping(map: Map) {
        ccy                 <- map["ccy"]
        contractNo          <- map["contractNo"]
        fstReleaseDate      <- map["fstReleaseDate"]
        interestPaymentDate <- map["interestPaymentDate"]
        interestRate        <- map["interestRate"]
        matDate             <- map["matDate"]
        nextInterestAmount  <- map["nextInterestAmount"]
        nextPaymentAmount   <- map["nextPaymentAmount"]
        orgCurBalance       <- map["orgCurBalance"]
        paymentDate         <- map["paymentDate"]
    }
}
