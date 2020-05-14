//
//  NCBTransactionSuccessfulViewController.swift
//  NCBApp
//
//  Created by Thuan on 7/31/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

class NCBTransactionSuccessfulViewController: NCBBaseViewController {
    
    var lbAmountTitle: UILabel!
    var lbAmountValue: UILabel!
    var lbFee: UILabel!
    var infoTblView: UITableView!
    var lbNote: UILabel!
    fileprivate var containerInfoView: UIView!
    fileprivate var continueBtn: UIButton!
    fileprivate var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NCBShareManager.shared.areTrading = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension NCBTransactionSuccessfulViewController {
    
    override func setupView() {
        super.setupView()
        
        let bg = UIImageView()
        bg.image = R.image.transaction_info_bg()
        view.addSubview(bg)
        
        bg.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        containerInfoView = UIView()
        containerInfoView.clipsToBounds = true
        containerInfoView.layer.cornerRadius = 4
        containerInfoView.backgroundColor = UIColor.white
        view.addSubview(containerInfoView)
        
        let maxY = navHeight + (hasTopNotch ? 35 : 45)
        
        containerInfoView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            if #available(iOS 11, *) {
                make.top.equalTo(self.additionalSafeAreaInsets.top).offset(maxY)
            } else {
                make.top.equalToSuperview().offset(maxY)
            }
//            make.height.equalTo(bg.snp.height).multipliedBy(0.6)
            make.height.equalTo(self.view.frame.height*6/10)
        }
        
        headerView = UIView()
        containerInfoView.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
            make.top.equalToSuperview().offset(20)
        }
        
        lbAmountTitle = UILabel()
        lbAmountTitle.font = regularFont(size: 12)
        lbAmountTitle.textColor = ColorName.blackText.color
        lbAmountTitle.text = "Số tiền chuyển"
        headerView.addSubview(lbAmountTitle)
        
        lbAmountTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        lbAmountValue = UILabel()
        lbAmountValue.font = boldFont(size: 22)
        lbAmountValue.textColor = ColorName.amountBlueText.color
        headerView.addSubview(lbAmountValue)
        
        lbAmountValue.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(lbAmountTitle.snp.bottom).offset(2)
        }
        
        lbFee = UILabel()
        lbFee.font = regularFont(size: 12)
        lbFee.textColor = ColorName.holderText.color
        lbFee.numberOfLines = 0
        lbFee.textAlignment = .center
        headerView.addSubview(lbFee)
        
        lbFee.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.top.equalTo(lbAmountValue.snp.bottom).offset(15)
        }
        
        let line = UIView()
        line.backgroundColor = ColorName.bottomLine.color
        headerView.addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview()
        }
        
        
        infoTblView = UITableView(frame: CGRect.zero, style: .grouped)
        infoTblView.backgroundColor = UIColor.clear
        containerInfoView.addSubview(infoTblView)

        lbNote = UILabel()
        lbNote.font = semiboldFont(size: 14)
        lbNote.textColor = ColorName.amountBlueText.color
        lbNote.numberOfLines = 0
        lbNote.textAlignment = .center
        containerInfoView.addSubview(lbNote)

        continueBtn = UIButton()
        continueBtn.setTitle("Thực hiện giao dịch khác", for: .normal)
        continueBtn.titleLabel?.font = regularFont(size: 12)
        continueBtn.setTitleColor(UIColor.white, for: .normal)
        continueBtn.backgroundColor = UIColor(hexString: "0896E1")
        continueBtn.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
        containerInfoView.addSubview(continueBtn)
        
        infoTblView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(0)
            make.bottom.equalTo(lbNote.snp.top).offset(0)
        }

        lbNote.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(continueBtn.snp.top).offset(-20)
        }
        
        continueBtn.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        
        let tickView = UIView()
        tickView.backgroundColor = UIColor(hexString: "0896E1")
        tickView.clipsToBounds = true
        tickView.layer.cornerRadius = 25
        view.addSubview(tickView)
        
        tickView.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.centerX.equalTo(containerInfoView)
            make.top.equalTo(containerInfoView.snp.top).offset(-25)
        }
        
        let tickLbl = UILabel()
        tickLbl.text = "􀆅"
        tickLbl.font = boldFont(size: 22)
        tickLbl.textColor = UIColor.white
        tickView.addSubview(tickLbl)
        
        tickLbl.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
    @objc func continueAction() {
        
    }
    
    func hiddenHeaderView() {
        headerView.isHidden = true
        for constraint in headerView.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = 20
                break
            }
        }
    }
    
    func updateHeightInfoView(_ height: CGFloat) {
        for constraint in containerInfoView.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = height
                break
            }
        }
    }
    
    func updateHeightHeaderView(_ height: CGFloat) {
        for constraint in headerView.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = 120 + height
                break
            }
        }
    }
    
    func setButtonTitle(_ title: String) {
        continueBtn.setTitle(title, for: .normal)
    }
    
}
