//
//  NCBUtil.swift
//  NCBApp
//
//  Created by Thuan on 4/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBUtil {
    
}

//MARK: AppDelegate instance

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let windowAppDelegate = appDelegate.window!

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

// MARK: - App version

let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as! String
let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as! String

//MARK: Notification name

let keyMainTabIndexChanged = "main_tab_index_changed"
let keyOpenFromURLScheme = "open_from_url_scheme"

//MARK: Key userdefault

let keyUserSaved = "user_saved"
let keyUserIDSaved = "user_id_saved"
let keyMenuIconSaved = "menu_icon_saved"
let keyLoginTouchIDStatus = "keyLoginTouchIDStatus"
let keyTransactionTouchIDStatus = "keyTransactionTouchIDStatus"
let keyDidSetLanguage = "keyDidSetLanguage"
let keyHotLine = "keyHotLine"
let keyAllMessage = "keyAllMessage"
let keyPopupShowed = "keyPopupShowed"
let keyUUIDSaved = "keyUUIDSaved"

//MARK: Fonts

func regularFont(size: CGFloat) -> UIFont? {
    let font = R.font.sfProTextRegular(size: size)
    return font
}

func mediumFont(size: CGFloat) -> UIFont? {
    let font = R.font.sfProTextMedium(size: size)
    return font
}

func boldFont(size: CGFloat) -> UIFont? {
    let font = R.font.sfProTextBold(size: size)
    return font
}

func displayBoldFont(size: CGFloat) -> UIFont? {
    let font = R.font.sfProDisplayBold(size: size)
    return font
}

func semiboldFont(size: CGFloat) -> UIFont? {
    let font = R.font.sfProTextSemibold(size: size)
    return font
}
func boldItalicFont(size: CGFloat) -> UIFont? {
    let font = R.font.sfProDisplayBoldItalic(size:size)
    return font
}


func lightFont(size: CGFloat) -> UIFont? {
    let font = R.font.sfProTextLight(size: size)
    return font
}

func italicFont(size: CGFloat) -> UIFont? {
    let font = R.font.sfProTextRegularItalic(size: size)
    return font
}

func getMainMenuIcon(_ saved: Bool) -> [NCBMenuIconModel] {
    if UserDefaults.standard.object(forKey: keyMenuIconSaved) != nil && saved {
        let json = UserDefaults.standard.object(forKey: keyMenuIconSaved) as! String
        let dataModels = Mapper<NCBMenuIconModel>().mapArray(JSONString: json) ?? [NCBMenuIconModel]()
        return dataModels
    }
    
    var dataModels = [NCBMenuIconModel]()
    
    var item = NCBMenuIconModel()
    item.title = "Thông tin tài khoản"
    item.image = R.image.ic_feature_info_account.name
    item.imageDisabled = R.image.ic_feature_info_account.name
    item.type = IconType.accountInfo.rawValue
    dataModels.append(item)
    
    item = NCBMenuIconModel()
    item.title = "Chuyển khoản nội bộ"
    item.image = R.image.ic_feature_internal_transfer.name
    item.imageDisabled = R.image.ic_feature_internal_transfer_disable.name
    item.type = IconType.transferInternal.rawValue
    dataModels.append(item)
    
    item = NCBMenuIconModel()
    item.title = "Chuyển khoản nhanh"
    item.image = R.image.ic_feature_247_transfer.name
    item.imageDisabled = R.image.ic_feature_247_transfer_disable.name
    item.type = IconType.transfer247.rawValue
    dataModels.append(item)
    
    item = NCBMenuIconModel()
    item.title = "Chuyển khoản thường"
    item.image = R.image.ic_feature_interbank_transfer.name
    item.imageDisabled = R.image.ic_feature_interbank_transfer_disable.name
    item.type = IconType.transferInterbank.rawValue
    dataModels.append(item)
    
    item = NCBMenuIconModel()
    item.title = "Thanh toán dịch vụ"
    item.image = R.image.ic_feature_pay_the_bill.name
    item.imageDisabled = R.image.ic_feature_pay_the_bill_disable.name
    item.type = IconType.payTheBill.rawValue
    dataModels.append(item)
    
    item = NCBMenuIconModel()
    item.title = "Nạp tiền điện thoại"
    item.image = R.image.ic_feature_rechange_price_phone.name
    item.imageDisabled = R.image.ic_feature_rechange_price_phone_disable.name
    item.type = IconType.rechargePhone.rawValue
    dataModels.append(item)
    
    item = NCBMenuIconModel()
    item.title = "Gửi tiết kiệm"
    item.image = R.image.ic_feature_saving.name
    item.imageDisabled = R.image.ic_feature_saving_disable.name
    item.type = IconType.saving.rawValue
    dataModels.append(item)
    
    item = NCBMenuIconModel()
    item.title = "Trạng thái giao dịch"
    item.image = R.image.ic_feature_search_transaction.name
    item.imageDisabled = R.image.ic_feature_search_transaction_disable.name
    item.type = IconType.searchTransaction.rawValue
    dataModels.append(item)
    
    item = NCBMenuIconModel()
    item.title = "Tuỳ chỉnh chức năng"
    item.image = R.image.ic_feature_edit_function.name
    item.imageDisabled = R.image.ic_feature_edit_function.name
    item.type = IconType.editFunction.rawValue
    dataModels.append(item)
    
    if let json = dataModels.toJSONString(), saved {
        UserDefaults.standard.set(json, forKey: keyMenuIconSaved)
        UserDefaults.standard.synchronize()
    }
    
    return dataModels
}

