//
//  NCBTransferViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ImageSlideshow
import ObjectMapper
import SnapKit

enum TransferType: Int {
    case internalTransfer = 0
    case interbankTransfer
    case charityTransfer
    case favor
}

struct TransferModel {
    var name = ""
    var icon = ""
    var type: TransferType = .internalTransfer
}

class NCBTransferViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var lbBeneficiary: UILabel!
    @IBOutlet weak var containerSlideImageView: UIView!
    
    //MARK: Properties
    
    fileprivate let dataModels = [TransferModel(name: "Chuyển khoản nội bộ",
                                                icon: R.image.ic_feature_internal_transfer.name, type: .internalTransfer),
                                  TransferModel(name: "Chuyển khoản liên ngân hàng",
                                                icon: R.image.ic_feature_interbank_transfer.name, type: .interbankTransfer),
                                  TransferModel(name: "Chuyển tiền từ thiện",
                                                icon: R.image.ic_feature_charity_transfer.name, type: .charityTransfer)]
    var showBack = false
    fileprivate var pageControl = UIPageControl()
    fileprivate var transferBanners = [NCBBannerModel]()
    
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
    }
    
    @IBAction func showBeneficiaryListAction(_ sender: Any) {
        if let vc = R.storyboard.receiverList.ncbReceiveListViewController() {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBTransferViewController {
    
    override func setupView() {
        super.setupView()
        
        lbBeneficiary.font = regularFont(size: 12)
        lbBeneficiary.textColor = ColorName.blurNormalText.color
        
        colView.register(UINib(nibName: R.nib.ncbHomeMenuIconCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier)
        colView.delegate = self
        colView.dataSource = self
        
        let slideImageView = NCBHomeSlideShowImageView(frame: .zero)
        containerSlideImageView.addSubview(slideImageView)
        
        transferBanners = getBanners().filter({ $0.bannerCode == BannerCodeType.TRANSFER_BANNER.rawValue })
        slideImageView.delegate = self
        slideImageView.reloadView(transferBanners, autoScroll: true)
//        setupPageControl(transferBanners.count)
        
        slideImageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("CHUYỂN KHOẢN")
        lbBeneficiary.text = "Quản lý danh sách thụ hưởng"
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

extension NCBTransferViewController: NCBHomeSlideShowImageViewDelegate {
    
    func bannerDidSelectAt(_ index: Int) {
        if transferBanners.count == 0 {
            return
        }
        showActionForBannerPopup(transferBanners[index])
    }
    
}

extension NCBTransferViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (appDelegate.window!.frame.size.width - 70)/3
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataModels[indexPath.row]
        
        switch item.type {
        case .internalTransfer:
            if let vc = R.storyboard.transfer.ncbInternalTransferViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .interbankTransfer:
            if let vc = R.storyboard.transfer.ncbInterbankTransferViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .charityTransfer:
            if let vc = R.storyboard.transfer.ncbCharityTransferViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .favor:
            if let vc = R.storyboard.transfer.ncbCharityTransferViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
