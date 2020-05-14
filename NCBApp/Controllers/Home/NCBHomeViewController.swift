//
//  NCBHomeViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

class NCBHomeViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var heightCoverNavBackground: NSLayoutConstraint!
    @IBOutlet weak var bottomLogo: NSLayoutConstraint!
    @IBOutlet weak var containerSlideImageView: UIView!
    @IBOutlet weak var containerMenuIconView: UIView!

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var lbWelcome: UILabel!
    @IBOutlet weak var lbUserName: UILabel!
    
    //MARK: Properties
    
    var menuView: NCBHomeMenuIconView?
    fileprivate var pageControl = UIPageControl()
    fileprivate var listSavingFinalSettlementAccount: [NCBFinalSettlementSavingAccountModel] = []
    fileprivate var p: NCBSavingAccountPresenter?
    fileprivate var advPopups = [NCBBannerModel]()
    fileprivate var homeBanners = [NCBBannerModel]()
    fileprivate var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url  = NCBShareManager.shared.openURL {
            let mofinData = getTransferDataFromUrl(url)
            showTransferScreenFromMofin(mofinData)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        menuView?.reloadData()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    func createSavingFinalSettlementParams() -> [String : Any]{
        let param: [String : Any] = [
            "cifno" : NCBShareManager.shared.getUser()?.cif ?? ""
        ]
        return param
    }
    
}

extension NCBHomeViewController {

    override func setupView() {
        super.setupView()
        
        heightCoverNavBackground.constant = navHeight + 65
        bottomLogo.constant = hasTopNotch ? 25 : 15
        
        lbWelcome.font = regularFont(size: 18)
        lbWelcome.textColor = ColorName.blurNormalText.color
        
        lbUserName.font = semiboldFont(size: 18)
        lbUserName.textColor = ColorName.blurNormalText.color
        
        avatarImg.clipsToBounds = true
        avatarImg.contentMode = .scaleAspectFill
        
        avatarImg.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(changeAvatarAction))
        avatarImg.addGestureRecognizer(gesture)
        
        let slideImageView = NCBHomeSlideShowImageView(frame: .zero)
        containerSlideImageView.addSubview(slideImageView)
        
        let banners = getBanners()
        
        homeBanners = banners.filter({ $0.bannerCode == BannerCodeType.HOME_BANNER.rawValue })
        slideImageView.delegate = self
        slideImageView.reloadView(homeBanners, autoScroll: true)
        setupPageControl(homeBanners.count)
        
        slideImageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        menuView = R.nib.ncbHomeMenuIconView.firstView(owner: self)
        menuView!.delegate = self
        containerMenuIconView.addSubview(menuView!)
        
        menuView!.reloadData()
        
        menuView!.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        slideImageView.slideView.currentPageChanged = { [unowned self] index in
            self.pageControl.currentPage = index
        }
        
        advPopups = banners.filter({ $0.bannerCode == BannerCodeType.HOME_POPUP.rawValue })
        setupAdvPopup(advPopups)
        
        p = NCBSavingAccountPresenter()
        p?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        lbWelcome.text = "Xin chào,"
        lbUserName.text = NCBShareManager.shared.getUser()?.fullname?.uppercased()
        
        if !isChangeAvatar {
            let img = NCBShareManager.shared.getUser()?.getAvatar()
            avatarImg.image = img
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
    
    fileprivate func setupPageControl(_ numberOfPages: Int) {
        self.pageControl.numberOfPages = numberOfPages
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor(hexString: "02A9E9").withAlphaComponent(0.31)
        self.pageControl.currentPageIndicatorTintColor = UIColor(hexString: "02A9E9").withAlphaComponent(1.0)
        
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.centerX.equalToSuperview()
            make.top.equalTo(containerSlideImageView.snp_bottom).offset(5)
        }
    }
    
    fileprivate func showSavingProductsSheet() {
        var items = [BottomSheetDetailStringItem]()
        items.append(BottomSheetDetailStringItem(title: "Tiết kiệm thường/Tiền gửi có kỳ hạn", detail: "Lãi suất hấp dẫn cao hơn tiết kiệm truyền thống", isCheck: false))
        items.append(BottomSheetDetailStringItem(title: "Tiết kiệm tích luỹ ", detail: "Có thể nộp thêm tiền vài tào khoản tiết kiệm tích lũy bất cứ lúc nào", isCheck: false))
        if let vc = R.storyboard.sendSaving.ncbBottomSheetDetailListViewController() {
            vc.setData("Chọn sản phẩm tiết kiệm", items: items, isHasOptionItem: true)
            vc.delegate = self
            showBottomSheet(controller: vc, size: 330)
        }
    }
    
