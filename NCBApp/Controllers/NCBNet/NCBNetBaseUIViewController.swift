//
//  NCBNetBaseUIViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

enum NetButtonType: Int {
    case branch = 0
    case atm
}

class NCBNetBaseUIViewController: NCBBaseViewController {
    
    //MARK: Properties
    
    var tfSearch: UITextField!
    var tblView: UITableView!
    var isFilter = false
    fileprivate var branchBtn: UIButton!
    fileprivate var atmBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
}

extension NCBNetBaseUIViewController {
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = UIColor.white
        
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
        tfSearch.attributedPlaceholder = NSAttributedString(string: "Tìm kiếm địa điểm",
                                                            attributes: [NSAttributedString.Key.foregroundColor: ColorName.holderText.color!])
        searchContainerView.addSubview(tfSearch)
        
        tfSearch.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        branchBtn = UIButton()
        branchBtn.clipsToBounds = true
        branchBtn.layer.cornerRadius = 18
        branchBtn.setTitle("Chi nhánh", for: .normal)
        branchBtn.titleLabel?.font = regularFont(size: 12)
        branchBtn.setTitleColor(ColorName.blackText.color, for: .normal)
        branchBtn.setTitleColor(UIColor(hexString: "0083DC"), for: .selected)
        branchBtn.backgroundColor = UIColor(hexString: "D8EAFA")
        branchBtn.tag = NetButtonType.branch.rawValue
        branchBtn.isSelected = true
        branchBtn.addTarget(self, action: #selector(changeType(_:)), for: .touchUpInside)
        view.addSubview(branchBtn)
        
        branchBtn.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(120)
            make.height.equalTo(36)
            make.top.equalTo(searchContainerView.snp_bottom).offset(10)
        }
        
        atmBtn = UIButton()
        atmBtn.clipsToBounds = true
        atmBtn.layer.cornerRadius = 18
        atmBtn.setTitle("ATM", for: .normal)
        atmBtn.titleLabel?.font = regularFont(size: 12)
        atmBtn.setTitleColor(ColorName.blackText.color, for: .normal)
        atmBtn.setTitleColor(UIColor(hexString: "0083DC"), for: .selected)
        atmBtn.backgroundColor = UIColor(hexString: "EDEDED")
        atmBtn.tag = NetButtonType.atm.rawValue
        atmBtn.addTarget(self, action: #selector(changeType(_:)), for: .touchUpInside)
        view.addSubview(atmBtn)
        
        atmBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(branchBtn.snp.trailing).offset(10)
            make.width.equalTo(120)
            make.height.equalTo(36)
            make.top.equalTo(branchBtn.snp.top)
        }
        
        let headerView = UIView()
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(branchBtn.snp_bottom).offset(5)
        }
        
        let lbTitle = UILabel()
        lbTitle.text = "Kết quả tìm kiếm"
        lbTitle.font = semiboldFont(size: 14)
        lbTitle.textColor = UIColor(hexString: "959595")
        headerView.addSubview(lbTitle)
        
        lbTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
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
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
        
        setCustomHeaderTitle("Mạng lưới NCB")
    }
    
    @objc func textFieldDidChange(_ tf: UITextField) {
        if tf.text == "" {
            isFilter = false
        } else {
            isFilter = true
        }
    }
    
    @objc func changeType(_ sender: UIButton) {
        if sender.isSelected {
            return
        }
        
        branchBtn.isSelected = (sender == branchBtn)
        atmBtn.isSelected = (sender == atmBtn)
        
        branchBtn.backgroundColor = branchBtn.isSelected ? UIColor(hexString: "D8EAFA") : UIColor(hexString: "EDEDED")
        atmBtn.backgroundColor = atmBtn.isSelected ? UIColor(hexString: "D8EAFA") : UIColor(hexString: "EDEDED")
    }
    
}
