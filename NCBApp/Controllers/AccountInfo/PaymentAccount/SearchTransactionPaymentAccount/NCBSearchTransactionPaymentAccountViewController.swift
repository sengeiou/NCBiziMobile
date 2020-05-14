//
//  NCBSearchTransactionPaymentAccountViewController.swift
//  NCBApp
//
//  Created by Thuan on 7/29/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import RangeSeekSlider

protocol NCBSearchTransactionPaymentAccountViewControllerDelegate {
    func showDate(_ controller: UIViewController)
    func searchDidSelect(params: [String: Any])
}

class NCBSearchTransactionPaymentAccountViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfReceiverName: NewNCBCommonTextField!
    @IBOutlet weak var lbAboutMoney: UILabel!
    @IBOutlet weak var containerRangeSeekSlider: UIView!
    @IBOutlet weak var rangeSeekSlider: RangeSeekSlider! {
        didSet {
            rangeSeekSlider.delegate = self
            rangeSeekSlider.minValue = 0.0
            rangeSeekSlider.maxValue = 100_000_000.0
            rangeSeekSlider.selectedMinValue = 0.0
            rangeSeekSlider.selectedMaxValue = 100_000_000.0
            rangeSeekSlider.minDistance = 0.0
            rangeSeekSlider.maxDistance = 100_000_000.0
            rangeSeekSlider.handleColor = UIColor(hexString: ColorName.mediumBlue.rawValue)
            rangeSeekSlider.handleDiameter = 30.0
            rangeSeekSlider.enableStep = true
            rangeSeekSlider.step = 100_000.0
            rangeSeekSlider.colorBetweenHandles = .blue
            rangeSeekSlider.selectedHandleDiameterMultiplier = 1.3
            rangeSeekSlider.numberFormatter.numberStyle = .currency
            rangeSeekSlider.numberFormatter.locale = Locale(identifier: "vi_VN")
            rangeSeekSlider.numberFormatter.usesGroupingSeparator = true
            rangeSeekSlider.numberFormatter.maximumFractionDigits = 2
        }
    }
    @IBOutlet weak var lbAboutMoneyValue: UILabel!
    @IBOutlet weak var lbFrom: UILabel!
    @IBOutlet weak var lbFromValue: UILabel!
    @IBOutlet weak var lbTo: UILabel!
    @IBOutlet weak var lbToValue: UILabel!
    @IBOutlet weak var reTypeBtn: NCBStatementButton?
    @IBOutlet weak var searchBtn: NCBStatementButton!
    @IBOutlet weak var lbNote: UILabel!
    
    //MARK: Properties
    
    fileprivate var minValue = 0.0
    fileprivate var maxValue = 100000000.0
    var delegate: NCBSearchTransactionPaymentAccountViewControllerDelegate?
    var accountInfoModel: NCBDetailPaymentAccountModel?
    
    fileprivate var startDate: Date?
    fileprivate var endDate = Date()
    fileprivate var isChoosingFrom = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerRangeSeekSlider.drawGradient(startColor: UIColor(hexString: "F7F7F7"), endColor: UIColor(hexString: "EDEDED"))
    }
    
    @IBAction func showFromDateAction(_ sender: Any) {
        isChoosingFrom = true
        showDate()
    }
    
    @IBAction func showToDateAction(_ sender: Any) {
        isChoosingFrom = false
        showDate()
    }
    
}

extension NCBSearchTransactionPaymentAccountViewController {
    
