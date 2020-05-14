//
//  NCBUserModel.swift
//  NCBApp
//
//  Created by Thuan on 4/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import ObjectMapper

enum OtpRegType: String {
    case sms = "SMS"
    case soft = "SOFT"
    case email = "EMAIL"
}

class NCBUserModel: NCBBaseModel {
    
    var bankId : String?
    var branchId : String?
    var chpass : String?
    var cif : String?
    var cifType : String?
    var fullname : String?
    var lastLogin : String?
    var loginfailcnt : String?
    var mobile : String?
    var newStart : String?
    var regServ : String?
    var timeChangePass : String?
    var username : String?
    var imgname : String?
    var imgdata : String?
    var isDiffDevice: String?
    var otpReg: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        bankId <- map["bankId"]
        branchId <- map["branchId"]
        chpass <- map["chpass"]
        cif <- map["cif"]
        cifType <- map["cifType"]
        fullname <- map["fullname"]
        lastLogin <- map["lastLogin"]
        loginfailcnt <- map["loginfailcnt"]
        mobile <- map["mobile"]
        newStart <- map["newStart"]
        regServ <- map["regServ"]
        timeChangePass <- map["timeChangePass"]
        username <- map["username"]
        imgname <- map["imgname"]
        imgdata <- map["imgdata"]
        isDiffDevice <- map["isDiffDevice"]
        otpReg <- map["otpReg"]
    }
    
    func getAvatar() -> UIImage? {
        let base64Str = imgdata ?? ""
        return base64Str.base64ToImage() ?? UIImage(named: R.image.default_avatar.name)
    }
    
    func setImgName(name: String) {
        self.imgname = name
    }

    func setImgData(base64Str: String) {
        self.imgdata = base64Str
    }
    
    var onLoggedOtherDevice: Bool {
        return isDiffDevice == "1"
    }
    
    var softOtpRegistered: Bool {
        return otpReg == OtpRegType.soft.rawValue
    }
    
}
