//
//  NCBMainLoginViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import LocalAuthentication
import ObjectMapper
import SwiftyAttributes

enum ActiveCase: String {
    case yes = "Y"
    case no = "N"
    case active = "A"
}

enum ChangePassCase: String {
    case yes = "Y"
    case no = "N"
}

class NCBMainLoginViewController: NCBBaseViewController, FloatyDelegate {
    

    // MARK: - Outlets
    @IBOutlet weak var userNameTxtF: NCBLoginTextField!{
        didSet{
            userNameTxtF.addLeftView(with: R.image.ic_user())
        }
    }
    @IBOutlet weak var passwordTxtF: NCBLoginTextField!{
        didSet{
            passwordTxtF.addLeftView(with: R.image.ic_password())
            passwordTxtF.addRightButton()
        }
    }
    @IBOutlet weak var loginBtn: UIButton!{
        didSet {
            loginBtn.titleLabel?.font = displayBoldFont(size: 14)
            loginBtn.drawGradient(startColor: UIColor(hexString: "00C0F7"), endColor: UIColor(hexString: "008CEC"))
        }
    }
    @IBOutlet weak var biometricsBtn: UIButton!
    @IBOutlet weak var biometricsLbl: UILabel!{
        didSet {
            biometricsLbl.textColor = UIColor.white
            biometricsLbl.textAlignment = .center
        }
    }
    
    @IBOutlet weak var viButton: UIButton!
    @IBOutlet weak var enButton: UIButton!
    
    // MARK: - Properties
    
    fileprivate let touchMe = BiometricIDAuth()
    fileprivate var p: NCBMainLoginPresenter?
    
    var floatMenu = Floaty()
    var isFirstStart = true
    var isShowedPopup = false
    fileprivate var advPopups = [NCBBannerModel]()
    fileprivate var versionInfo: NCBCheckVersionUpdateModel?
    fileprivate var warningView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        if !isShowedPopup {
            setupAdvPopup()
        }
        isShowedPopup = true
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        loginBtn.setTitle(localized("login.button.text"), for: .normal)
        userNameTxtF.placeholderString = localized("login.username.text")
        passwordTxtF.placeholderString = localized("login.password.text")
        let attributedText = "Đăng nhập bằng ".withFont(italicFont(size: 12)!) + BiometricIDAuth().biometricSuffix.withFont(boldItalicFont(size:12)!)
        biometricsLbl.attributedText = attributedText
    }
    
    // MARK: - Actions
    
    @IBAction func onEN(_ sender: Any) {
        NCBLocalization.shared().setLanguage("en")
        loadLocalized()
        viButton.titleLabel?.font = lightFont(size: 12)
        enButton.titleLabel?.font = boldFont(size: 12)
    }
    
    @IBAction func onVI(_ sender: Any) {
        NCBLocalization.shared().setLanguage("vi")
        loadLocalized()
        viButton.titleLabel?.font = boldFont(size: 12)
        enButton.titleLabel?.font = lightFont(size: 12)
    }
    
    @IBAction func login(_ sender: Any) {
        view.endEditing(true)
        if userNameTxtF.text == ""{
            showAlert(msg: "NCBLOGIN-1".getMessage() ?? localized("dialog.enter.username.message"))
            return
        }
        if passwordTxtF.text == ""{
            showAlert(msg: "NCBLOGIN-2".getMessage() ?? localized("dialog.enter.password.message"))
            return
        }
        
        let params = [
            "grant_type": "password",
            "username": userNameTxtF.text!,
            "password": passwordTxtF.text!,
            "deviceid" : getUUID(),
            "osversion" : UIDevice.current.systemVersion,
            "osname": "IOS"
            ] as [String: Any]
        
        SVProgressHUD.show()
        p?.userLogin(params: params)
    }
    
    @IBAction func biometricsLogin(_ sender: Any) {
        if !checkBioAvailable(touchMe, isOpen: isOpenLoginTouchID, forLogin: true) {
            return
        }
        
        touchMe.evaluate { [unowned self] (error, msg) in
            if error == biometricSuccessCode {
                self.loginWithTouchID()
            } else {
                if let msg = msg {
                    self.showAlert(msg: msg)
                }
            }
        }
    }
    
}



extension NCBMainLoginViewController{
    
