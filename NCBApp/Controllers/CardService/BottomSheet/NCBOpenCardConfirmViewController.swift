//
//  NCBOpenCardConfirmViewController.swift
//  NCBApp
//
//  Created by ADMIN on 7/26/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
protocol NCBOpenCardConfirmViewControllerDelegate {
    func faceId()
    func optConfirm()
    func close()
}

class NCBOpenCardConfirmViewController: NCBBaseViewController {
    var delegate: NCBOpenCardConfirmViewControllerDelegate?
    
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
    
    @IBOutlet weak var faceIdView: UIView! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.faceId))
            faceIdView.addGestureRecognizer(gesture)
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
    
    @IBOutlet weak var optConfirmBtn: NCBCommonButton! {
        didSet {
            optConfirmBtn.setTitle("Xác thực OTP", for: .normal)
        }
    }
    
    @IBOutlet weak var faceIdTitleLbl: UILabel! {
        didSet {
            //faceIdTitleLbl.text = "Xác thực bằng FaceID"
            faceIdTitleLbl.font =  regularFont(size: 12.0)
        }
    }
    
    @IBOutlet weak var faceImg: UIImageView! {
        didSet {
            
        }
    }
    
     // MARK: - Func
    @IBAction func optConfirm(_ sender: Any) {
       delegate?.optConfirm()
    }
    
    @IBAction func close(_ sender: Any) {
        delegate?.close()
    }
    
    @objc func faceId(sender : UITapGestureRecognizer) {
        delegate?.faceId()
    }
    
    func drawGradient (_ container: UIView!,fristColor:UIColor!,secondColor:UIColor!, horizontal: Bool){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [fristColor.cgColor, secondColor.cgColor]
        if (horizontal  == true) {
            // Hoizontal - commenting these two lines will make the gradient veritcal
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        }
        // gradient.locations = [0.0 , 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: container.frame.size.width, height: container.frame.size.height)
        container.layer.insertSublayer(gradient, at: 0)
        
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

extension NCBOpenCardConfirmViewController {
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
        
        switch touchMe.biometricType() {
        case .faceID:
            faceIdTitleLbl.text = "Xác thực bằng FaceID"
            faceImg.image =  R.image.ic_faceid()?.withRenderingMode(.alwaysTemplate)
        default:
            faceIdTitleLbl.text = "Xác thực bằng vân tay"
            faceImg.image =  R.image.ic_touchid()?.withRenderingMode(.alwaysTemplate)
        }
        faceImg.tintColor = UIColor(hexString:"0064E1")
  
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
    
}
