//
//  NCBOnlinePaymentVerifyViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBOnlinePaymentVerifyViewControllerDelegate {
    func onlinePaymentVerifyOTP()
    func onlinePaymentVerifyTouchID(_ touchMe: BiometricIDAuth)
    func onlinePaymentCancel()
}

class NCBOnlinePaymentVerifyViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var acceptBtn: NCBCommonButton!
    @IBOutlet weak var cancelBtn: NCBCommonButton!
    @IBOutlet weak var authenticateView: NCBAuthenticateTransactionView!
    
    //MARK: Properties
    
    fileprivate let touchMe = BiometricIDAuth()
    fileprivate var strTitle: String?
    fileprivate var strDesc: String?
    var delegate: NCBOnlinePaymentVerifyViewControllerDelegate?
    var registeredECOM: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeAction(_ sender: Any) {
        delegate?.onlinePaymentCancel()
    }
    
}

extension NCBOnlinePaymentVerifyViewController {
    
    override func setupView() {
        super.setupView()
        
        acceptBtn.setTitle("Đồng ý", for: .normal)
        cancelBtn.setTitle("Huỷ", for: .normal)
        
        lbTitle.font = semiboldFont(size: 14)
        lbTitle.textColor = ColorName.blurNormalText.color
        
        lbDesc.font = regularFont(size: 14)
        lbDesc.textColor = ColorName.blackText.color
        
        authenticateView.otpBtn.addTarget(self, action: #selector(verifyAction), for: .touchUpInside)
        acceptBtn.addTarget(self, action: #selector(verifyAction), for: .touchUpInside)
        authenticateView.touchIDBtn.addTarget(self, action: #selector(verifyTouchID), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        if registeredECOM {
            lbTitle.text = "Huỷ đăng ký dịch vụ"
            lbDesc.text = "Quý khách muốn thực hiện huỷ đăng ký dịch vụ thanh toán trực tuyến?"
            acceptBtn.isHidden = false
            cancelBtn.isHidden = false
            authenticateView.isHidden = true
        } else {
            lbDesc.text = "Quý khách muốn thực hiện đăng ký dịch vụ thanh toán trực tuyến?"
            lbTitle.text = "Đăng ký dịch vụ"
            acceptBtn.isHidden = true
            cancelBtn.isHidden = true
            authenticateView.isHidden = false
        }
        
        if let title = strTitle, let desc = strDesc {
            lbTitle.text = title
            lbDesc.text = desc
        }
    }
    
    func setViewForAutoDebtDeduction(title: String, desc: String) {
        strTitle = title
        strDesc = desc
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
    @objc fileprivate func verifyAction() {
        delegate?.onlinePaymentVerifyOTP()
    }
    
    @objc fileprivate func verifyTouchID() {
        delegate?.onlinePaymentVerifyTouchID(touchMe)
    }
    
    @objc fileprivate func cancelAction() {
        delegate?.onlinePaymentCancel()
    }
    
}