    override func setupView() {
        super.setupView()
        
        setupLoginBackground()
        
        setupMenu()
        setupTouchButton()
        showBiometricWarning()
        
        let langCode = NCBLocalization.shared().getLangCode()
        if langCode.hasPrefix("vi") {
            viButton.titleLabel?.font = boldFont(size: 12)
            enButton.titleLabel?.font = lightFont(size: 12)
        }else {
            viButton.titleLabel?.font = lightFont(size: 12)
            enButton.titleLabel?.font = boldFont(size: 12)
        }
        
        p = NCBMainLoginPresenter()
        p?.delegate = self
        
        userNameTxtF.text = NCBShareManager.shared.getUserID()
        
        biometricsLbl.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(biometricsLogin(_:)))
        biometricsLbl.addGestureRecognizer(gesture)
    }
    
    override func appMovedToForeground() {
        warningView.isHidden = !touchMe.checkBioStateChanged()
    }
    
    fileprivate func setupTouchButton() {
        biometricsBtn.isHidden = (touchMe.biometricType() == .none)
        switch touchMe.biometricType() {
        case .faceID:
            biometricsBtn.setImage(R.image.ic_faceid(),  for: .normal)
        default:
            biometricsBtn.setImage(R.image.ic_touchid(),  for: .normal)
        }
        
//        if !biometricsBtn.isHidden && isOpenLoginTouchID && isFirstStart {
//            biometricsLogin(biometricsBtn!)
//        }
    }
    
    fileprivate func showTouchIDLoginPopup() {
        if !biometricsBtn.isHidden && isOpenLoginTouchID && isFirstStart {
            biometricsLogin(biometricsBtn!)
        }
    }
    
    fileprivate func showBiometricWarning() {
        warningView.clipsToBounds = true
        warningView.layer.cornerRadius = 5
        view.addSubview(warningView)
        
        warningView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalTo(biometricsLbl.snp.bottom).offset(30)
        }
        
        let content = UIView()
        content.backgroundColor = UIColor.black
        content.alpha = 0.2
        warningView.addSubview(content)
        
        content.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        let lbMsg = UILabel()
        lbMsg.text = touchMe.biometricType() == .faceID ? "FACEID-4".getMessage() : "TOUCHID-2".getMessage()
        lbMsg.font = regularFont(size: 12)
        lbMsg.textColor = UIColor.white
        lbMsg.textAlignment = .center
        lbMsg.numberOfLines = 0
        warningView.addSubview(lbMsg)
        
        lbMsg.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        warningView.isHidden = !touchMe.checkBioStateChanged()
    }
    
    func loginWithTouchID() {
        let params = [
            "grant_type": "password",
            "username": (touchMe.biometricType() == .touchID) ? StringConstant.loginByTouchID : StringConstant.loginByFaceID,
            "password": NCBKeychainService.loadLoginTouchID() ?? "",
            ] as [String: Any]
        
        SVProgressHUD.show()
        p?.userLogin(params: params)
    }
    
    func setupMenu() {
        floatMenu.removeFromSuperview()
        floatMenu = Floaty()
        
        floatMenu.hasShadow = false
        floatMenu.fabDelegate = self
        floatMenu.size = 42
        floatMenu.buttonImage = UIImage(named: "ic_login.pdf")
        floatMenu.buttonImageFocus = UIImage(named: "ic_login_focus.pdf")
        floatMenu.sticky = false
        
        let dichVuItem = FloatyItem()
        dichVuItem.hasShadow = false
        //dichVuItem.icon = UIImage(named: "ic_registerNewService_1")
        dichVuItem.icon = UIImage(named: "ic_registerNewService")
        dichVuItem.imageSize = CGSize(width: 42, height: 42)
        dichVuItem.itemBackgroundColor = UIColor.clear
        //dichVuItem.backgroundColor = UIColor.init(red: 0, green: 189/255, blue: 252/255, alpha: 0.7)
        dichVuItem.title = localized("login.menu.register.service")
        dichVuItem.titleLabel.font = regularFont(size: 14)
        dichVuItem.titleLabel.textAlignment = .right
        
        dichVuItem.handler = { dichVuItem in
            self.floatMenu.close()
            self.showServiceRegister()
        }
        floatMenu.addItem(item: dichVuItem)
        
        let lienHeItem = FloatyItem()
        lienHeItem.hasShadow = false
        lienHeItem.icon = UIImage(named: "ic_contact")
        lienHeItem.imageSize = CGSize(width: 42, height: 42)
        // item.backgroundColor = UIColor.init(red: 0, green: 189/255, blue: 252/255, alpha: 1)
        lienHeItem.title = localized("login.menu.contact")
        lienHeItem.titleLabel.font = regularFont(size: 14)
        lienHeItem.titleLabel.textAlignment = .right
        
        lienHeItem.handler = { lienHeItem in
            self.floatMenu.close()
            self.showContact()
        }
        floatMenu.addItem(item: lienHeItem)
        
        let hoTroItem = FloatyItem()
        hoTroItem.hasShadow = false
        hoTroItem.icon = UIImage(named: "ic_support")
        hoTroItem.imageSize = CGSize(width: 42, height: 42)
        // item.backgroundColor = UIColor.init(red: 0, green: 189/255, blue: 252/255, alpha: 1)
        hoTroItem.title = localized("login.menu.support")
        hoTroItem.titleLabel.font = regularFont(size: 14)
        hoTroItem.titleLabel.textAlignment = .right
        hoTroItem.handler = { hoTroItem in
            self.floatMenu.close()
            self.showSupport()
        }
        floatMenu.addItem(item: hoTroItem)
        
        let mangLuoiItem = FloatyItem()
        mangLuoiItem.hasShadow = false
        mangLuoiItem.icon = UIImage(named: "ic_network")
        mangLuoiItem.imageSize = CGSize(width: 42, height: 42)
        // item.backgroundColor = UIColor.init(red: 0, green: 189/255, blue: 252/255, alpha: 1)
        mangLuoiItem.title = localized("login.menu.network")
        mangLuoiItem.titleLabel.font = regularFont(size: 14)
        mangLuoiItem.titleLabel.textAlignment = .right
        mangLuoiItem.handler = { mangLuoiItem in
            self.floatMenu.close()
            self.showNet()
        }
        floatMenu.addItem(item: mangLuoiItem)
    
        view.addSubview(floatMenu)
    }
    
    func setupAdvPopup() {
        if !isFirstStart {
            return
        }
        
        advPopups = getBanners().filter({ $0.bannerCode == BannerCodeType.LOGIN_POPUP.rawValue })
        
        var hasPopup = false
        for popup in advPopups {
            if !getPopupShowedList().contains(where: { $0.id == popup.id }) {
                hasPopup = true
                break
            }
        }
        if hasPopup {
            setupAdvPopup(advPopups)
        } else {
            showTouchIDLoginPopup()
        }
    }
    
    override func advPopupDidSelect(_ sender: UITapGestureRecognizer) {
        super.advPopupDidSelect(sender)
        
        guard let slideView = sender.view as? NCBHomeSlideShowImageView else {
            return
        }
        
        let page = slideView.slideView.currentPage
        let item = advPopups[page]
        showActionForBannerPopup(item)
    }
    
    override func advPopupClose() {
        super.advPopupClose()
        
        showTouchIDLoginPopup()
    }
    
}

