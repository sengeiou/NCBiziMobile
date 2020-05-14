//
//  NCBBaseViewController.swift
//  NCBApp
//
//  Created by Thuan on 3/31/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit
import Kingfisher
import Malert

fileprivate let popupViewTag = 131412

class NCBBaseViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var commonCreditCardInfoView: NCBCreditCardInfoView?
    @IBOutlet weak var imgBackgroundLogin: UIImageView?
    
    //MARK: Properties
    
    fileprivate var navigationBarBackground: UIImageView?
    fileprivate var pageControl: UIPageControl?
    fileprivate var containerAdvPopupView: UIView?
    fileprivate var slideAdvImageView: NCBHomeSlideShowImageView?
    var isChangeAvatar = false
    fileprivate var imageName: String?
    fileprivate var imageData: String?
    fileprivate var menuPresenter: NCBMenuPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuPresenter = NCBMenuPresenter()
        menuPresenter?.delegate = self
        
        setupView()
        addNavigationBackIcon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadLocalized()
        navigationBarBackground?.removeFromSuperview()
        
        if showNavigationBarBackground() {
            navigationBarBackground = UIImageView()
            navigationBarBackground!.contentMode = .scaleToFill
            navigationBarBackground!.image = R.image.cover_nav_background()
            view.addSubview(navigationBarBackground!)
            
            navigationBarBackground!.snp.makeConstraints { (make) in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(navHeight + 65)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(clearAllChildControllers), name: NSNotification.Name(rawValue: keyMainTabIndexChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openFunctionFromURLScheme(_:)), name: NSNotification.Name(rawValue: keyOpenFromURLScheme), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension NCBBaseViewController {
    
    @objc func setupView() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(hasTopNotch ? 3 : 10, for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: semiboldFont(size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }
    
    @objc func loadLocalized() {
        
    }
    
    @objc func backAction(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func appMovedToForeground() {
        if let _ =  NCBShareManager.shared.getUser() {
            if BiometricIDAuth().checkBioStateChanged() {
                showAlert(msg: BiometricIDAuth().biometricType() == .faceID ? "Chức năng Đăng nhập/Xác thực bằng FaceID đã bị ngừng do có sự thay đổi FaceID trên thiết bị. Quý khách vui lòng kích hoạt lại chức năng này trong phần cài đặt ứng dụng." : "Chức năng Đăng nhập/Xác thực bằng vân tay đã bị ngừng do có sự thay đổi vân tay trên thiết bị. Quý khách vui lòng kích hoạt lại chức năng này trong phần cài đặt ứng dụng.")
            }
        }
    }
    
    @objc func clearAllChildControllers() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @objc func showNavigationBarBackground() -> Bool {
        return false
    }
    
    @objc func openFunctionFromURLScheme(_ notification: Notification) {
        containerAdvPopupView?.removeFromSuperview()
        
        let url = notification.object as? String
        if let _ = NCBShareManager.shared.getUser() {
            let mofinData = getTransferDataFromUrl(url)
            showTransferScreenFromMofin(mofinData)
        } else {
            NCBShareManager.shared.openURL = url
            if let vc = R.storyboard.login.ncbMainLoginViewController() {
                let nav = UINavigationController(rootViewController: vc)
                appDelegate.window!.rootViewController = nav
                
            }
        }
    }
    
}

extension NCBBaseViewController {
    
    func removeAllNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func openTabFromIndex(_ index: Int) {
        self.tabBarController?.selectedIndex = index
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: keyMainTabIndexChanged), object: nil)
    }
    
    func setHeaderTitle(_ title: String) {
        navigationItem.title = title.firstUppercased
    }
    
    func setCustomHeaderTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func addNavigationBackIcon() {
        let customButton = UIButton(type: .custom)
        customButton.translatesAutoresizingMaskIntoConstraints = false
        customButton.setImage(R.image.ic_nav_back(), for: .normal)
        customButton.contentEdgeInsets = UIEdgeInsets(top: hasTopNotch ? 10 : 25, left: 0, bottom: 0, right: 15)
        customButton.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        let leftNavItem = UIBarButtonItem(customView: customButton)
        leftNavItem.title = ""
        navigationItem.leftBarButtonItem = leftNavItem
    }
    
    func gotoMain() {
        self.view.endEditing(true)
        let mainTabVC = NCBBaseTabBarController()
        appDelegate.window!.rootViewController = mainTabVC
    }
    
    func gotoAuthenticateLoginOtherDevice() {
        self.view.endEditing(true)
        if let vc = R.storyboard.login.ncbAuthenticateLoginOtherDeviceViewController() {
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func gotoChangePassword() {
        self.view.endEditing(true)
        if let vc = R.storyboard.login.ncbChangePasswordViewController() {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func gotoAuthenticateLogin() {
        self.view.endEditing(true)
        if let vc = R.storyboard.login.ncbAuthenticateViewController() {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func gotoSpecificallyController(_ vc: AnyClass) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: vc) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func showTransferScreenFromMofin(_ mofinData: MofinTransferDataModel?) {
        if mofinData?.bankcode == StringConstant.ncbCode {
            if let vc = R.storyboard.transfer.ncbInternalTransferViewController() {
                vc.mofinTransferData = mofinData
                self.navigationController?.pushViewController(vc, animated: false)
            }
        } else {
            if let vc = R.storyboard.transfer.ncbInterbankTransferViewController() {
                vc.mofinTransferData = mofinData
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    func changeTabBar(hidden: Bool) {
        guard let tabbarVC = self.tabBarController else {
            return
        }
        
        var rect = self.view.frame
        if !tabbarVC.tabBar.isHidden && hidden {
            rect.size.height += 50
        } else if tabbarVC.tabBar.isHidden && !hidden {
            rect.size.height -= 50
        }
        self.view.frame = rect
        tabbarVC.tabBar.isHidden = hidden
    }
    
    func showPhotoSource(_ imagePicker: UIImagePickerController, sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showBottomSheet(controller: UIViewController, size: CGFloat, disablePanGesture: Bool? = false, dismissOnBackgroundTap: Bool? = true) {
        self.view.endEditing(true)
        changeTabBar(hidden: true)
        
        let sheetController = SheetViewController(controller: controller, sizes: [SheetSize.fixed(size)])
        NCBShareManager.shared.sheets.append(sheetController)
        
        sheetController.dismissOnBackgroundTap = (disablePanGesture == true) ? false : (dismissOnBackgroundTap ?? false)
        sheetController.topCornersRadius = 40
        sheetController.overlayColor = UIColor.clear
        sheetController.extendBackgroundBehindHandle = true
        sheetController.disablePanGesture = disablePanGesture ?? false
        
        sheetController.willDismiss = { [unowned self] _ in
            self.removeBottomSheet()
        }
        
        sheetController.willDisappear = { [unowned self] _ in
            NCBShareManager.shared.sheets.removeLast()
            if NCBShareManager.shared.sheets.count == 0 {
                self.changeTabBar(hidden: false)
            }
        }
        
        self.addChild(sheetController)
        sheetController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(sheetController.view)
        sheetController.didMove(toParent: self)
        sheetController.view.addShadow(location: .top)
    }
    
    func showPopupView(sourceView: UIView, size: CGFloat) {
        let existView = self.view.subviews.first(where: { $0.tag == popupViewTag })
        if let _ = existView {
            return
        }
        
        sourceView.frame = CGRect(x: 15, y: self.view.frame.height/2 - size/2, width: self.view.frame.width - 30, height: size)
        sourceView.layer.cornerRadius = 19
        sourceView.addShadow(offset: CGSize(width: 0, height: 0), color: UIColor.black, opacity: 0.13, radius: 6)
        sourceView.tag = popupViewTag
        self.view.addSubview(sourceView)
    }
    
    func closeBottomSheet() {
        if let controller = NCBShareManager.shared.sheets.last {
            controller.closeSheet()
        }
    }
    
    func removeBottomSheet() {
        if let controller = NCBShareManager.shared.sheets.last {
            controller.view.removeFromSuperview()
            controller.removeFromParent()
        }
    }
    
    func setupLoginBackground() {
        if let urlImg = UserDefaults.standard.value(forKey: "Flash") as? String {
            imgBackgroundLogin?.kf.setImage(with: URL(string: urlImg.replacingSpace), placeholder: R.image.splash_bg())
        }
    }
    
    func setupAdvPopup(_ popups: [NCBBannerModel]) {
        var popupModels = [NCBBannerModel]()
        
        for popup in popups {
            if !getPopupShowedList().contains(where: { $0.id == popup.id && popup.oneTimeShow == true }) {
                popupModels.append(popup)
            }
        }
        
        if popupModels.count > 0 {
            containerAdvPopupView = UIView()
            containerAdvPopupView!.isUserInteractionEnabled = true
            appDelegate.window!.addSubview(containerAdvPopupView!)
            
            containerAdvPopupView!.snp.makeConstraints { (make) in
                make.leading.top.equalToSuperview()
                make.width.height.equalToSuperview()
            }
            
            let bgView = UIView()
            bgView.backgroundColor = UIColor.black
            bgView.alpha = 0.3
            containerAdvPopupView?.addSubview(bgView)
            
            bgView.snp.makeConstraints { (make) in
                make.leading.top.equalToSuperview()
                make.width.height.equalToSuperview()
            }
            
            let contentView = UIView()
            contentView.backgroundColor = .white
            contentView.layer.cornerRadius = 19
            contentView.clipsToBounds = true
            containerAdvPopupView!.addSubview(contentView)
            
            contentView.snp.makeConstraints {(make) in
                make.centerX.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(28)
                make.height.equalTo(contentView.snp_width).multipliedBy(1.58)
            }
            slideAdvImageView = NCBHomeSlideShowImageView(frame: .zero)
            contentView.addSubview(slideAdvImageView!)
            slideAdvImageView!.reloadView(popupModels, autoScroll: false)
            slideAdvImageView!.snp.makeConstraints { (make) in
                make.leading.top.equalToSuperview()
                make.width.height.equalToSuperview()
            }
            
            slideAdvImageView!.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(advPopupDidSelect(_:)))
            slideAdvImageView?.addGestureRecognizer(gesture)
            
            pageControl = UIPageControl()
            contentView.addSubview(pageControl!)
            
            pageControl!.snp.makeConstraints { (make) in
                make.height.equalTo(15)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(contentView.snp_bottom).offset(-16)
            }
//            setupPageControl(popupModels.count)
            slideAdvImageView!.slideView.currentPageChanged = { [unowned self] index in
                self.pageControl!.currentPage = index
            }
            let btnHeader = UIButton()
            btnHeader.setImage(R.image.ic_close_adv_banner(), for: .normal)
            btnHeader.addTarget(self, action: #selector(advPopupClose), for: .touchUpInside)
            contentView.addSubview(btnHeader)
            btnHeader.snp.makeConstraints { (make) in
                make.top.equalTo(contentView.snp_top).offset(10)
                make.trailing.equalTo(contentView.snp_trailing).offset(-10)
            }
        }
        
    }
    
    @objc func advPopupClose() {
        containerAdvPopupView?.removeFromSuperview()
    }
    
    @objc func advPopupDidSelect(_ sender: UITapGestureRecognizer) {
        if let _ = NCBShareManager.shared.getUser() {
            containerAdvPopupView?.removeFromSuperview()
        }
    }
    
    func showActionForBannerPopup(_ item: NCBBannerModel) {
        if NCBShareManager.shared.getUser() == nil {
            if let action = item.action, let url = URL(string: action), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
            return
        }
        
        switch item.action {
        case BannerActionType.URT.rawValue:
            if let vc = R.storyboard.transfer.ncbInternalTransferViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case BannerActionType.IBT.rawValue:
            if let vc = R.storyboard.transfer.ncbInterbankTransferViewController() {
                vc.interbankType = .normal
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case BannerActionType.ISL.rawValue:
            if let vc = R.storyboard.transfer.ncbInterbankTransferViewController() {
                vc.interbankType = .fast
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case BannerActionType.BILL.rawValue:
            if let vc = R.storyboard.main.ncbPayViewController() {
                vc.showBack = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case BannerActionType.OPEN.rawValue:
            var items = [BottomSheetDetailStringItem]()
            items.append(BottomSheetDetailStringItem(title: "Tiết kiệm thường/Tiền gửi có kỳ hạn", detail: "Lãi suất hấp dẫn cao hơn tiết kiệm truyền thống", isCheck: false))
            items.append(BottomSheetDetailStringItem(title: "Tiết kiệm tích luỹ ", detail: "Có thể nộp thêm tiền vài tào khoản tiết kiệm tích lũy bất cứ lúc nào", isCheck: false))
            if let vc = R.storyboard.sendSaving.ncbBottomSheetDetailListViewController() {
                vc.setData("Chọn sản phẩm tiết kiệm", items: items, isHasOptionItem: true)
                showBottomSheet(controller: vc, size: 330)
                
                vc.itemDidSelect = { [unowned self] item, index in
                    self.removeBottomSheet()
                    if index  == 0 {
                        if let vc = R.storyboard.sendSaving.ncbiSavingsViewController() {
                            vc.savingFormType = .ISavingSaving
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        if let vc = R.storyboard.sendSaving.ncbiSavingsViewController() {
                            vc.savingFormType = .AccumulateSaving
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        case BannerActionType.SERVICE.rawValue:
            var items = [BottomSheetStringItem]()
            items.append(BottomSheetStringItem(title: "Đăng ký tài khoản mới", isCheck: false))
            items.append(BottomSheetStringItem(title: "Đăng ký phát hành thẻ", isCheck: false))
            items.append(BottomSheetStringItem(title: "Đăng ký SMS Banking", isCheck: false))
            if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                vc.setData("Đăng ký dịch vụ mới", items: items, isHasOptionItem: true)
                showBottomSheet(controller: vc, size: 330)
                
                vc.itemDidSelect = { [unowned self] item, index in
                    self.removeBottomSheet()
                    switch index {
                    case 0:
                        if let vc = R.storyboard.registerNewAcct.ncbRegisterNewAccountViewController() {
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    case 1:
                        var items = [BottomSheetStringItem]()
                        items.append(BottomSheetStringItem(title: "Phát hành mới thẻ ATM", isCheck: false))
                        items.append(BottomSheetStringItem(title: "Phát hành mới thẻ tín dụng", isCheck: false))
                        items.append(BottomSheetStringItem(title: "Phát hành lại", isCheck: false))
                        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                            vc.setData("Đăng ký phát hành thẻ", items: items, isHasOptionItem: true)
                            self.showBottomSheet(controller: vc, size: 330)
                            
                            vc.itemDidSelect = { [unowned self] item, index in
                                self.removeBottomSheet()
                                switch index {
                                case 0:
                                    if let vc = R.storyboard.cardService.ncbRegistrationATMViewController() {
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                case 1:
                                    if let vc = R.storyboard.cardService.ncbRegistrationCreditCardViewController() {
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                case 2:
                                    if let vc = R.storyboard.cardService.ncbCardReissueViewController() {
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                default:
                                    break
                                }
                            }
                        }
                        break
                    case 2:
                        if let vc = R.storyboard.registerSMSBanking.ncbRegisterSMSBankingViewController(){
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    default:
                        break
                    }
                }
            }
        case BannerActionType.TOP.rawValue:
            if let _vc = R.storyboard.chargeMoney.ncbChargeMoneyPhoneNumberViewController() {
                self.navigationController?.pushViewController(_vc, animated: true)
            }
        case BannerActionType.EWL.rawValue:
            if let _vc = R.storyboard.chargeMoney.ncbChargeAirpayViewController() {
                self.navigationController?.pushViewController(_vc, animated: true)
            }
        default:
            if let action = item.action, let url = URL(string: action), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
//    fileprivate func setupPageControl(_ numberOfPages: Int) {
//        guard let pageControl = pageControl else {
//            return
//        }
//        
//        pageControl.numberOfPages = numberOfPages
//        pageControl.currentPage = 0
//        pageControl.tintColor = UIColor.red
//        pageControl.pageIndicatorTintColor = UIColor(hexString: "02A9E9").withAlphaComponent(0.31)
//        pageControl.currentPageIndicatorTintColor = UIColor(hexString: "02A9E9").withAlphaComponent(1.0)
//    }
    
    func uploadProfileImage(image: UIImage) {
        imageData = image.toBase64()
        let date = Date()
        let formatter = yyyyMMddHHmmss
        let result = formatter.string(from: date)
        imageName = "avatar"+result+".jpg"
        
        var params: [String: Any] = [:]
        params["username"] = NCBShareManager.shared.getUser()?.username
        params["imgname"] = imageName
        params["imgdata"] = imageData
        params["isupdate"] = true
        
        SVProgressHUD.show()
        menuPresenter?.updateProfileAvatar(params: params)
    }
    
    func userLogout() {
//        SVProgressHUD.show()
        menuPresenter?.logout()
        doLogout()
    }
    
    func checkBioAvailable(_ touchMe: BiometricIDAuth, isOpen: Bool, forLogin: Bool? = false) -> Bool {
        if touchMe.checkBioNotEnrolled() {
            showAlert(msg: touchMe.biometricType() == .faceID ? "LOGIN_FACEID-1".getMessage() ?? "" : "LOGIN_TOUCHID-1".getMessage() ?? "")
            return false
        }
        
        if !isOpen {
            
            var titleStr = ""
            
            if forLogin ?? true {
                switch touchMe.biometricType() {
                case .faceID:
                    titleStr = "LOGIN_FACEID-2".getMessage() ?? ""
                case .touchID:
                    titleStr = "LOGIN_TOUCHID-2".getMessage() ?? ""
                default:
                    break
                }
            } else {
                titleStr = "Vui lòng kích hoạt xác nhận giao dịch bằng \(touchMe.biometricSuffix) tại phần cài đặt trong ứng dụng"
            }
            
            showAlert(msg: titleStr)
            return false
        }
        
        return true
    }
    
}

//Show from login menu

extension NCBBaseViewController {
    
    func showNet() {
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(NCBNetViewController(), animated: true)
    }
    
    func showSupport() {
        if let vc = R.storyboard.customerSupport.ncbCustomerSupportHomeViewController() {
            vc.hiddenCustomerInfo = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showServiceRegister() {
        if let vc = R.storyboard.registerNewService.instantiateInitialViewController() {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showContact() {
        showConfirm(msg: "Quý khách muốn kết nối cuộc gọi với tổng đài CSKH NCB?") {
            let telStr = getHotLine()
            guard let url = URL(string: "tel://" + telStr) else { return }
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
}

extension NCBBaseViewController: NCBMenuPresenterDelegate {
    
    func updateProfileAvatar(success: String?, error: String?) {
        isChangeAvatar = false
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        let user = NCBShareManager.shared.getUser()
        if let name = imageName {
            user?.setImgName(name: name)
        }
        if let base64 = imageData {
            user?.setImgData(base64Str: base64)
        }
    }
    
//    func logoutCompleted(error: String?) {
//        SVProgressHUD.dismiss()
//        if let error = error {
//            showAlert(msg: error)
//            return
//        }
//        
//        doLogout()
//    }
    
}
