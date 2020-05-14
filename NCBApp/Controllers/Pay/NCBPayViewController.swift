//
//  NCBPayViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/23/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ImageSlideshow
import ObjectMapper
import SnapKit

enum PayType: String {
    case NUOC
    case DTCDTS
    case CAP
    case DTCDCD
    case DIEN
    case NET
}

fileprivate let sizeItemWidth = (appDelegate.window!.frame.width - 70)/3

class NCBPayViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var lbSavedList: UILabel!
    @IBOutlet weak var containerSavedList: UIView!
    @IBOutlet weak var lbAutoPayService: UILabel!
    @IBOutlet weak var containerSlideImageView: UIView!
    
    //MARK: Properties

    fileprivate var p: NCBPayPresenter?
    fileprivate var savedListPresenter: NCBPayBillSavedListPresenter?
    fileprivate var verifyPaymentPresenter: NCBVerifyServicePaymentPresenter?
    fileprivate var autoRegisterPresenter: NCBAutoPaymentListPresenter?
    fileprivate var dataModels = [NCBServiceModel]()
    fileprivate var savedList = [NCBPayBillSavedModel]()
    fileprivate var savedListSlideView: NCBSavedListSlideView?
    fileprivate var savedItemIndexSelected: Int?
    var showBack = false
    fileprivate var pageControl = UIPageControl()
    fileprivate var payBanners = [NCBBannerModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !showBack {
            navigationItem.leftBarButtonItem = nil
        }
        
        p = NCBPayPresenter()
        p?.delegate = self
        
        savedListPresenter = NCBPayBillSavedListPresenter()
        savedListPresenter?.delegate = self
        
        verifyPaymentPresenter = NCBVerifyServicePaymentPresenter()
        verifyPaymentPresenter?.delegate = self
        
        autoRegisterPresenter = NCBAutoPaymentListPresenter()
        autoRegisterPresenter?.delegate = self
        
        SVProgressHUD.show()
        p?.getServiceList(params: ["type": "1"])
        
        let slideImageView = NCBHomeSlideShowImageView(frame: .zero)
        containerSlideImageView.addSubview(slideImageView)
        
        payBanners = getBanners().filter({ $0.bannerCode == BannerCodeType.PAY_BANNER.rawValue })
        slideImageView.delegate = self
        slideImageView.reloadView(payBanners, autoScroll: true)
//        setupPageControl(payBanners.count)
        
        slideImageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
    @IBAction func savedListAction(_ sender: Any) {
        if let vc = R.storyboard.servicePayment.ncbPayBillSavedListViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func autoPayServiceAction(_ sender: Any) {
        if let vc = R.storyboard.servicePayment.ncbAutoPaymentListViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBPayViewController {
    
    override func setupView() {
        super.setupView()
        
        lbSavedList.font = regularFont(size: 12)
        lbSavedList.textColor = ColorName.blurNormalText.color
        lbAutoPayService.font = regularFont(size: 12)
        lbAutoPayService.textColor = ColorName.blurNormalText.color
        
        savedListSlideView = R.nib.ncbSavedListSlideView.firstView(owner: self)
        savedListSlideView!.delegate = self
        containerSavedList.addSubview(savedListSlideView!)
        
        savedListSlideView!.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        hiddenSavedListSlide(true)
        
        colView.register(UINib(nibName: R.nib.ncbHomeMenuIconCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier)
        colView.delegate = self
        colView.dataSource = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("THANH TOÁN DỊCH VỤ")
    }
    
}

extension NCBPayViewController: NCBHomeSlideShowImageViewDelegate {
    
    func bannerDidSelectAt(_ index: Int) {
        if payBanners.count == 0 {
            return
        }
        showActionForBannerPopup(payBanners[index])
    }
    
}

extension NCBPayViewController {
    
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
    
    fileprivate func hiddenSavedListSlide(_ hidden: Bool) {
        containerSavedList.isHidden = hidden
        for constraint in containerSavedList.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = hidden ? 0 : 160
            }
        }
    }
    
    fileprivate func showSavedItemAction() {
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.delegate = self
            vc.setData("Chọn chức năng", items: [BottomSheetStringItem(title: "Thanh toán"), BottomSheetStringItem(title: "Xoá thông tin đã lưu")], isHasOptionItem: false)
            showBottomSheet(controller: vc, size: 250)
        }
    }
    
    fileprivate func showPaymentScreen(_ item: NCBPayBillSavedModel) {
        let provider = NCBServiceProviderModel()
        provider.partner = item.partner
        provider.providerCode = item.providerCode
        provider.providerName = item.providerName
        provider.serviceCode = item.serviceCode
        provider.status = item.status
        provider.customerCode = item.billNo
        
        if let vc = R.storyboard.servicePayment.ncbServicePaymentViewController() {
            vc.serviceProvider = provider
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func deleteSavedPayment(_ item: NCBPayBillSavedModel) {
        SVProgressHUD.show()
        verifyPaymentPresenter?.saveService(providerCode: item.providerCode ?? "", serviceCode: item.serviceCode ?? "", customerCode: item.billNo ?? "", memName: "", isActive: false)
    }
    
    fileprivate func reloadSavedListSliderView() {
        savedListSlideView?.setData(savedList)
        lbSavedList.text = "Danh sách đã lưu (\(savedList.count))"
        hiddenSavedListSlide(savedList.count == 0)
    }
    
}

extension NCBPayViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        removeBottomSheet()
        guard let savedItemIndexSelected = savedItemIndexSelected else {
            return
        }

        let savedItem = savedList[savedItemIndexSelected]
        if index == 0 {
            showPaymentScreen(savedItem)
        } else if index == 1 {
            deleteSavedPayment(savedItem)
        }
    }
    
}

extension NCBPayViewController: NCBSavedListSlideViewDelegate {
    
    func savedListDidSelectItem(index: Int) {
        savedItemIndexSelected = index
        showSavedItemAction()
    }
    
}

extension NCBPayViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier, for: indexPath) as! NCBHomeMenuIconCollectionViewCell
        let item = dataModels[indexPath.row]
        
        var image: UIImage!

        switch item.serviceCode {
        case PayType.NUOC.rawValue:
            image = R.image.ic_pay_water()
            cell.lbTitle.text = "Nước"
        case PayType.DTCDTS.rawValue:
            image = R.image.ic_pay_postpaid_mobile()
            cell.lbTitle.text = "Di động trả sau"
        case PayType.CAP.rawValue:
            image = R.image.ic_pay_tv()
            cell.lbTitle.text = "Truyền hình"
        case PayType.DTCDCD.rawValue:
            image = R.image.ic_pay_phone()
            cell.lbTitle.text = "Điện thoại cố định"
        case PayType.DIEN.rawValue:
            image = R.image.ic_pay_electric()
            cell.lbTitle.text = "Điện"
        case PayType.NET.rawValue:
            image = R.image.ic_pay_internet()
            cell.lbTitle.text = "Internet"
        default:
            image = UIImage()
            cell.lbTitle.text = item.serviceName
        }
        
        cell.iconView.image = image.withRenderingMode(.alwaysTemplate)
        cell.iconView.tintColor = UIColor.white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sizeItemWidth, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataModels[indexPath.row]
        
        if item.serviceCode == PayType.DIEN.rawValue {
            if let vc = R.storyboard.servicePayment.ncbServicePaymentViewController() {
                vc.serviceModel = item
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        if let vc = R.storyboard.servicePayment.ncbProviderListViewController() {
            vc.serviceModel = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension  NCBPayViewController: NCBPayPresenterDelegate {
    
    func getServiceListCompleted(services: [NCBServiceModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let services = services {
            dataModels = services
            colView.reloadData()
        }
        
        SVProgressHUD.show()
        savedListPresenter?.getSavedList(params: ["cifNo": NCBShareManager.shared.getUser()!.cif ?? ""])
        autoRegisterPresenter?.getAutoPayBillList(params: ["userName": NCBShareManager.shared.getUser()!.username ?? ""])
    }
    
}

extension NCBPayViewController: NCBPayBillSavedListPresenterDelegate {
    
    func getSavedListCompleted(savedList: [NCBPayBillSavedModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        self.savedList = savedList ?? []
        reloadSavedListSliderView()
    }
    
}

extension NCBPayViewController: NCBVerifyServicePaymentPresenterDelegate {
    
    func saveServiceCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        showAlert(msg: "Xóa thông tin dịch vụ thành công")
        
        if let index = savedItemIndexSelected {
            savedList.remove(at: index)
            reloadSavedListSliderView()
        }
    }
    
}

extension NCBPayViewController: NCBAutoPaymentListPresenterDelegate {
    
    func getAutoPayBillListCompleted(autoPayBillList: [NCBPayBillSavedModel]?, error: String?) {
        lbAutoPayService.text = "Dịch vụ thanh toán tự động (\(autoPayBillList?.count ?? 0))"
    }
    
}
