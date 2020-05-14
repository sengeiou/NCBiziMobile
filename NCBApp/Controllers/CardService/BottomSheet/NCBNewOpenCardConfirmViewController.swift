//
//  NCBNewOpenCardConfirmViewController.swift
//  NCBApp
//
//  Created by ADMIN on 9/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
protocol NCBNewOpenCardConfirmViewControllerDelegate {
    func faceId()
    func optConfirm()
    func close()
}

class NCBNewOpenCardConfirmViewController: NCBBaseViewController {
    var delegate: NCBNewOpenCardConfirmViewControllerDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.text = "Xác nhận mở thẻ"
            titleLbl.font = semiboldFont(size: 14.0)
        }
    }

    @IBOutlet weak var lineView: UIView! {
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
    @IBOutlet weak var  authenticateView: NCBAuthenticateTransactionView! {
        didSet {
        }
    }
    
    // MARK: - Func
   @objc func optConfirm(_ sender: Any) {
        delegate?.optConfirm()
    }
    
    @IBAction func close(_ sender: Any) {
        delegate?.close()
    }
    
    @objc func faceId() {
        delegate?.faceId()
    }

    // MARK: - Properties
    var cardModel: NCBCardModel!
    var cardActiveType =  CardServiceActiveType.none
    fileprivate let touchMe = BiometricIDAuth()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupData(data:NCBCardModel) {
        cardModel = data
    }
}

extension NCBNewOpenCardConfirmViewController {
    override func setupView() {
        super.setupView()
        let cardCodeConvert = cardModel.getCardNo()
        let cardTypeName = cardModel.getCardTypeName()
        cardActiveType =  cardModel.getActiveType()
        if cardActiveType == CardServiceActiveType.open{
            describeLbl.text = "Quý khách đang yêu cầu mở khoá thẻ "+cardTypeName+" "+cardCodeConvert+". Thẻ đã khoá sẽ không thực hiện được giao dịch tài chính."
        }else{
            describeLbl.text = "Quý khách đang yêu cầu kích hoạt thẻ "+cardTypeName+" "+cardCodeConvert+". Thẻ đã khoá sẽ không thực hiện được giao dịch tài chính."
        }
        authenticateView.otpBtn.addTarget(self, action: #selector(optConfirm), for: .touchUpInside)
        authenticateView.touchIDBtn.addTarget(self, action: #selector(faceId), for: .touchUpInside)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
    
}
