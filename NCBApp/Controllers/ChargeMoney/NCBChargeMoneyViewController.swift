//
//  NCBChargeMoneyViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import ImageSlideshow
import ObjectMapper
import SnapKit

enum ChargeMoney: Int {
    case phoneCharge = 0
    case airpay
}

struct ChargeMoneyModel {
    var name = ""
    var icon = ""
    var type = ChargeMoney.phoneCharge
}

class NCBChargeMoneyViewController: NCBBaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var lbSavedList: UILabel! {
        didSet {
            lbSavedList.font = regularFont(size: 12)
            lbSavedList.textColor = ColorName.blurNormalText.color
            lbSavedList.text = "Danh sách đã lưu"
        }
    }
    @IBOutlet weak var gotoListSavedContactBtn: UIControl! {
        didSet {
            gotoListSavedContactBtn.addTarget(self, action: #selector(self.goToListSavedContact(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var listChargeMoneyFormClv: UICollectionView! {
        didSet {
            listChargeMoneyFormClv.register(UINib(nibName: R.nib.ncbHomeMenuIconCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier)
            listChargeMoneyFormClv.delegate = self
            listChargeMoneyFormClv.dataSource = self
        }
    }
    @IBOutlet weak var containerSlideImageView: UIView!
    
    // MARK: - Properties
    
    fileprivate let dataModels = [ChargeMoneyModel(name: "Nạp điện thoại", icon: R.image.ic_feature_rechange_price_phone.name, type: .phoneCharge), ChargeMoneyModel(name: "Nạp ví điện tử Airpay", icon: R.image.ic_wallet.name, type: .airpay)]
    fileprivate var pageControl = UIPageControl()
    fileprivate var topupBanners = [NCBBannerModel]()
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @objc func goToListSavedContact(_ sender: UIControl) {
        let controller = NCBRechargeSavedListViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension NCBChargeMoneyViewController {
    override func setupView() {
        super.setupView()
        
        setHeaderTitle("NẠP TIỀN")
        
        let slideImageView = NCBHomeSlideShowImageView(frame: .zero)
        containerSlideImageView.addSubview(slideImageView)
        
        topupBanners = getBanners().filter({ $0.bannerCode == BannerCodeType.TOPUP_BANNER.rawValue })
        slideImageView.delegate = self
        slideImageView.reloadView(topupBanners, autoScroll: true)
//        setupPageControl(topupBanners.count)
        
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

extension NCBChargeMoneyViewController: NCBHomeSlideShowImageViewDelegate {
    
    func bannerDidSelectAt(_ index: Int) {
        if topupBanners.count == 0 {
            return
        }
        showActionForBannerPopup(topupBanners[index])
    }
    
}

extension NCBChargeMoneyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier, for: indexPath) as! NCBHomeMenuIconCollectionViewCell
        let item = dataModels[indexPath.row]
        cell.lbTitle.text = item.name
        cell.iconView.image = UIImage(named: item.icon)?.withRenderingMode(.alwaysTemplate)
        cell.iconView.tintColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = dataModels[indexPath.item]
        
        switch item.type {
        case .phoneCharge:
            if let _vc = R.storyboard.chargeMoney.ncbChargeMoneyPhoneNumberViewController() {
                self.navigationController?.pushViewController(_vc, animated: true)
            }
        case .airpay:
            if let _vc = R.storyboard.chargeMoney.ncbChargeAirpayViewController() {
                self.navigationController?.pushViewController(_vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (appDelegate.window!.frame.size.width - 110)/2
        return CGSize(width: width, height: 100)
    }
}
