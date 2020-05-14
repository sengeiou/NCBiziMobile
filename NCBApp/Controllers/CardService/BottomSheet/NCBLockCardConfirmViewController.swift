//
//  NCBLockCardConfirmViewController.swift
//  NCBApp
//
//  Created by ADMIN on 7/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

protocol NCBLockCardConfirmViewControllerDelegate {
    func close()
    func lock()
    func refuse()
}

class NCBLockCardConfirmViewController: NCBBaseViewController {
    var delegate: NCBLockCardConfirmViewControllerDelegate?
    
    // MARK: - Outlets

    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
           titleLbl.text = "Xác nhận khoá thẻ"
           titleLbl.font = semiboldFont(size: 14.0)
        }
    }
    @IBOutlet weak var closeBtn: UIButton! {
        didSet {
            
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
    
    @IBOutlet weak var refuseBtn: NCBStatementButton! {
        didSet {
            refuseBtn.setTitle("Từ chối", for: .normal)
            refuseBtn.backgroundColor = UIColor(hexString: "9EBBD4")
        }
    }
    @IBOutlet weak var lockBtn: NCBStatementButton! {
        didSet {
            lockBtn.setTitle("Khoá thẻ", for: .normal)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        delegate?.close()
    }
    
    @IBAction func refuse(_ sender: Any) {
        delegate?.refuse()
    }
    
    @IBAction func lock(_ sender: Any) {
        delegate?.lock()
    }
    
    // MARK: - Properties
    var cardModel: NCBCardModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupData(data:NCBCardModel) {
        cardModel = data
    }
   
}

extension NCBLockCardConfirmViewController {
    override func setupView() {
        super.setupView()
        let cardCodeConvert = cardModel.getCardNo()
        let cardTypeName = cardModel.getCardTypeName()
        describeLbl.text = "Quý khách đang yêu cầu khoá thẻ "+cardTypeName+" "+cardCodeConvert+". Thẻ đã khoá sẽ không thực hiện được giao dịch tài chính."
        
    }
    
    override func loadLocalized() {
        super.loadLocalized()
       
    }
    
    
}