func isNegativeNumb(_ dorc: String) -> Bool {
    if dorc.lowercased() == "d" {
        return true
    } else {
        return false
    }
}

func doLogout() {
    NCBShareManager.shared.setAccessToken(nil)
    NCBShareManager.shared.setUser(nil)
    NCBShareManager.shared.areTrading = false
    if let vc = R.storyboard.login.ncbMainLoginViewController() {
        vc.isFirstStart = false
        let nav = UINavigationController(rootViewController: vc)
        appDelegate.window!.rootViewController = nav
        
    }
}

var isOpenLoginTouchID: Bool {
    if let value = UserDefaults.standard.object(forKey: keyLoginTouchIDStatus+NCBShareManager.shared.getUserID()) as? Bool, value {
        return true
    }
    
    return false
}

var isOpenTransactionTouchID: Bool {
    if let value = UserDefaults.standard.object(forKey: keyTransactionTouchIDStatus+NCBShareManager.shared.getUserID()) as? Bool, value {
        return true
    }
    
    return false
}

func getServiceType(_ serviceType: String) -> String {
    switch serviceType.uppercased() {
    case PayType.NUOC.rawValue:
        return "THANH TOÁN NƯỚC"
    case PayType.DIEN.rawValue:
        return "THANH TOÁN ĐIỆN"
    case PayType.DTCDTS.rawValue:
        return "THANH TOÁN DI ĐỘNG TRẢ SAU"
    case PayType.DTCDCD.rawValue:
        return "THANH TOÁN ĐIỆN THOẠI CỐ ĐỊNH"
    case PayType.CAP.rawValue:
        return "THANH TOÁN TRUYỀN HÌNH"
    case PayType.NET.rawValue:
        return "THANH TOÁN INTERNET"
    default:
        return serviceType
    }
}

var hasTopNotch: Bool {
    if #available(iOS 11.0,  *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    
    return false
}

enum MofinTransferDataKey: String {
    case toaccount
    case bankcode
    case bankname
    case amount
    case remark
}

struct MofinTransferDataModel {
    var toaccount = ""
    var bankcode = ""
    var bankname = ""
    var amount = ""
    var remark = ""
}

