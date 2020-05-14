//
//  CardServiceControllerView.swift
//  NCBApp
//
//  Created by ADMIN on 7/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import UIKit
import UPCarouselFlowLayout
import ImageSlideshow
import ObjectMapper
import SnapKit

fileprivate let sizeItemWidth = (appDelegate.window!.frame.size.width - 30)/3

class NCBCardServiceViewController: NCBBaseViewController {
    
    fileprivate var currentPage: Int = 0 {
        didSet {
            //let card = self.listCard[self.currentPage]
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.cardsCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    fileprivate var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
 
    @IBOutlet weak var cardsCollectionView: UICollectionView! {
        didSet {
            cardsCollectionView.register(UINib(nibName: R.nib.ncbCardCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.ncbCardCollectionViewCellID.identifier)
            cardsCollectionView.delegate = self
            cardsCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var heightCardsClvConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuCollectionView: UICollectionView! {
        didSet {
            menuCollectionView.register(UINib(nibName: R.nib.ncbHomeMenuIconCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier)
            menuCollectionView.delegate = self
            menuCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var containerSlideImageView: UIView!
    
    fileprivate var menuDataModels: [NCBCardServiceMenuIconModel] = []
    fileprivate var listCard: [NCBCardModel] = []
    var isExpandSavingAccountCell: Bool = false
    var presenter: NCBCardServicePresenter?
    fileprivate var pageControl = UIPageControl()
    fileprivate var cardBanners = [NCBBannerModel]()
    fileprivate var cardType = CreditCardType.VD.rawValue

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    fileprivate func setupLayout() {
        let layout = self.cardsCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 50)
    }
    
    fileprivate func getDataModel() {
        var item = NCBCardServiceMenuIconModel()
        item.title = "Thanh toán thẻ"
        item.image = "ic_cardService_cardPayment"
        item.type = .cardPayment
        menuDataModels.append(item)
        
        item = NCBCardServiceMenuIconModel()
        item.title = "Thanh toán trực tuyến"
        item.image = "ic_cardService_onlinePayment"
        item.type = .onlinePayment
        menuDataModels.append(item)
        
        item = NCBCardServiceMenuIconModel()
        item.title = "Mở khoá/Kích hoạt thẻ"
        item.image = "ic_cardService_openLockActivateCard"
        item.type = .openLockActivateCard
        menuDataModels.append(item)
        
        item = NCBCardServiceMenuIconModel()
        item.title = "Trích nợ tự động"
        item.image = "ic_cardService_autoDebtDeduction"
        item.type = .autoDebtDeduction
        menuDataModels.append(item)
        
        item = NCBCardServiceMenuIconModel()
        item.title = "Đăng ký phát hành thẻ"
        item.image = "ic_cardService_registrationCard"
        item.type = .registrationCard
        menuDataModels.append(item)
        
        item = NCBCardServiceMenuIconModel()
        item.title = "Cấp lại PIN thẻ"
        item.image = "ic_cardService_re-supplyPIN"
        item.type = .resupplyPIN
        menuDataModels.append(item)
    }
    
    fileprivate func getCrdList() {
        var params: [String: Any] = [:]
        params["cifno"] = NCBShareManager.shared.getUser()!.cif
        params["userId"] = NCBShareManager.shared.getUser()!.username
        params["cardType"] = cardType
        
        if cardType == CreditCardType.VD.rawValue {
            SVProgressHUD.show()
        }
        presenter?.getServiceList(params: params)
    }
    
}

extension NCBCardServiceViewController {
    override func setupView() {
        super.setupView()
        
        setHeaderTitle("Dịch vụ thẻ")
        heightCardsClvConstraint.constant = 40
        
        presenter = NCBCardServicePresenter()
        presenter?.delegate = self
        
        getCrdList()
        
        self.setupLayout()
        self.currentPage = 0
        getDataModel()
        
        let slideImageView = NCBHomeSlideShowImageView(frame: .zero)
        containerSlideImageView.addSubview(slideImageView)
        
        cardBanners = getBanners().filter({ $0.bannerCode == BannerCodeType.CARD_BANNER.rawValue })
        slideImageView.delegate = self
        slideImageView.reloadView(cardBanners, autoScroll: true)
//        setupPageControl(cardBanners.count)
        
        slideImageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
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
    
}

extension NCBCardServiceViewController: NCBHomeSlideShowImageViewDelegate {
    
    func bannerDidSelectAt(_ index: Int) {
        if cardBanners.count == 0 {
            return
        }
        showActionForBannerPopup(cardBanners[index])
    }
    
}

extension NCBCardServiceViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cardsCollectionView{
            return listCard.count
        }
        return menuDataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if collectionView == cardsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.ncbCardCollectionViewCellID.identifier, for: indexPath) as! NCBCardCollectionViewCell
            
            let item = listCard[indexPath.row]
            cell.setupData(item)
            cell.backgroundColor = UIColor.clear
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier, for: indexPath) as! NCBHomeMenuIconCollectionViewCell
        let item = menuDataModels[indexPath.row]
        cell.seupCardServiceData(item)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cardsCollectionView{
            return CGSize(width: 272, height: 176)
        }
        return CGSize(width: sizeItemWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cardsCollectionView{
            let item = listCard[indexPath.row]
            
            if item.cardtype?.uppercased() == CreditCardType.DB.rawValue {
                if let _vc = R.storyboard.accountInfo.ncbCreditCardViewController() {
                    _vc.creditCardInfo = item
                    self.navigationController?.pushViewController(_vc, animated: true)
                }
            } else {
                if let _vc = R.storyboard.creditCard.ncbCreditCardGeneralInfoViewController() {
                    _vc.creditCardInfo = listCard[indexPath.row]
                    _vc.needGetDetail = true
                    self.navigationController?.pushViewController(_vc, animated: true)
                }
            }
        }else{
            let item = menuDataModels[indexPath.row]
            switch item.type {
            case .onlinePayment:
                let vc = NCBOnlinePaymentViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case .openLockActivateCard:
                if let vc = R.storyboard.cardService.ncbOpenLockCardViewController() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .autoDebtDeduction:
                self.navigationController?.pushViewController(NCBAutoDebtDeductionViewController(), animated: true)
            case .registrationCard:
                var items = [BottomSheetStringItem]()
                items.append(BottomSheetStringItem(title: "Phát hành mới thẻ ATM", isCheck: false))
                items.append(BottomSheetStringItem(title: "Phát hành mới thẻ tín dụng", isCheck: false))
                items.append(BottomSheetStringItem(title: "Phát hành lại", isCheck: false))
                if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                    vc.setData("Đăng ký phát hành thẻ", items: items, isHasOptionItem: true)
                    vc.delegate = self
                    showBottomSheet(controller: vc, size: 330)
                }
            case .resupplyPIN:
                if let vc = R.storyboard.cardService.ncbResupplyPINViewController() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .cardPayment:
                if let vc = R.storyboard.creditCard.ncbCreditCardPaymentViewController() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.cardsCollectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    
}

extension NCBCardServiceViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        removeBottomSheet()
        
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

extension NCBCardServiceViewController: NCBCardServicePresenterDelegate {
    
    func getCrCardList(services: [NCBCardModel]?, error: String?) {
        if cardType == CreditCardType.DB.rawValue {
            SVProgressHUD.dismiss()
        }
        
        if let _error = error {
            SVProgressHUD.dismiss()
            showAlert(msg: _error)
            return
        }
        
        if cardType == CreditCardType.VD.rawValue {
            cardType = CreditCardType.DB.rawValue
            getCrdList()
        }
        
        listCard += services ?? []
        
        if listCard.count > 0 {
            heightCardsClvConstraint.constant = 228
        }
        
        cardsCollectionView.reloadData()
    }
}

