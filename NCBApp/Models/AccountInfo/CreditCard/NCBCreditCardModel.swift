//
//  NCBCreditCardModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

enum CreditCardType: String {
    case DB
    case VD
    case VS
}

enum CardServiceActiveType: Int {
    case lock = 0
    case open
    case activate
    case none
}

enum AutoDebtCardServiceType: Int {
    case registered = 0
    case unregistered
    case none
}

enum RepayModeType: Int {
    case MinimumDue = 0
    case TotalBalance
    case Percentage
}

enum RepayModeString: String {
    case MinimumDue = "MINIMUM DUE"
    case TotalBalance = "TOTAL BALANCE"
    case Percentage = "PERCENTAGE"
}

class NCBCreditCardModel: NCBBaseModel {
    
    var acctno : String?
    var amountAvailableToSpend : Double?
    var authorisedAmount : Double?
    var cardname : String?
    var cardno : String?
    var cardtype : String?
    var cifno : String?
    var closingDate : String?
    var creditLimit : Double?
    var curcode : String?
    var daoName : String?
    var expiryDate : String?
    var ledBalance : Double?
    var minimumDue : Double?
    var minimumDueSign : String?
    var parCardProduct : NCBParCardProduct?
    var prdcode : String?
    var primarycard : Int?
    var statementOpenDate : String?
    var status : String?
    var validFrom : String?
    var ctrDate: String?
    var lstDate: String?
    var autoDebitBankacct: String?
    var accountOpenDate: String?
    var autoDebit: String?
    var repayMode: String?
    var expiryDateStatus: String?
    var ecom: String?
    var stGeneral: String?
    var cardCancelCode: String?
    var flagConnect: String?
    
    //Local properties
    
    var isSelected = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        primarycard <- map["primarycard"]
        minimumDue <- map["minimumDue"]
        closingDate <- map["closingDate"]
        prdcode <- map["prdcode"]
        ledBalance <- map["ledBalance"]
        cifno <- map["cifno"]
        cardname <- map["cardname"]
        cardtype <- map["cardtype"]
        creditLimit <- map["creditLimit"]
        status <- map["status"]
        acctno <- map["acctno"]
        parCardProduct <- map["parCardProduct"]
        validFrom <- map["validFrom"]
        expiryDateStatus <- map["expiryDateStatus"]
        stGeneral <- map["stGeneral"]
        authorisedAmount <- map["authorisedAmount"]
        ledBalance <- map["ledBalance"]
        curcode <- map["curcode"]
        cardCancelCode <- map["cardCancelCode"]
        cardno <- map["cardno"]
        accountOpenDate <- map["accountOpenDate"]
        daoName <- map["daoName"]
        expiryDate <- map["expiryDate"]
        amountAvailableToSpend <- map["amountAvailableToSpend"]
        statementOpenDate <- map["statementOpenDate"]
        ctrDate <- map["ctrDate"]
        lstDate <- map["lstDate"]
        autoDebit <- map["autoDebit"]
        autoDebitBankacct <- map["autoDebitBankacct"]
        repayMode <- map["repayMode"]
        ecom <- map["ecom"]
        flagConnect <- map["flagConnect"]
        ecom <- map["ecom"]
    }
    
    func getCardNo() -> String{
        return cardno?.cardHidden ?? ""
    }
    
    func getCardTypeName() -> String{
        return parCardProduct?.product ?? ""
    }
    
    func getCardType() -> CreditCardType{
        if let cardtype = cardtype {
            if cardtype.trim.uppercased() == CreditCardType.VS.rawValue {
                return CreditCardType.VS
            }
            if cardtype.trim.uppercased() == CreditCardType.DB.rawValue {
                return CreditCardType.DB
            }
        }
        return CreditCardType.VD
    }
    
    func getActiveType() -> CardServiceActiveType{
        if let cardtype = cardtype {
            if cardtype.trim.uppercased() == CreditCardType.VS.rawValue {
                if flagConnect?.trim.uppercased() == "S" {
                    if let cardCancelCode = cardCancelCode, !cardCancelCode.isEmpty {
                        if cardCancelCode.trim.uppercased() == "A" {
                            return CardServiceActiveType.activate
                        }else {
                            return CardServiceActiveType.open
                        }
                    }else{
                        return CardServiceActiveType.lock
                    }
                } else if flagConnect?.trim.uppercased() == "F" {
                    return CardServiceActiveType.open
                }
            } else if cardtype.trim.uppercased() == CreditCardType.DB.rawValue {
                if stGeneral?.trim.uppercased() == "NORM" {
                    return CardServiceActiveType.lock
                }
                return CardServiceActiveType.open
            }
            
        }
        return CardServiceActiveType.none
    }
    
    var allowOpen: Bool {
        if getActiveType() != .open {
            return true
        }
        if let cardtype = cardtype {
            if cardtype.trim.uppercased() == CreditCardType.VS.rawValue {
                if let cardCancelCode = cardCancelCode, cardCancelCode.trim.uppercased() != "T" {
                    return false
                }
            } else if cardtype.trim.uppercased() == CreditCardType.DB.rawValue {
                let generalStr = stGeneral?.trim.uppercased()
                if generalStr != "NORM" && generalStr != "BLCK" {
                    return false
                }
            }
            
        }
        return true
    }
    
    var cardDBIsLocked: Bool {
        if let cardtype = cardtype, cardtype.trim.uppercased() == CreditCardType.DB.rawValue {
            if stGeneral?.trim.uppercased() != "NORM" {
                return true
            }
        }
        return false
    }
    
    func getAutoDebtCardServiceType() -> AutoDebtCardServiceType{
        if autoDebit == "YES" {
            return AutoDebtCardServiceType.registered
        }
        return AutoDebtCardServiceType.unregistered
        
    }
    
    func getRepayModeType() -> RepayModeType {
        switch repayMode {
        case RepayModeString.MinimumDue.rawValue:
            return RepayModeType.MinimumDue
        case RepayModeString.TotalBalance.rawValue:
            return RepayModeType.TotalBalance
        default:
            return RepayModeType.Percentage
        }
    }
    
    var registeredECOM: Bool {
        return (ecom == "Y")
    }
    
    var registeredAutoDebit: Bool {
        return (autoDebit == "Y")
    }
    
    var isPrimaryCard: Bool {
        return (primarycard == 1)
    }
    
    var isExpired: Bool {
        if let strDate = lstDate, let date = yyyyMMdd.date(from: strDate), date < Date() {
            return true
        }
        return false
    }
    
}
