//
//  NCBBaseSearchListViewController.swift
//  NCBApp
//
//  Created by Thuan on 6/26/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

class NCBBaseSearchListViewController: NCBBaseViewController {
    
    //MARK: Properties
    
    var lbTitle: UILabel!
    var tfSearch: UITextField!
    var tblView: UITableView!
    var isFilter = false
    let indexData = ["A","B","C","D","E","F","G","H","I",
                     "J","K","L","M","N","O","P","Q","R",
                     "S","T","U","V","W","X","Y","Z"]
    fileprivate var addNewView: UIView!
    fileprivate var headerView: UIView!
    var indexView: SectionIndexView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isShowIndexView() {
            indexView = SectionIndexView(frame: CGRect(x: view.bounds.width - 35, y: tblView.frame.origin.y + 10, width: 30, height: 300))
            indexView.dataSource = self
            indexView.delegate = self
            view.addSubview(indexView)
        }
    }
    
    @objc func isShowIndexView() -> Bool {
        return true
    }
    
}

extension NCBBaseSearchListViewController {
    
    override func setupView() {
        super.setupView()
        
        let searchContainerView = UIView()
        searchContainerView.clipsToBounds = true
        searchContainerView.layer.cornerRadius = 25
        searchContainerView.backgroundColor = UIColor.white
        searchContainerView.layer.masksToBounds = false
        searchContainerView.layer.shadowColor = UIColor.black.cgColor
        searchContainerView.layer.shadowOpacity = 0.13
        searchContainerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        searchContainerView.layer.shadowRadius = 10
        view.addSubview(searchContainerView)
        
        let maxY = navHeight + (hasTopNotch ? 24 :34)
        
        searchContainerView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.additionalSafeAreaInsets.top).offset(maxY)
            } else {
                make.top.equalToSuperview().offset(maxY)
            }
            make.height.equalTo(50)
        }
        
        let iconSearch = UIImageView()
        iconSearch.contentMode = .scaleAspectFit
        iconSearch.image = R.image.ic_search()
        searchContainerView.addSubview(iconSearch)
        
        iconSearch.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        tfSearch = UITextField()
        tfSearch.autocorrectionType = .no
        tfSearch.borderStyle = .none
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tfSearch.font = semiboldFont(size: 14)
        tfSearch.textColor = ColorName.holderText.color
        tfSearch.attributedPlaceholder = NSAttributedString(string: "Tìm kiếm",
                                                            attributes: [NSAttributedString.Key.foregroundColor: ColorName.holderText.color!])
        searchContainerView.addSubview(tfSearch)
        
        tfSearch.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        headerView = UIView()
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(searchContainerView.snp_bottom).offset(20)
        }
        
        lbTitle = UILabel()
        lbTitle.font = semiboldFont(size: 14)
        lbTitle.textColor = UIColor(hexString: "959595")
        headerView.addSubview(lbTitle)
        
        lbTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(30)
        }
        
        addNewView = UIView()
        addNewView.isHidden = true
        addNewView.isUserInteractionEnabled = true
        headerView.addSubview(addNewView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addNewAction))
        addNewView.addGestureRecognizer(gesture)
        
        addNewView.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(25)
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(lbTitle)
        }
        
        let accessory = UIImageView()
        accessory.image = R.image.ic_accessory_arrow_right()
        accessory.contentMode = .scaleAspectFit
        addNewView.addSubview(accessory)
        
        accessory.snp.makeConstraints { (make) in
            make.width.height.equalTo(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        let lbAddNew = UILabel()
        lbAddNew.font = semiboldFont(size: 12)
        lbAddNew.textColor = ColorName.blurNormalText.color
        lbAddNew.text = "Thêm mới"
        addNewView.addSubview(lbAddNew)
        
        lbAddNew.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(accessory.snp_leading).offset(-3)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(hexString: "D2D2D2")
        headerView.addSubview(bottomLine)
        
        bottomLine.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        tblView = UITableView()
        tblView.separatorStyle = .none
        view.addSubview(tblView)
        
        tblView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(isShowIndexView() ? -40 : -15)
            make.top.equalTo(headerView.snp_bottom).offset(0)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.additionalSafeAreaInsets.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
    @objc func textFieldDidChange(_ tf: UITextField) {
        if tf.text == "" {
            isFilter = false
        } else {
            isFilter = true
        }
    }
    
    @objc func sectionIndexViewSelected(_ index: Int, string: String) {
        
    }
    
    @objc func addNewAction() {
        
    }
    
    func showAddNewView() {
        addNewView.isHidden = false
    }
    
    func hiddenHeaderView() {
        headerView.isHidden = true
        for constraint in headerView.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = 0
                break
            }
        }
    }
    
}

extension NCBBaseSearchListViewController: SectionIndexViewDataSource, SectionIndexViewDelegate {
    
    func numberOfItemViews(in sectionIndexView: SectionIndexView) -> Int {
        return indexData.count
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, itemViewAt section: Int) -> SectionIndexViewItem {
        let itemView = SectionIndexViewItem()
        itemView.title = indexData[section]
        itemView.titleFont = semiboldFont(size: 11)
        itemView.titleColor = UIColor(hexString: "797979")
        itemView.titleSelectedColor = UIColor(hexString: "797979")
        itemView.selectedColor = UIColor.white
        return itemView
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, itemPreviewFor section: Int) -> SectionIndexViewItemPreview {
        let preview = SectionIndexViewItemPreview(title: indexData[section], type: .default)
        return preview
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, toucheMoved section: Int) {
        indexView.selectItem(at: section)
        sectionIndexViewSelected(section, string: indexData[section])
    }
    
    func sectionIndexView(_ sectionIndexView: SectionIndexView, didSelect section: Int) {
        indexView.selectItem(at: section)
        sectionIndexViewSelected(section, string: indexData[section])
    }
    
}
