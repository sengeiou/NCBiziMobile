//
//  NCBHistoryDeaItemModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

enum TransType: String {
    case internalTransfer = "URT"
    case citad = "IBT"
    case fast247 = "ISL"
    case payBill = "BILL"
    case rechargePhone = "TOP"
    case rechargeAirpay = "EWL"
    case addSaving = "PLUS"
    case saving = "OPEN"
    case settlementSaving = "REDEEM"
    case crdCardPayment = "VPMT"
}

class NCBDetailHistoryDealItemModel: NCBBaseModel {
    
    var actno         : String?
    var txndate       : String?
    var txntime       : String?
    var seqno         : String?
    var message       : String?
    var curCode       : String?
    var amount        : Double?
    var dorc          : String?
    var destAcctNo    : String?
    var destAcctName  : String?
    var ddtxn         : String?
    var txndateFormat : String?
    var ddtxnDesc     : String?
    var benBank: String?
    var benBankName: String?
    var transType: String?
    var transTypeDesc: String?
    var actno_name: String?
    var status: String?
    var system_id: String?
    var merchant_name: String?
    var bill_no: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
         actno         <- map["actno"]
         txndate       <- map["txndate"]
         txntime       <- map["txntime"]
         seqno         <- map["seqno"]
         message       <- map["message"]
         curCode       <- map["curCode"]
         amount        <- map["amount"]
         dorc          <- map["dorc"]
         destAcctNo    <- map["destAcctNo"]
         destAcctName  <- map["destAcctName"]
         ddtxn         <- map["ddtxn"]
         txndateFormat <- map["txndateFormat"]
         ddtxnDesc     <- map["ddtxnDesc"]
         benBank <- map["benBank"]
         benBankName <- map["benBankName"]
         transType <- map["transType"]
         transTypeDesc <- map["transTypeDesc"]
         actno_name <- map["actno_name"]
         status <- map["status"]
        system_id <- map["system_id"]
        merchant_name <- map["merchant_name"]
        bill_no <- map["bill_no"]
    }
    
    func getAmount() -> Double? {
        if isNegativeNumb(dorc ?? "") {
            return -(amount ?? 0.0)
        } else {
            return amount ?? 0.0
        }
    }
    
    var getAmountColor: UIColor {
        return isNegativeNumb(dorc ?? "") ? ColorName.amountRedText.color! : ColorName.amountBlueText.color!
    }
    
    final func getMonthName() -> String {
        guard let dateStr = self.txndateFormat else {
            return ""
        }
        
        guard let date = ddMMyyyyFormatter.date(from: dateStr) else {
            return ""
        }
        
        return monthYearFormatter.string(from: date)
    }
    
    func getTransactionType(_ listTransactionType: [NCBTransactionTypeModel]) -> String {
        for type in listTransactionType {
            if transType == type.configMbappPK?.value {
                return type.name ?? ""
            }
        }
        return ""
    }
    
    var getTime: String {
        if let strTime = txntime, let time = HHmmss.date(from: strTime) {
            return "\(hh24mmFormatter.string(from: time)) \(txndateFormat ?? "")"
        }
        
        return txndateFormat ?? ""
    }
    
}
