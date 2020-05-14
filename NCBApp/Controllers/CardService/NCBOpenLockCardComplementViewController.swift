//
//  NCBOpenLockCardComplementViewController.swift
//  NCBApp
//
//  Created by ADMIN on 7/26/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum CardComplementType: String {
    case openCard
    case lockCard
    case activeCard
    case reissueCard
    case resupplyPIN
}

class NCBOpenLockCardComplementViewController: NCBBaseVerifyTransactionViewController  {
    
    // MARK: - Outlets
    @IBOutlet weak var cardCodeLbl: UILabel! {
        didSet {
            cardCodeLbl.font = boldFont(size: 18.0)
            cardCodeLbl.textColor = UIColor.white
            
        }
    }
    
    @IBOutlet weak var validfromLbl: UILabel! {
        didSet {
            validfromLbl.font = semiboldFont(size: 10.0)
            validfromLbl.textColor = UIColor.white
            
        }
    }
    
    @IBOutlet weak var validDateLbl: UILabel! {
        didSet {
            validDateLbl.font = semiboldFont(size: 10.0)
            validDateLbl.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var validfromTitleLbl: UILabel! {
        didSet {
            validfromTitleLbl.font = semiboldFont(size: 10.0)
            validfromTitleLbl.textColor = UIColor.black
            validfromTitleLbl.text = "VALID FROM"
            //validfromTitleLbl.textColor = UIColor(hexString: "A97E2C")
            validfromTitleLbl.textColor = UIColor.white
            
        }
    }
    
    @IBOutlet weak var validDateTitleLbl: UILabel! {
        didSet {
            validDateTitleLbl.font = semiboldFont(size: 10.0)
            validDateTitleLbl.textColor = UIColor.white
            validDateTitleLbl.text = "VALID THRU"
            //validDateTitleLbl.textColor = UIColor(hexString: "A97E2C")
            validDateTitleLbl.textColor = UIColor.white
        }
    }
    @IBOutlet weak var   userCardNameLbl: UILabel! {
        didSet {
            userCardNameLbl.font = semiboldFont(size: 14.0)
            userCardNameLbl.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var  cardImageView: UIImageView! {
        didSet {
            cardImageView.layer.borderColor = UIColor.clear.cgColor
            cardImageView.layer.masksToBounds = true
            cardImageView.layer.shadowColor = UIColor.gray.cgColor
            cardImageView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            cardImageView.layer.shadowRadius = 2.0
            cardImageView.layer.shadowOpacity = 1.0
        }
    }
    
    @IBOutlet weak var  cardView: UIView! {
        didSet {
            cardView.layer.cornerRadius = 10
            cardView.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var   noteLbl: UILabel! {
        didSet {
            noteLbl.font = semiboldFont(size: 12.0)
            noteLbl.textColor = UIColor.white
            noteLbl.text = "Quý khách đã mở khoá thẻ thành công"
        }
    }
    
    @IBOutlet weak var  backBtn: NCBStatementButton! {
        didSet {
          backBtn.setTitle("Quay về danh sách thẻ", for: .normal)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        switch type {
        case .openCard:
             self.gotoSpecificallyController(NCBOpenLockCardViewController.self)
            break
        case .lockCard:
            self.gotoSpecificallyController(NCBOpenLockCardViewController.self)
            break
        case .activeCard:
            self.gotoSpecificallyController(NCBOpenLockCardViewController.self)
            break
        case .reissueCard:
            self.gotoSpecificallyController(NCBCardReissueViewController.self)
            break
        case .resupplyPIN:
            self.gotoSpecificallyController(NCBResupplyPINViewController.self)
            break
        }
        
    }
    
    // MARK: - Properties
    var cardData: NCBCardModel?
    var type = CardComplementType.openCard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = nil
        
    }
    
    func setupData(data:NCBCardModel) {
        cardData = data
    }
    func setupTypeComplement(type:CardComplementType) {
        self.type = type
    }
    
    
    func drawGradient (_ container: UIView!, horizontal: Bool){
        let gradient: CAGradientLayer = CAGradientLayer()
        let fristColor: UIColor = UIColor(hexString: "0048AD")
        let secondColor: UIColor = UIColor(hexString:"0998E3")
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
}

extension NCBOpenLockCardComplementViewController {
    override func setupView() {
        super.setupView()
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        let cardCodeConvert = cardData?.getCardNo()
        cardCodeLbl.text = cardCodeConvert
        validfromLbl!.text = converDate(str: cardData?.ctrDate! ?? "")
        validDateLbl!.text = converDate(str: cardData?.lstDate! ?? "")
        userCardNameLbl!.text = cardData?.cardname
        cardImageView.image = UIImage(named: "ic_cardService_default.pdf")
        //cardImageView.image = UIImage(named: item.parCardProduct!.fileName!)
    
        switch type {
        case .openCard:
             setHeaderTitle("Mở khoá/kích hoạt thẻ")
             noteLbl.text = "Quý khách đã mở khoá thẻ thành công"
            break
        case .lockCard:
             setHeaderTitle("Mở khoá/kích hoạt thẻ")
             noteLbl.text = "Quý khách đã khoá thẻ thành công"
            break
        case .activeCard:
             setHeaderTitle("Kích hoạt thẻ")
             noteLbl.text = "Quý khách đã kích hoạt thẻ thành công"
            break
        case .reissueCard:
             setHeaderTitle("Đăng ký phát hành thẻ")
            noteLbl.text = "Quý khách đã phát hành lại thẻ thành công"
            break
        case .resupplyPIN:
            setHeaderTitle("Cấp lại PIN thẻ")
            noteLbl.text = "Quý khách đã cấp lại PIN thẻ thành công"
            break
        default:
            break
        }
        
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        //setHeaderTitle("Mở khoá/kích hoạt thẻ")
        drawGradient(self.view, horizontal: false)
    }
    
    func converDate(str:String) ->String  {
        let date = yyyyMMdd.date(from: str)
        if let date = date {
            return MMyy.string(from: date)
        }
        return ""
    }
}

