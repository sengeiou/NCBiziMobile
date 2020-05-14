//
//  NCBRegisterNewServiceViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/27/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum RegisterNewServiceType: Int {
    case izi = 0
    case loan
    case credit
}

struct RegisterNewServiceModel {
    var name = ""
    var icon = ""
    var type: RegisterNewServiceType = .izi
}

class NCBRegisterNewServiceViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var containerSlideImageView: UIView!
    
    //MARK: Properties
    
    fileprivate let dataModels = [RegisterNewServiceModel(name: "Tài khoản IZI", icon: R.image.ic_izi_account.name, type: .izi), RegisterNewServiceModel(name: "Dịch vụ vay vốn", icon: R.image.ic_loan_service.name, type: .loan), RegisterNewServiceModel(name: "Thẻ tín dụng", icon: R.image.ic_register_credit_service.name, type: .credit)]
    fileprivate var pageControl = UIPageControl()
    fileprivate var newBanners = [NCBBannerModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func backAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension NCBRegisterNewServiceViewController {
    
    override func setupView() {
        super.setupView()
        
        colView.register(UINib(nibName: R.nib.ncbHomeMenuIconCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier)
        colView.delegate = self
        colView.dataSource = self
        
        let slideImageView = NCBHomeSlideShowImageView(frame: .zero)
        containerSlideImageView.addSubview(slideImageView)
        
        newBanners = getBanners().filter({ $0.bannerCode == BannerCodeType.NEW.rawValue })
        slideImageView.delegate = self
        slideImageView.reloadView(newBanners, autoScroll: true)
//        setupPageControl(newBanners.count)
        
        slideImageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Đăng ký dịch vụ mới")
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

extension NCBRegisterNewServiceViewController: NCBHomeSlideShowImageViewDelegate {
    
    func bannerDidSelectAt(_ index: Int) {
        if newBanners.count == 0 {
            return
        }
        showActionForBannerPopup(newBanners[index])
    }
    
}

extension NCBRegisterNewServiceViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        case .loan:
            if let vc = R.storyboard.registerNewService.ncbRegisterForLoanViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .izi:
            if let vc = R.storyboard.registerNewService.ncbOpenIZIAccountStep1ViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .credit:
            if let vc = R.storyboard.registerNewService.ncbRegisterCreditCardViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