    override func setupView() {
        super.setupView()
        
        lbTitle.font = semiboldFont(size: 14)
        lbTitle.textColor = ColorName.blurNormalText.color
        lbTitle.text = "Tìm kiếm giao dịch"
        
        tfReceiverName.placeholder = "Theo tên người nhận (nếu có)"
        
        lbAboutMoney.font = semiboldFont(size: 12)
        lbAboutMoney.textColor = ColorName.blurNormalText.color
        lbAboutMoney.text = "Khoảng tiền"
        
        lbAboutMoneyValue.font = semiboldFont(size: 12)
        lbAboutMoneyValue.textColor = UIColor(hexString: "959595")
        lbAboutMoneyValue.text = "\(self.minValue.currencyFormatted) - \(self.maxValue.currencyFormatted)"
        
        rangeSeekSlider.handleImage = UIImage(named: "ic_range_handle_image")
        rangeSeekSlider.selectedHandleDiameterMultiplier = 1.0
        rangeSeekSlider.hideLabels = true
        rangeSeekSlider.lineHeight = 0
        
        containerRangeSeekSlider.clipsToBounds = true
        
        lbFrom.font = semiboldFont(size: 12)
        lbFrom.textColor = ColorName.blurNormalText.color
        lbFrom.text = "Từ ngày:"
        
        lbFromValue.font = semiboldFont(size: 12)
        lbFromValue.textColor = UIColor(hexString: "959595")
        lbFromValue.text = "_ _ /_ _ /_ _"
        
        lbTo.font = semiboldFont(size: 12)
        lbTo.textColor = ColorName.blurNormalText.color
        lbTo.text = "Đến ngày:"
        
        lbToValue.font = semiboldFont(size: 12)
        lbToValue.textColor = UIColor(hexString: "959595")
        lbToValue.text = ddMMyyyyFormatter.string(from: endDate)
        
//        reTypeBtn.setTitle("Nhập lại", for: .normal)
//        reTypeBtn.destructiveType()
//        reTypeBtn.addTarget(self, action: #selector(reTypeAction), for: .touchUpInside)
        
        searchBtn.setTitle("Tìm kiếm", for: .normal)
        searchBtn.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        
        lbNote.font = italicFont(size: 12)
        lbNote.textColor = ColorName.amountBlueText.color
        lbNote.textAlignment = .center
        lbNote.text = "Quý khách lưu ý:\nThời gian tìm kiếm tối đa trong 60 ngày"
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
    fileprivate func showDate() {
        let calendar = NCBDayFlowViewController()
        calendar.delegate = self
        calendar.dateSelected = isChoosingFrom ? startDate : endDate
        delegate?.showDate(calendar)
    }
    
    @objc func searchAction() {
        let params: [String: Any] = [
            "cif": NCBShareManager.shared.getUser()?.cif ?? "",
            "receiver": tfReceiverName.text ?? "",
            "fromAmount": minValue,
            "toAmount": maxValue,
            "fromDate": (startDate != nil) ? ddMMyyyyFormatter.string(from: startDate!) : "",
            "toDate": ddMMyyyyFormatter.string(from: endDate),
            "accountNo": accountInfoModel?.acctNo ?? ""
        ]
        delegate?.searchDidSelect(params: params)
    }
    
    @objc func reTypeAction() {
        tfReceiverName.text = ""
        startDate = nil
        lbFromValue.text = "__ /__ /__"
        endDate = Date()
        lbToValue.text = ddMMyyyyFormatter.string(from: endDate)
        rangeSeekSlider.selectedMinValue = 0.0
        rangeSeekSlider.selectedMaxValue = 100_000_000.0
        rangeSeekSlider.layoutSubviews()
        minValue = 0.0
        maxValue = 100000000.0
        lbAboutMoneyValue.text = "\(self.minValue.currencyFormatted) - \(self.maxValue.currencyFormatted)"
    }
    
}

extension NCBSearchTransactionPaymentAccountViewController: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        self.minValue = Double(minValue)
        self.maxValue = Double(maxValue)
        lbAboutMoneyValue.text = "\(self.minValue.currencyFormatted) - \(self.maxValue.currencyFormatted)"
    }
}

extension NCBSearchTransactionPaymentAccountViewController: NCBDayFlowViewControllerDelegate {
    
    func dateDidSelect(_ date: Date) {
        if isChoosingFrom {
            if date > endDate {
                showAlert(msg: "Ngày không hợp lệ")
                return
            }
            
            lbFromValue.text = ddMMyy.string(from: date)
            startDate = date
        } else {
            if let start = startDate, start > date {
                showAlert(msg: "Ngày không hợp lệ")
                return
            }
            
            lbToValue.text = ddMMyy.string(from: date)
            endDate = date
        }
    }
    
}
