//
//  NCBCreditCardPaymentViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/5/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum CrdCardPaymentType: Int {
    case cardHolder = 0
    case other
}

class NCBCreditCardPaymentViewController: NCBBaseViewController {
    
    @IBOutlet weak var slideBtn: NCBSlideButton!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: Properties
    
    var creditCardInfo: NCBCreditCardModel?
    fileprivate let cardHolderVC = R.storyboard.creditCard.ncbCreditCardPaymentCardHolderViewController()!
    fileprivate let cardOtherVC = R.storyboard.creditCard.ncbCreditCardPaymentOtherCardViewController()!
    
    //MARK: Properties
    
    var type: CrdCardPaymentType = .cardHolder
    
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
    
}

extension NCBCreditCardPaymentViewController {
    
    override func setupView() {
        super.setupView()
        
        slideBtn.setTitle(left: "Chủ thẻ", right: "Số thẻ khác")
        slideBtn.delegate = self
        
        switch type {
        case .cardHolder:
            slideBtn.isOn = true
            showCardHolder()
        case .other:
            slideBtn.isOn = false
            showOtherCardNumber()
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Thanh toán thẻ tín dụng")
    }
    
}

extension NCBCreditCardPaymentViewController {
    
    fileprivate func showCardHolder() {
        for view in containerView.subviews {
            view.removeFromSuperview()
        }
        
        cardHolderVC.creditCardInfo = creditCardInfo
        self.addChild(cardHolderVC)
        containerView.addSubview(cardHolderVC.view)
        cardHolderVC.didMove(toParent: self)
        
        cardHolderVC.view.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    fileprivate func showOtherCardNumber() {
        for view in containerView.subviews {
            view.removeFromSuperview()
        }
        
        self.addChild(cardOtherVC)
        containerView.addSubview(cardOtherVC.view)
        cardOtherVC.didMove(toParent: self)
        
        cardOtherVC.view.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
}

extension NCBCreditCardPaymentViewController: NCBSlideButtonDelegate {
    
    func didChangeTab(_ isOn: Bool) {
        removeBottomSheet()
        if !isOn {
            showOtherCardNumber()
        } else {
            showCardHolder()
        }
    }
    
}
