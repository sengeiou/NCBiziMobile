//
//  NCBCardCompletedServiceViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum CardCompletedServiceType: Int {
    case registerEcom = 0
    case unregisterEcom
    case lockCard
    case openCard
    case activeCard
    case reissueCard
    case resupplyPIN
    case registerAutoDebtDeduction
    case updateAutoDebtDeduction
    case unregisterAutoDebtDeduction
}

class NCBCardCompletedServiceViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var backBtn: NCBStatementButton!
    
    //MARK: Properties
    
    fileprivate var card: NCBCardModel?
    fileprivate var type: CardCompletedServiceType = .registerEcom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NCBShareManager.shared.areTrading = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
}

extension NCBCardCompletedServiceViewController {
    
    override func setupView() {
        super.setupView()
        
        commonCreditCardInfoView?.setData(card)
        
        lbDesc.font = semiboldFont(size: 12)
        lbDesc.textColor = UIColor.white
        
        backBtn.setTitle("Quay về danh sách thẻ", for: .normal)
        backBtn.addTarget(self, action: #selector(backCardList), for: .touchUpInside)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        switch type {
        case .registerEcom:
            setHeaderTitle("Dịch vụ thanh toán trực tuyến")
            lbDesc.text = "Quý khách đã đăng ký thành công dịch vụ thanh toán trực tuyến"
        case .openCard:
            setHeaderTitle("Mở khoá/Kích hoạt thẻ")
            lbDesc.text = "Quý khách đã mở khoá thẻ thành công"
        case .lockCard:
            setHeaderTitle("Mở khoá/Kích hoạt thẻ")
            lbDesc.text = "Quý khách đã khoá thẻ thành công"
        case .activeCard:
            setHeaderTitle("Mở khoá/Kích hoạt thẻ")
            lbDesc.text = "Quý khách đã kích hoạt thẻ thành công"
        case .reissueCard:
            setHeaderTitle("Đăng ký phát hành lại thẻ")
            lbDesc.text = "Quý khách đã Đăng ký phát hành lại thẻ  thành công"
        case .resupplyPIN:
            setHeaderTitle("Cấp lại PIN thẻ")
            lbDesc.text = "Quý khách đã Cấp lại PIN thẻ thành công"
        case .unregisterEcom:
            setHeaderTitle("Dịch vụ thanh toán trực tuyến")
            lbDesc.text = "Quý khách đã huỷ đăng ký thành công dịch vụ thanh toán trực tuyến"
        case .registerAutoDebtDeduction:
            setHeaderTitle("Đăng ký trích nợ tự động")
            lbDesc.text = "Quý khách đã đăng ký trích nợ tự động thành công"
        case .updateAutoDebtDeduction:
            setHeaderTitle("Thay đổi thông tin trích nợ")
            lbDesc.text = "Quý khách đã thay đổi thông tin trích nợ thành công"
        case .unregisterAutoDebtDeduction:
            setHeaderTitle("Huỷ dịch vụ trích nợ tự động")
            lbDesc.text = "Quý khách đã huỷ dịch vụ thành công"
        }
    }
    
    @objc func backCardList() {
        gotoSpecificallyController(NCBCardListViewController.self)
    }
    
    func setData(_ card: NCBCardModel?, type: CardCompletedServiceType) {
        self.card = card
        self.type = type
    }
    
}
