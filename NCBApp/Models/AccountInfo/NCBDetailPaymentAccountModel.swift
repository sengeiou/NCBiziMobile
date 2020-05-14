//
//  NCBDetailPaymentAccountModel.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

enum PaymentControlCode: String {
    case INFO = "INFO" //Phần thông tin tài khoản
    case CKNB = "CKNB" //CK nội bộ
    case CKCITAD = "CKCITAD" //CK thường
    case CK247 = "CK247" //CK nhanh 247
    case SAVING = "SAVING" //Mở sổ tiết kiệm, nộp thêm tiết kiệm
    case CARD = "CARD" //Thu phí thẻ, thanh toán thẻ tín dụng, các phần lquan tới thẻ
    case BIllING = "BIllING" //Thanh toán hóa đơn
    case TOPUP = "TOPUP" //Nạp topup
    case REGISTER = "REGISTER" //Đăng ký dịch vụ mới: Đăng ký SMS, đăng ký tk số đẹp
    case OTHER = "OTHER" //Các màn hình còn lại
}

class NCBDetailPaymentAccountModel: NCBBaseModel, NSCopying {
    var acName        : String?
    var acctNo        : String?
    var categoryCode  : String?
    var categoryName  : String?
    var cifNo         : Int?
    var curBal        : Double?
    var curCode       : String?
    var limit         : Double?
    var lockBal       : Double?
    var opnDate       : Int?
    var opnDateFormat : String?
    var status        : String?
    //MARK: local properties
    var isSelected = false
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        acName        <- map["acName"]
        acctNo        <- map["acctNo"]
        categoryCode  <- map["categoryCode"]
        categoryName  <- map["categoryName"]
        cifNo         <- map["cifNo"]
        curBal        <- map["curBal"]
        curCode       <- map["curCode"]
        limit         <- map["limit"]
        lockBal       <- map["lockBal"]
        opnDate       <- map["opnDate"]
        opnDateFormat <- map["opnDateFormat"]
        status        <- map["status"]
    }
    
    // MARK: NSCoding
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = NCBDetailPaymentAccountModel()
        copy.acName = acName
        copy.acctNo = acctNo
        copy.categoryCode = categoryCode
        copy.categoryName = categoryName
        copy.cifNo = cifNo
        copy.curBal = curBal
        copy.curCode = curCode
        copy.limit = limit
        copy.lockBal = lockBal
        copy.opnDate = opnDate
        copy.opnDateFormat = opnDateFormat
        copy.status = status
        copy.isSelected  = isSelected
        return copy
    }
}