extension NCBMainLoginViewController: NCBMainLoginPresenterDelegate {
    
    func loginCompleted(error: String?) {
        if let error = error {
            SVProgressHUD.dismiss()
            showAlert(msg: error)
            return
        }
        
//        p?.userGetProfile()
        p?.needUpdatePass()
    }
    
    
    func getProfileCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        guard let userInfo = NCBShareManager.shared.getUser() else {
            return
        }
        
        removeAllNotification()
        
        if userInfo.newStart == nil || userInfo.newStart == ActiveCase.no.rawValue {
            gotoAuthenticateLogin()
            return
        }
        
        if userInfo.chpass == nil || userInfo.chpass == ChangePassCase.no.rawValue {
            gotoChangePassword()
            return
        }
        
        if userInfo.onLoggedOtherDevice {
            gotoAuthenticateLoginOtherDevice()
            return
        }
        
        UserDefaults.standard.setValue(true, forKey: "DidLogin")
        NCBShareManager.shared.setUserID(userNameTxtF.text ?? "")
        gotoMain()
    }
    
    func needUpdatePass(error: String?) {
        if error != nil {
            p?.userGetProfile()
            return
        }
        SVProgressHUD.dismiss()
        showError(msg: "NCBLOGIN-7".getMessage() ?? "Mật khẩu của quý khách đã hết hạn. Vui lòng đổi mật khẩu để tiếp tục sử dụng dịch vụ", confirmTitle: "Đổi mật khẩu") {
            if let vc = R.storyboard.setting.ncbSettingsChangePasswordViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: - Floaty Delegate Methods
    
    func floatyWillOpen(_ floaty: Floaty) {
        print("Floaty Will Open")
   
    }
    func floatyDidOpen(_ floaty: Floaty) {
        print("Floaty Did Open")
 
    }
    
    
    func floatyWillClose(_ floaty: Floaty) {
        print("Floaty Will Close")
    }
    
    func floatyDidClose(_ floaty: Floaty) {
        print("Floaty Did Close")
        
    }

}


