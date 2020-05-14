//
//  NCBSetupServiceViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

fileprivate let sizeItemWidth = (appDelegate.window!.frame.width - 30)/3

class NCBSetupServiceViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var mainColView: UICollectionView!
    @IBOutlet weak var secondColView: UICollectionView!
    
    //MARK: Properties
    
    fileprivate var mainDataModels = [NCBMenuIconModel]()
    fileprivate var secondDataModels = [NCBMenuIconModel]()
    fileprivate var dragView: NCBMenuIconDragView!
    fileprivate var currentPage = 0
    fileprivate var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let json = mainDataModels.toJSONString() {
            UserDefaults.standard.set(json, forKey: keyMenuIconSaved)
            UserDefaults.standard.synchronize()
        }
    }
    
    override func backAction(sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension NCBSetupServiceViewController {
    
    override func setupView() {
        super.setupView()
        
        initDragView()
        
        getDataModel()
        
        mainColView.register(UINib(nibName: R.nib.ncbHomeMenuIconCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier)
        mainColView.delegate = self
        mainColView.dataSource = self
        
        secondColView.register(UINib(nibName: R.nib.ncbHomeMenuIconCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier)
        secondColView.delegate = self
        secondColView.dataSource = self
        secondColView.backgroundColor = UIColor.clear
        secondColView.isPagingEnabled = true
        secondColView.showsHorizontalScrollIndicator = false
    
        updateDataModel()
        setupPageControl()
        
        let mainLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.mainHandleLongGesture(gesture:)))
        mainColView.addGestureRecognizer(mainLongPressGesture)
        
        let mainPanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.mainHandlePanGesture(gesture:)))
        mainPanGesture.delegate = self
        mainColView.addGestureRecognizer(mainPanGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        secondColView.addGestureRecognizer(longPressGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delegate = self
        secondColView.addGestureRecognizer(panGesture)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("TUỲ CHỈNH CHỨC NĂNG")
    }
    
}

extension NCBSetupServiceViewController {
    
    @objc func mainHandleLongGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: self.view)
            let indexPath = mainColView.indexPathForItem(at: gesture.location(in: mainColView))
            if let indexPath = indexPath, mainDataModels[indexPath.row].type != IconType.accountInfo.rawValue && mainDataModels[indexPath.row].type != IconType.editFunction.rawValue {
                let item = mainDataModels[indexPath.row]
                setSelected(item, point: point)
                mainColView.cellForItem(at: indexPath)?.alpha = 0
            }
        } else if gesture.state == .ended || gesture.state == .failed || gesture.state == .cancelled {
            dragView.isHidden = true
            mainColView.reloadData()
        }
        
    }
    
    @objc func mainHandlePanGesture(gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: self.view)
        if gesture.state == .changed && !dragView.isHidden {
            dragView.center = touchPoint
        } else if gesture.state == .recognized {
            dragView.isHidden = true
            
            let dropPointInMain = gesture.location(in: mainColView)
            let indexPath = mainColView.indexPathForItem(at: dropPointInMain)
            if let indexPath = indexPath, (mainDataModels[indexPath.row].type != IconType.accountInfo.rawValue && mainDataModels[indexPath.row].type != IconType.editFunction.rawValue) && dragView.selectedModel != nil {
                if let oldIndex = mainDataModels.firstIndex(where: { $0.type == dragView.selectedModel!.type }), mainDataModels[oldIndex].type != IconType.accountInfo.rawValue || mainDataModels[oldIndex].type != IconType.editFunction.rawValue {
                    mainDataModels.swapAt(indexPath.row, oldIndex)
                }
            }
            
            mainColView.reloadData()
        }
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: self.view)
            
            let indexPath = secondColView.indexPathForItem(at: gesture.location(in: secondColView))
            if let indexPath = indexPath, !secondDataModels[indexPath.row].existsForMain {
                let item = secondDataModels[indexPath.row]
                setSelected(item, point: point)
                secondColView.cellForItem(at: indexPath)?.alpha = 0
            }
        } else if gesture.state == .ended || gesture.state == .failed || gesture.state == .cancelled {
            dragView.isHidden = true
            updateDataModel()
        }
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: self.view)
        //        let validDropPoint = mainColView.superview!.frame.contains(touchPoint)
        if gesture.state == .changed && !dragView.isHidden {
            dragView.center = touchPoint
        } else if gesture.state == .recognized {
            dragView.isHidden = true
            
            let dropPointInMain = gesture.location(in: mainColView)
            let indexPath = mainColView.indexPathForItem(at: dropPointInMain)
            if let indexPath = indexPath, mainDataModels[indexPath.row].type != IconType.accountInfo.rawValue && mainDataModels[indexPath.row].type != IconType.editFunction.rawValue && dragView.selectedModel != nil {
                if indexPath.row < mainDataModels.count {
                    mainDataModels.remove(at: indexPath.row)
                    mainDataModels.insert(dragView.selectedModel!, at: indexPath.row)
                    mainColView.reloadData()
                }
            } else {
                dragView.isHidden = true
            }
            
            updateDataModel()
        }
    }
    
    func initDragView() {
        dragView = NCBMenuIconDragView(frame: CGRect(x: 0, y: 0, width: sizeItemWidth, height: 100))
        dragView.isHidden = true
        dragView.backgroundColor = UIColor.clear
        view.addSubview(dragView)
    }
    
    func setSelected(_ item: NCBMenuIconModel, point: CGPoint) {
        if !dragView.isHidden {
            return
        }
        
        dragView.lbTitle.text = item.title
        dragView.iconView.image = UIImage(named: item.image)?.withRenderingMode(.alwaysTemplate)
        dragView.iconView.tintColor = UIColor.white
        dragView.center = point
        dragView.isHidden = false
        dragView.selectedModel = item.copy() as? NCBMenuIconModel
    }
    
    fileprivate func getDataModel() {
        mainDataModels = getMainMenuIcon(true)
        
        secondDataModels.append(contentsOf: getMainMenuIcon(false))
        secondDataModels.removeFirst()
        secondDataModels.removeLast()
        
        var item = NCBMenuIconModel()
        item.title = "Chuyển tiền từ thiện"
        item.image = R.image.ic_feature_charity_transfer.name
        item.imageDisabled = R.image.ic_feature_charity_transfer_disable.name
        item.type = IconType.charity.rawValue
        secondDataModels.append(item)
        
        item = NCBMenuIconModel()
        item.title = "Nộp thêm tiết kiệm tích luỹ"
        item.image = R.image.ic_feature_extra_saving.name
        item.imageDisabled = R.image.ic_feature_extra_saving_disable.name
        item.type = IconType.rechargeSaving.rawValue
        secondDataModels.append(item)
        
        item = NCBMenuIconModel()
        item.title = "Tất toán tiết kiệm"
        item.image = R.image.ic_feature_settlement_saving.name
        item.imageDisabled = R.image.ic_feature_settlement_saving_disable.name
        item.type = IconType.settlementSaving.rawValue
        secondDataModels.append(item)
        
        item = NCBMenuIconModel()
        item.title = "Thanh toán thẻ tín dụng"
        item.image = R.image.ic_feature_pay_the_card.name
        item.imageDisabled = R.image.ic_feature_pay_the_card_disable.name
        item.type = IconType.creditPayment.rawValue
        secondDataModels.append(item)

        item = NCBMenuIconModel()
        item.title = "Nạp tiền ví điện tử"
        item.image = R.image.ic_wallet.name
        item.imageDisabled = R.image.ic_wallet_disable.name
        item.type = IconType.wallet.rawValue
        secondDataModels.append(item)

        item = NCBMenuIconModel()
        item.title = "Mạng lưới NCB"
        item.image = R.image.ic_feature_net.name
        item.imageDisabled = R.image.ic_feature_net_disable.name
        item.type = IconType.net.rawValue
        secondDataModels.append(item)
        
        item = NCBMenuIconModel()
        item.title = "Liên hệ"
        item.image = R.image.ic_feature_contact.name
        item.imageDisabled = R.image.ic_feature_contact_disable.name
        item.type = IconType.contact.rawValue
        secondDataModels.append(item)
        
        item = NCBMenuIconModel()
        item.title = "Hỗ trợ"
        item.image = R.image.ic_feature_support.name
        item.imageDisabled = R.image.ic_feature_support_disable.name
        item.type = IconType.support.rawValue
        secondDataModels.append(item)
    }
    
    func updateDataModel() {
        let sorted = secondDataModels.sorted(by: { $0.title < $1.title })
        secondDataModels = sorted
        
        var tempDataModels = [NCBMenuIconModel]()
        for item in secondDataModels {
            if mainDataModels.contains(where: { $0.type == item.type }) {
                item.existsForMain = true
                tempDataModels.append(item)
                if let index = secondDataModels.firstIndex(where: { $0.type == item.type }) {
                    secondDataModels.remove(at: index)
                }
            } else {
                item.existsForMain = false
            }
        }
        
        secondDataModels = secondDataModels + tempDataModels
        
        secondColView.reloadData()
    }
    
}

