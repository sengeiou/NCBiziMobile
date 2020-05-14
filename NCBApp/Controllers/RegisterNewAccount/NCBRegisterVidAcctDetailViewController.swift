//
//  NCBRegisterVidAcctDetailViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
class NCBRegisterVidAcctDetailViewController: NCBBaseSourceAccountViewController {
    
    @IBOutlet weak var newAccTitleLbl: UILabel! {
        didSet {
            newAccTitleLbl.font = regularFont(size: 12.0)
            newAccTitleLbl.textColor = UIColor(hexString: ColorName.holderText.rawValue)
            newAccTitleLbl.text = "Số tài khoản mở mới"
        }
    }
    
    @IBOutlet weak var newAccLbl: UILabel! {
        didSet {
            newAccLbl.font = semiboldFont(size: 14)
            newAccLbl.textColor = UIColor(hexString: ColorName.normalText.rawValue)
        
        }
    }
    
    @IBOutlet weak var accLineView: UIView! {
        didSet {
         accLineView.backgroundColor = UIColor(hexString: "EDEDED")
        }
    }
    
    @IBOutlet weak var accClassTitleLbl: UILabel! {
        didSet {
            accClassTitleLbl.font = regularFont(size: 12.0)
            accClassTitleLbl.textColor = UIColor(hexString: ColorName.holderText.rawValue)
            accClassTitleLbl.text = "Loại tài khoản số "
        }
    }
    
    @IBOutlet weak var accClassLbl: UILabel! {
        didSet {
            accClassLbl.font = semiboldFont(size: 14)
            accClassLbl.textColor = UIColor(hexString: ColorName.normalText.rawValue)
        }
    }
    @IBOutlet weak var peeLbl: UILabel! {
        didSet {
            peeLbl.font = regularFont(size: 12.0)
            peeLbl.textColor = UIColor(hexString: ColorName.holderText.rawValue)
        }
    }
    
    @IBOutlet weak var classLineView: UIView! {
        didSet {
           classLineView.backgroundColor = UIColor(hexString: "EDEDED")
        }
    }
    
   
    @IBOutlet weak var continueBtn: UIButton! {
        didSet {
           continueBtn.setTitle("Tiếp tục", for: .normal)
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
    
        if let vc = R.storyboard.registerNewAcct.ncbRegisterNewAcctVerifyViewController() {
            vc.setupData(product: product, tailNumberModel: tailNumberModel, returnNumberModel: returnNumberModel, accountName: sourceAccountView?.lbSourceAccountValue.text ?? "")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    var isCheck = true
    var accountName = ""
    var tailNumberModel:NCBTailNumberModel!
    var returnNumberModel: NCBReturnNumberModel!
    var product:NCBRegisterNewServiceProductModel!
    var presenter: NCBRegisterNewAcctPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func showNavigationBarBackground() -> Bool {
        return true
    }
}

extension NCBRegisterVidAcctDetailViewController {
    
    override func setupView() {
        super.setupView()
        newAccLbl.text = returnNumberModel.accountNo
        accClassLbl.text = tailNumberModel.name
        let fee = returnNumberModel.serviceFee ?? 0.0
        peeLbl.text = "Phí dịch vụ: "+fee.currencyFormatted ?? ""
        accountName = sourceAccountView?.lbAccountName.text ?? ""
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Đăng ký mở tài khoản")
    }
    func setData(product:NCBRegisterNewServiceProductModel,tailNumber:NCBTailNumberModel,newAcc:NCBReturnNumberModel ){
        self.tailNumberModel = tailNumber
        self.returnNumberModel = newAcc
        self.product = product
    }
}
