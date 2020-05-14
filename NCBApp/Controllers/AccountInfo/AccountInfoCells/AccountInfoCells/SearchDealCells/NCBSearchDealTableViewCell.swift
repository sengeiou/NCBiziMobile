//
//  NCBSearchDealTableViewCell.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import RangeSeekSlider

typealias NCBSearchDealTableViewCellSearchingItem = (String?, Double?, Double?) -> (Void)

class NCBSearchDealTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet fileprivate weak var rangeSliderCurrency: RangeSeekSlider! {
        didSet {
            rangeSliderCurrency.delegate = self
            rangeSliderCurrency.minValue = minValue
            rangeSliderCurrency.maxValue = maxValue
            rangeSliderCurrency.selectedMinValue = 0.0
            rangeSliderCurrency.selectedMaxValue = 10_000_000.0
            rangeSliderCurrency.minDistance = 100_000.0
            rangeSliderCurrency.maxDistance = 10_000_000.0
            rangeSliderCurrency.handleColor = UIColor(hexString: ColorName.mediumBlue.rawValue)
            rangeSliderCurrency.handleDiameter = 30.0
            rangeSliderCurrency.enableStep = true
            rangeSliderCurrency.step = 100_000.0
            rangeSliderCurrency.colorBetweenHandles = .blue
            rangeSliderCurrency.selectedHandleDiameterMultiplier = 1.3
            rangeSliderCurrency.numberFormatter.numberStyle = .currency
            rangeSliderCurrency.numberFormatter.locale = Locale(identifier: "vi_VN")
            rangeSliderCurrency.numberFormatter.usesGroupingSeparator = true
            rangeSliderCurrency.numberFormatter.maximumFractionDigits = 2
        }
    }
    
    @IBOutlet weak var receiverNameLbl: UILabel! {
        didSet {
            receiverNameLbl.text = "Tên người nhận"
            receiverNameLbl.font = UIFont.systemFont(ofSize: 15.0)
        }
    }
    
    @IBOutlet weak var receiverNameTxtF: NCBCommonTextField! {
        didSet {
            receiverNameTxtF.placeholder = "Vui lòng nhập thông tin (nếu có)"
            receiverNameTxtF.font = UIFont.systemFont(ofSize: 15.0)
        }
    }
    
    @IBOutlet weak var fromLbl: UILabel! {
        didSet {
            fromLbl.text = "Từ"
            fromLbl.font = UIFont.systemFont(ofSize: 15.0)
        }
    }
    
    @IBOutlet weak var fromAmountTxtF: NCBCurrencyTextField! {
        didSet {
            fromAmountTxtF.text = Double(minValue).formattedWithDotSeparator
            fromAmountTxtF.placeholder = "Vui lòng nhập số tiền"
            fromAmountTxtF.font = UIFont.systemFont(ofSize: 15.0)
            fromAmountTxtF.addRightText("VND")
            fromAmountTxtF.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var toLbl: UILabel! {
        didSet {
            toLbl.text = "Đến"
            toLbl.font = UIFont.systemFont(ofSize: 15.0)
        }
    }
    
    @IBOutlet weak var toAmountTxtF: NCBCurrencyTextField!  {
        didSet {
            toAmountTxtF.text = Double(maxValue).formattedWithDotSeparator
            toAmountTxtF.placeholder = "Vui lòng nhập số tiền"
            toAmountTxtF.font = UIFont.systemFont(ofSize: 15.0)
            toAmountTxtF.addRightText("VND")
            toAmountTxtF.keyboardType = .numberPad
            
        }
    }
    
    @IBOutlet weak var noteLbl: UILabel! {
        didSet {
            noteLbl.text = """
            Quý khách lưu ý:
            Thời gian tìm kiếm giới hạn trong 60 ngày.
            """
            noteLbl.numberOfLines = 0
            noteLbl.lineBreakMode = .byTruncatingTail
            noteLbl.font = UIFont.systemFont(ofSize: 15.0)
        }
    }
    
    @IBOutlet weak var searchBtn: NCBCommonButton! {
        didSet {
            searchBtn.setTitle("Tìm kiếm", for: .normal)
        }
    }
    
    // MARK: - Properties
    var searchItemCallBack: NCBSearchDealTableViewCellSearchingItem!
    
    var minValue: CGFloat = 0.0{
        willSet {
            if newValue < maxValue {
                self.minValue = newValue
            }
            if newValue > maxValue {
                self.minValue = maxValue - 100_000.0
            }
            fromAmountTxtF.text = Double(minValue).formattedWithDotSeparator
            rangeSliderCurrency.selectedMinValue = self.minValue
            rangeSliderCurrency.layoutSubviews()
        }
        didSet {
            if minValue >= maxValue {
                minValue = maxValue - 100_000.0
            }
            fromAmountTxtF.text = Double(minValue).formattedWithDotSeparator
            rangeSliderCurrency.selectedMinValue = self.minValue
            rangeSliderCurrency.layoutSubviews()
        }
    }
    var maxValue: CGFloat = 10_000_000.0{
        willSet {
            if newValue > minValue && newValue < 10_000_000{
                self.maxValue = newValue
            }
//            if newValue > minValue && newValue > 10_000_000 {
//                self.maxValue = 10_000_000
//            }
            
            toAmountTxtF.text = Double(maxValue).formattedWithDotSeparator
            rangeSliderCurrency.selectedMaxValue = maxValue
            rangeSliderCurrency.layoutSubviews()
        }
        didSet {
            if maxValue <= minValue {
                maxValue = oldValue
            }
            toAmountTxtF.text = Double(maxValue).formattedWithDotSeparator
            rangeSliderCurrency.selectedMaxValue = maxValue
            rangeSliderCurrency.layoutSubviews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fromAmountTxtF.delegate = self
        toAmountTxtF.delegate = self
    }

    // MARK: - Actions
    @IBAction func search(_ sender: UIButton) {
        searchItemCallBack(receiverNameTxtF.text, Double(fromAmountTxtF.text!.removeSpecialCharacter), Double(toAmountTxtF.text!.removeSpecialCharacter))
    }
    
}
extension NCBSearchDealTableViewCell: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        toAmountTxtF.text = String(Double(maxValue).formattedWithDotSeparator)
        fromAmountTxtF.text = String(Double(minValue).formattedWithDotSeparator)
    }
}
extension NCBSearchDealTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case fromAmountTxtF:
            if let fromAmount = fromAmountTxtF.text {
                minValue = CGFloat(Double(fromAmount.removeSpecialCharacter) ?? 0.0)
            }
            rangeSliderCurrency.layoutSubviews()
        case toAmountTxtF:
            if let toAmount = toAmountTxtF.text {
                maxValue = CGFloat(Double(toAmount.removeSpecialCharacter) ?? 10_000_000.0)
            }
            rangeSliderCurrency.layoutSubviews()
        default:
            break
        }
    }
}
