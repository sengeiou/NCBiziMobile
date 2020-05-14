//
//  NCBAppConstant.swift
//  NCBApp
//
//  Created by Thuan on 4/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum ResponseCodeConstant {
    static let success = "00"
    static let systemError = "-1"
    static let billPaid = "97"
    static let t24TimeOuted = "01"
}

enum StringConstant {
    static let rootUrl = "http://113.20.126.169:8080/gateway-server"//"https://www.ncb-bank.vn/ncbs"
    static let invalidToken = "invalid_token"
    static let passwordExpired = "password_expired"
    static let agribankCode = "204"
    static let ncbCode = "-1"
    static let salaryAccountCode = "1002"
    static let overdraftAccountCode = "1301"
    static let specialCharacters = "!@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢₫"
    static let prefixMofinURL = "ncbizimobile://view?"
    static let hotLineDefault = "18006166"
    static let var1MsgNeedRepalce = "[1]"
    static let var2MsgNeedRepalce = "[2]"
    static let loginByTouchID = "-RegisterByTouchId"
    static let loginByFaceID = "-RegisterByFaceID"
}

enum NumberConstant {
    static let commonRadius: CGFloat = 8
    static let commonHeightTextField: CGFloat = 60
    static let largeFontSize: CGFloat = 18
    static let commonFontSize: CGFloat = 14
    static let smallFontSize: CGFloat = 12
    static let numberOfOTPDigits = 6
    static let otpViewHeight: CGFloat = 200
}

enum ErrorConstant {
    static let crdCardLocked = "CARD-14"
    static let crdCardNoStatement = "CARD-15"
    static let crdCardNoStatementData = "CARD-22"
    static let crdCardNoEnterAmount = "CARD-23"
    static let crdCardPaymentMoreThan200 = "CARD-25"
    static let crdCardListNoData = "CARD-29"
    static let crdCardChangeInfoDebtDeduction = "CARD-31"
    static let crdCardExpired = "CARD-32"
    static let crdCardNotAllowOpen = "CARD-1"
    static let crdCardReissueChooseReason = "CARD-6"
    static let crdCardReissueChooseBranch = "CARD-2"
    static let crdCardReissueNotExist = "CARD-41"
    static let crdCardRegNewOpened = "CARD-5"
    static let crdCardChooseProduct = "CARD-3"
    static let crdCardChooseRank = "CARD-4"
    static let crdCardChooseBank = "CARD-8"
    static let crdCardChooseCreditLimit = "CARD-9"
    static let crdCardChooseMonthlyIncome = "CARD-10"
    static let crdCardChooseMonthlyCost = "CARD-11"
    static let crdCardRegNewRequestedOpen = "CARD-34"
    static let crdCardResupplyPinChooseBranch = "CARD-35"
    static let crdCardChooseName = "CARD-36"
    static let crdCardChooseCMT = "CARD-37"
    static let crdCardChoosePhone = "CARD-38"
}

// MARK: - Hex color constant

enum ColorName: String {
    case mediumBlue = "2a6dbb"
    case amountBlue = "90c9ff"
    case pinkishRed = "ec1c24"
    case placeHolder = "CFCFD3"
    case bottomLine = "EDEDED"
    case blackText = "000000"
    case normalText = "242424"
    case holderText = "6B6B6B"
    case blurNormalText = "414141"
    case amountBlueText = "006EC8"
    case buttonBlueText = "0064E1"
    case amountRedText = "EC2227"

    var color: UIColor? {
        return UIColor(hexString: rawValue)
    }
}
