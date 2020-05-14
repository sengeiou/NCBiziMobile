//
//  NCBInterbankTransferViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBInterbankTransferViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var slideBtn: NCBSlideButton!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: Properties
    
    fileprivate let fastTransferVC = R.storyboard.transfer.ncbInterbankTransferChildViewController()!
    fileprivate let normalTransferVC = R.storyboard.transfer.ncbInterbankTransferChildViewController()!
    var interbankType: InterbankTransferType = .fast
    var beneficiary: NCBBeneficiaryModel?
    var referPaymentAccount: NCBDetailPaymentAccountModel?
    var mofinTransferData: MofinTransferDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func backAction(sender: UIButton) {
        NCBShareManager.shared.areTrading = false
        self.navigationController?.popViewController(animated: true)
    }
    
    override func openFunctionFromURLScheme(_ notification: Notification) {
        let url = notification.object as? String
        let data = getTransferDataFromUrl(url)
        if data?.bankcode != StringConstant.ncbCode {
            mofinTransferData = data
            showFastTransfer()
            disabledSlideButton()
        } else {
            if let vc = R.storyboard.transfer.ncbInternalTransferViewController() {
                vc.mofinTransferData = data
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
}

extension NCBInterbankTransferViewController {
    
    override func setupView() {
        super.setupView()
        
        slideBtn.setTitle(left: "Chuyển nhanh", right: "Chuyển thường")
        slideBtn.delegate = self
        
        switch interbankType {
        case .fast:
            showFastTransfer()
        case .normal:
            showNormalTransfer()
        }

        if let _ = mofinTransferData {
            disabledSlideButton()
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("CHUYỂN KHOẢN LIÊN NGÂN HÀNG")
    }
    
}

extension NCBInterbankTransferViewController {
    
    fileprivate func showFastTransfer() {
        slideBtn.isOn = true
        interbankType = .fast
        for view in containerView.subviews {
            view.removeFromSuperview()
        }
        
        self.addChild(fastTransferVC)
        containerView.addSubview(fastTransferVC.view)
        fastTransferVC.didMove(toParent: self)
        fastTransferVC.reloadView(interbankType, beneficiary: beneficiary, referPaymentAccount: referPaymentAccount, mofin: mofinTransferData)
        
        fastTransferVC.view.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    fileprivate func showNormalTransfer() {
        slideBtn.isOn = false
        interbankType = .normal
        for view in containerView.subviews {
            view.removeFromSuperview()
        }
        
        self.addChild(normalTransferVC)
        containerView.addSubview(normalTransferVC.view)
        normalTransferVC.didMove(toParent: self)
        normalTransferVC.reloadView(interbankType, beneficiary: beneficiary, referPaymentAccount: referPaymentAccount, mofin: nil)
        
        normalTransferVC.view.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }

    fileprivate func disabledSlideButton() {
        slideBtn.disabled()
    }
}

extension NCBInterbankTransferViewController: NCBSlideButtonDelegate {
    
    func didChangeTab(_ isOn: Bool) {
        removeBottomSheet()
        if !isOn {
            showNormalTransfer()
        } else {
            showFastTransfer()
        }
    }
    
}