extension NCBSetupServiceViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = scrollView.contentOffset.x/pageWidth
//        print("fractionalPage \(fractionalPage)")
        let page = lround(Double(fractionalPage))
        if fractionalPage >= 4/3 {
            currentPage = 2
        } else {
            currentPage = page
        }

        pageControl.currentPage = Int(currentPage)
    }
    
}

//MARK: setup indicator for page icon

extension NCBSetupServiceViewController {
    
    fileprivate func setupPageControl() {
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor(hexString: "02A9E9").withAlphaComponent(0.31)
        self.pageControl.currentPageIndicatorTintColor = UIColor(hexString: "02A9E9").withAlphaComponent(1.0)

        view.addSubview(pageControl)

        pageControl.snp.makeConstraints { (make) in
            make.height.equalTo(15)
            make.centerX.equalToSuperview()
            make.top.equalTo(secondColView.snp.bottom).offset(5)
        }
    }
    
}

extension NCBSetupServiceViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == secondColView {
            return secondDataModels.count
        }
        
        return mainDataModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainColView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier, for: indexPath) as! NCBHomeMenuIconCollectionViewCell
            let item = mainDataModels[indexPath.row]
            cell.setupMainData(item)
            cell.backgroundColor = UIColor.clear
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.ncbHomeMenuIconCollectionViewCellID.identifier, for: indexPath) as! NCBHomeMenuIconCollectionViewCell
        let item = secondDataModels[indexPath.row]
        cell.seupOtherData(item)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sizeItemWidth, height: 100)
    }
    
}