    @objc fileprivate func changeAvatarAction() {
        isChangeAvatar = true
        
        var items = [BottomSheetStringItem]()
        items.append(BottomSheetStringItem(title: "Chụp ảnh mới"))
        items.append(BottomSheetStringItem(title: "Chọn từ máy"))
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.setData("Thay ảnh đại diện", items: items, isHasOptionItem: false)
            vc.delegate = self
            showBottomSheet(controller: vc, size: 300)
        }
    }
    
}

extension NCBHomeViewController: NCBHomeSlideShowImageViewDelegate {
    
    func bannerDidSelectAt(_ index: Int) {
        if homeBanners.count == 0 {
            return
        }
        showActionForBannerPopup(homeBanners[index])
    }
    
}

extension NCBHomeViewController: NCBHomeMenuIconViewDelegate {
    
    func didSelectMenuItem(item: NCBMenuIconModel) {
        switch item.type {
        case IconType.accountInfo.rawValue:
            if let vc = R.storyboard.accountInfo.ncbGeneralAccountViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case IconType.transferInternal.rawValue:
            if let vc = R.storyboard.transfer.ncbInternalTransferViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case IconType.transfer247.rawValue:
            if let vc = R.storyboard.transfer.ncbInterbankTransferViewController() {
                vc.interbankType = .fast
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case IconType.charity.rawValue:
            if let vc = R.storyboard.transfer.ncbCharityTransferViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case IconType.transferInterbank.rawValue:
            if let vc = R.storyboard.transfer.ncbInterbankTransferViewController() {
                vc.interbankType = .normal
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case IconType.saving.rawValue:
            showSavingProductsSheet()
            /*
            if let vc = R.storyboard.savingAccount.ncbSavingProductViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }*/
        case IconType.settlementSaving.rawValue:
            SVProgressHUD.show()
            p?.getSavingFinalSettlementAccounts(params: createSavingFinalSettlementParams())
        case IconType.rechargeSaving.rawValue:
            if let vc = R.storyboard.saving.ncbAddSavingAmountViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case IconType.payTheBill.rawValue:
//            openTabFromIndex(MainTabIndex.pay.rawValue)
            if let vc = R.storyboard.main.ncbPayViewController() {
                vc.showBack = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case IconType.editFunction.rawValue:
            if let vc = R.storyboard.home.ncbSetupServiceViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case IconType.rechargePhone.rawValue:
            if let _vc = R.storyboard.chargeMoney.ncbChargeMoneyPhoneNumberViewController() {
                self.navigationController?.pushViewController(_vc, animated: true)
            }
        case IconType.wallet.rawValue:
            if let _vc = R.storyboard.chargeMoney.ncbChargeAirpayViewController() {
                self.navigationController?.pushViewController(_vc, animated: true)
            }
        case IconType.creditPayment.rawValue:
            if let vc = R.storyboard.creditCard.ncbCreditCardPaymentViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case IconType.net.rawValue:
            showNet()
        case IconType.support.rawValue:
            if let vc = R.storyboard.customerSupport.ncbCustomerSupportHomeViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case IconType.contact.rawValue:
            showContact()
        case IconType.searchTransaction.rawValue:
            if let vc = R.storyboard.home.ncbSearchTransactionViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
}

extension NCBHomeViewController: NCBBottomSheetDetailListViewControllerDelegate {
    
    func bottomSheetDetailListDidSelectItem(_ item: String, index: Int) {
        removeBottomSheet()
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

extension NCBHomeViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        removeBottomSheet()
        
        switch index {
        case 0:
            imagePicker.delegate = self
            showPhotoSource(imagePicker, sourceType: .camera)
        case 1:
            imagePicker.delegate = self
            showPhotoSource(imagePicker, sourceType: .savedPhotosAlbum)
        default:
            break
        }
    }
    
}

extension NCBHomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        let img = image.resizeImage(targetSize: CGSize(width: 500, height: 500))
        avatarImg.image = img
        uploadProfileImage(image: img)
    }
    
}

extension NCBHomeViewController: NCBSavingAccountPresenterDelegate {
    
    func getSavingFinalSettlementAccountsCompleted(savingAccounts: [NCBFinalSettlementSavingAccountModel]?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
            return
        }
        
        if let savingAccounts = savingAccounts, savingAccounts.count > 0 {
            listSavingFinalSettlementAccount = savingAccounts
            if let controller = R.storyboard.bottomSheet.ncbListSavingFinalSettlementAccountViewController() {
                showBottomSheet(controller: controller, size: view.frame.height * 2 / 3)
                controller.setupData(listSavingFinalSettlementAccount)
            }
        } else {
            showAlert(msg: "Quý khách không có tài khoản tiết kiệm có thể tất toán trực tuyến. Vui lòng kiểm tra lại")
        }
    }
    
}
