//
//  NCBNewRegisterNormalAcctViewController.swift
//  NCBApp
//
//  Created by ADMIN on 9/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//


import Foundation
protocol NCBNewRegisterNormalAcctViewControllerDelegate {
    func faceId()
    func optConfirm()
    func close()
}

class NCBNewRegisterNormalAcctViewController: NCBBaseViewController {
    var delegate: NCBNewRegisterNormalAcctViewControllerDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.text = "Xác nhận mở tài khoản"
            titleLbl.font = semiboldFont(size: 14.0)
        }
    }
    
    @IBOutlet weak var lineView: UIView! {
        didSet {
        }
    }
    
    @IBOutlet weak var authenticateView: NCBAuthenticateTransactionView! {
        didSet {
        }
    }
    
    @IBOutlet weak var describeLbl: UILabel! {
        didSet {
            describeLbl.font = regularFont(size: 14.0)
        }
    }
    
    @IBOutlet weak var closeBtn: UIButton! {
        didSet {
        }
    }
    
    // MARK: - Func
    @objc func optConfirm() {
        delegate?.optConfirm()
    }
    
    @IBAction func close(_ sender: Any) {
        delegate?.close()
    }
    
    @objc func faceId() {
        delegate?.faceId()
    }
    
    // MARK: - Properties
    var product:NCBRegisterNewServiceProductModel!
    var presenter: NCBRegisterNewAcctPresenter?
    fileprivate let touchMe = BiometricIDAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupData(data:NCBRegisterNewServiceProductModel) {
        product = data
    }
}

extension NCBNewRegisterNormalAcctViewController {
    override func setupView() {
        super.setupView()
        let nameProduct = product.name ?? ""
        describeLbl.text = "Quý khách đang yêu cầu mở "+nameProduct
        authenticateView.otpBtn.addTarget(self, action: #selector(optConfirm), for: .touchUpInside)
        authenticateView.touchIDBtn.addTarget(self, action: #selector(faceId), for: .touchUpInside)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
}