func getTransferDataFromUrl(_ url: String?) -> MofinTransferDataModel? {
    guard let url = url else {
        return nil
    }
    
//    let url1 = URL(string: "ncbmobilebanking://view?toaccount=100000662668&bankcode=970419&bankname=TMCP%20QUOC%20DAN%20(NCB)&amount=3000000&remark=TX1569387012252R731C1078882-1078882-TT-Thanh%20toan%20khoan%20vay%20ID%201078882")!.absoluteString
    
    var transferData = MofinTransferDataModel()
    
    let urlString = url.replacingOccurrences(of: StringConstant.prefixMofinURL, with: "").replacingOccurrences(of: "%20", with: " ")
    let separateArr = urlString.split(separator: "&")
    for item in separateArr {
        let separateItem = item.split(separator: "=")
        if separateItem.count > 1 {
            let key = separateItem[0].description
            let value = separateItem[1].description
            switch key {
            case MofinTransferDataKey.toaccount.rawValue:
                transferData.toaccount = value
            case MofinTransferDataKey.bankcode.rawValue:
                transferData.bankcode = value
            case MofinTransferDataKey.bankname.rawValue:
                transferData.bankname = value
            case MofinTransferDataKey.amount.rawValue:
                transferData.amount = value
            case MofinTransferDataKey.remark.rawValue:
//                let remarkArr = value.split(separator: "-")
                transferData.remark = value//remarkArr.last?.description ?? ""
            default:
                break
            }
        }
    }
    
    return transferData
}

func getConfirmType() -> String {
    let bio = BiometricIDAuth()
    if bio.biometricType() == .faceID {
        return TransactionConfirmType.FACEID.rawValue
    }
    return TransactionConfirmType.TOUCHID.rawValue
}

func getHotLine() -> String {
    if let phone = UserDefaults.standard.object(forKey: keyHotLine) as? String {
        return phone
    }
    return StringConstant.hotLineDefault
}

func addPopupShowed(_ item: NCBBannerModel) {
    var list = [NCBBannerModel]()
    if let data = UserDefaults.standard.object(forKey: keyPopupShowed) as? String {
        list = Mapper<NCBBannerModel>().mapArray(JSONString: data) ?? []
        if let _ = list.first(where: { $0.id == item.id }) {
            return
        }
    }
    
    list.append(item)
    
    UserDefaults.standard.set(list.toJSONString(), forKey: keyPopupShowed)
    UserDefaults.standard.synchronize()
}

func getPopupShowedList() -> [NCBBannerModel] {
    if let data = UserDefaults.standard.object(forKey: keyPopupShowed) as? String {
        let list = Mapper<NCBBannerModel>().mapArray(JSONString: data)
        return list ?? []
    }
    
    return []
}

func getBanners() -> [NCBBannerModel] {
    var banners = [NCBBannerModel]()
    if let data = UserDefaults.standard.object(forKey: "Banner") as? String {
        banners = Mapper<NCBBannerModel>().mapArray(JSONString: data) ?? []
    }
    return banners
}

func removeTouchIDSession() {
    NCBKeychainService.removeLoginTouchID()
    NCBKeychainService.removeTransactionTouchID()
    NCBKeychainService.removeDomainState()
    UserDefaults.standard.set(false, forKey: keyLoginTouchIDStatus+NCBShareManager.shared.getUserID())
    UserDefaults.standard.set(false, forKey: keyTransactionTouchIDStatus+NCBShareManager.shared.getUserID())
    UserDefaults.standard.synchronize()
}

func saveUUID() {
    if let _ = UserDefaults.standard.object(forKey: keyUUIDSaved) as? String {
        return
    }
    
    let uuid = "\(UIDevice.current.identifierForVendor?.uuidString ?? "")\(yyyyMMddHHmmss.string(from: Date()))"
    UserDefaults.standard.set(uuid, forKey: keyUUIDSaved)
    UserDefaults.standard.synchronize()
}

func getUUID() -> String {
    if let uuid = UserDefaults.standard.object(forKey: keyUUIDSaved) as? String {
        return uuid
    }
    
    return UIDevice.current.identifierForVendor?.uuidString ?? ""
}

func openAppstore() {
    if let url = URL(string: "itms-apps://itunes.apple.com/app/id1465217154"), UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.openURL(url)
    }
}
