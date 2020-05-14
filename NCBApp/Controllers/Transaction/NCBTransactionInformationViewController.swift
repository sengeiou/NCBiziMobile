//
//  NCBTransactionInformationViewController.swift
//  NCBApp
//
//  Created by Thuan on 7/29/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

class NCBTransactionInformationViewController: NCBBaseVerifyTransactionViewController {
    
    let touchMe = BiometricIDAuth()
    var lbAmountTitle: UILabel!
    var lbAmountValue: UILabel!
    var lbFee: UILabel!
    var infoTblView: UITableView!
    var authenticateView: NCBAuthenticateTransactionView!
    fileprivate var headerView: UIView!
    fileprivate var otpVC = R.storyboard.bottomSheet.ncbotpViewController()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBTransactionInformationViewController {
    
    override func setupView() {
        super.setupView()
        
        let bg = UIImageView()
        bg.image = R.image.transaction_info_bg()
        view.addSubview(bg)
        
        bg.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        let containerInfoView = UIView()
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
            make.height.equalTo(self.view.frame.height*6/10)
        }
        
        headerView = UIView()
        containerInfoView.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(120)
        }
        
        lbAmountTitle = UILabel()
        lbAmountTitle.font = regularFont(size: 12)
        lbAmountTitle.textColor = ColorName.blackText.color
        lbAmountTitle.text = "Số tiền chuyển"
        headerView.addSubview(lbAmountTitle)
        
        lbAmountTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
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
        
        infoTblView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(0)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        authenticateView = NCBAuthenticateTransactionView()
        view.addSubview(authenticateView)
        
        authenticateView.snp.makeConstraints { (make) in
            make.leading.equalTo(containerInfoView.snp.leading).offset(20)
            make.trailing.equalTo(containerInfoView.snp.trailing).offset(-20)
            make.top.equalTo(containerInfoView.snp.bottom).offset(-25)
            make.height.equalTo(50)
        }
        
        authenticateView.otpBtn.addTarget(self, action: #selector(verifyAction), for: .touchUpInside)
        authenticateView.touchIDBtn.addTarget(self, action: #selector(biometricAction), for: .touchUpInside)
        
        chooseBiometric()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
    override func otpAuthenticateFailure() {
        otpVC.clear()
    }
    
    @objc fileprivate func biometricAction() {
//        if !isOpenTransactionTouchID {
//            showAlert(msg: "Vui lòng kích hoạt xác nhận giao dịch bằng \(touchMe.biometricSuffix) tại phần cài đặt trong ứng dụng")
//            return
//        }
        if !checkBioAvailable(touchMe, isOpen: isOpenTransactionTouchID) {
            return
        }
        
        touchMe.evaluate { [weak self] (error, msg) in
            if error == biometricSuccessCode {
                self?.verifyWithTouchID()
            } else {
                if let msg = msg {
                    self?.showAlert(msg: msg)
                }
            }
        }
    }
    
    @objc func verifyWithTouchID() {
        
    }
    
    @objc func verifyAction() {
        
    }
    
    func showOTP() {
        showBottomSheet(controller: otpVC, size: NumberConstant.otpViewHeight, disablePanGesture: true)
        otpVC.delegate = self
    }
    
    func showTransferOTP(isAdvanced: Bool, code: String?) {
        guard let user = NCBShareManager.shared.getUser() else {
            return
        }
        
        if user.softOtpRegistered {
            otpVC.otpLevel = isAdvanced ? .advanced : .basic
            otpVC.advancedCode = code
        }
        
        showBottomSheet(controller: otpVC, size: NumberConstant.otpViewHeight, disablePanGesture: true)
        otpVC.delegate = self
    }
    
    @objc func otpViewDidSelectAccept(_ otp: String) {
        
    }
    
    @objc func otpViewDidSelectResend() {
        
    }
    
    fileprivate func chooseBiometric() {
        if exceedLimit {
            hiddenBiometricView()
        }
    }
    
    func hiddenBiometricView() {
        authenticateView.touchIDBtn.isHidden = true
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
    
    func updateHeightHeaderView(_ height: CGFloat) {
        for constraint in headerView.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = 120 + height
                break
            }
        }
    }
    
}

extension NCBTransactionInformationViewController: NCBOTPViewControllerDelegate {
    
    func otpDidSelectAccept(_ otp: String) {
        otpViewDidSelectAccept(otp)
    }
    
    func otpDidSelectResend() {
        otpViewDidSelectResend()
    }
    
}
