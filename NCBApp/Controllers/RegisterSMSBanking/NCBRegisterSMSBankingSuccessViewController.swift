//
//  NCBRegisterSMSBankingSuccessViewController.swift
//  NCBApp
//
//  Created by Van Dong on 16/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import SwiftyAttributes

class NCBRegisterSMSBankingSuccessViewController: NCBBaseViewController {
    
    @IBOutlet weak var titleNotification: UILabel!
    @IBOutlet weak var content1: UILabel!
    @IBOutlet weak var content2: UILabel!
    @IBOutlet weak var contentView: UIView! {
        didSet{
            contentView.layer.cornerRadius = 15
            //            contentView.clipsToBounds
        }
    }
    
    @IBOutlet weak var btnConfirm: NCBStatementButton!
    
    var acctNo = ""
    var mobile = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
}
extension NCBRegisterSMSBankingSuccessViewController {
    override func setupView() {
        super.setupView()
        
        NCBShareManager.shared.areTrading = false
        
        titleNotification.textColor = UIColor(hexString: "414141")
        titleNotification.font = semiboldFont(size: 14)
        titleNotification.text = "Thông báo"
        
        content1.font = regularFont(size: 14)
        content1.textColor = .black
        
        content2.font = regularFont(size: 14)
        content2.textColor = .black
        
        btnConfirm.setTitle("Thực hiện giao dịch khác", for: .normal)
        btnConfirm.addTarget(self, action: #selector(backCardList), for: .touchUpInside)
        
        content1.text = "Quý khách đã đăng ký thành công dịch vụ SMS banking"
        
        let attr = "Với số tài khoản ".withFont(regularFont(size: 14)!) + acctNo.withFont(semiboldFont(size: 14)!) + " và số điện thoại nhận SMS là ".withFont(regularFont(size: 14)!) + mobile.withFont(semiboldFont(size: 14)!)
        content2.attributedText = attr
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setCustomHeaderTitle("Đăng ký SMS Banking")
    }
    
    @objc func backCardList() {
        gotoSpecificallyController(NCBRegisterSMSBankingViewController.self)
    }
}
