//
//  NCBOpenIZIAccountStep1ViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/29/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SwiftyAttributes
import MessageUI

class NCBOpenIZIAccountStep1ViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tfName: NewNCBCommonTextField!
    @IBOutlet weak var tfCMT: NewNCBCommonTextField!
    @IBOutlet weak var radioCheckBtn: UIButton!
    @IBOutlet weak var lbTerms: UILabel!
    @IBOutlet weak var lbNote: UILabel!
    @IBOutlet weak var continueBtn: NCBCommonButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
}

extension NCBOpenIZIAccountStep1ViewController: MFMessageComposeViewControllerDelegate {
    
    override func setupView() {
        super.setupView()
        
        radioCheckBtn.setImage(R.image.radio_uncheck(), for: .normal)
        radioCheckBtn.setImage(R.image.radio_checked(), for: .selected)
        radioCheckBtn.isSelected = true
        radioCheckBtn.addTarget(self, action: #selector(termCheck), for: .touchUpInside)
        
        tfCMT.delegate = self
        
        lbNote.font = regularFont(size: 12)
        lbNote.textColor = ColorName.blurNormalText.color
        lbNote.text = "ĐẶC ĐIỂM VÀ LỢI ÍCH\n\nNhanh chóng, tiện lợi do khách hàng chỉ nhập thông tin mở tài khoản\n\nLinh hoạt, đa dạng hình thức chuyển tiền và không giới hạn số tiền, số lần chuyển đến.\n\nCập nhật nhanh chóng: Tài khoản IZI ngay sau khi mở, được tích hợp SMS Banking và Mobile Banking. Khi biến động số dư, Khách hàng được thông báo ngay qua tin nhắn hoặc tra cứu trên Mobile Banking.\n\nAn toàn cao: Khách hàng không được phép rút/sử dụng số tiền chuyển đến cho đến khi ra quầy giao dịch của NCB để bổ sung thông tin, hoàn tất thủ tục."
        
        lbTerms.font = regularFont(size: 12)
        lbTerms.textColor = ColorName.blurNormalText.color
        lbTerms.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showTerms))
        lbTerms.addGestureRecognizer(gesture)
        
        let attr = "Tôi đồng ý với các ".withFont(regularFont(size: 12)!) + "Điều kiện và điều khoản".withFont(semiboldFont(size: 12)!).withTextColor(UIColor(hexString: "0083DC")) + "\nsử dụng dịch vụ tài khoản vô danh IZI".withFont(regularFont(size: 12)!)
        lbTerms.attributedText = attr
        
        continueBtn.addTarget(self, action: #selector(continueAction), for: .touchUpInside)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setCustomHeaderTitle("Mở tài khoản IZI")
        
        tfName.placeholder = "Họ và tên"
        tfCMT.placeholder = "Số CMT/Hộ chiếu/CCCD"
        continueBtn.setTitle("Tiếp tục", for: .normal)
    }
    
    @objc fileprivate func showTerms() {
        if let vc = R.storyboard.login.ncbPermissionAndPolicyViewController() {
            let nav = UINavigationController(rootViewController: vc)
            vc.code = "IZI"
            vc.didAgreePolicyCallback = { [weak self] () -> (Void) in
                self?.radioCheckBtn.isSelected = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func termCheck() {
        radioCheckBtn.isSelected = !radioCheckBtn.isSelected
    }
    
    @objc fileprivate func continueAction() {
        if tfName.text!.isEmpty || tfCMT.text!.isEmpty {
            showAlert(msg: "Quý khách vui lòng nhập đầy đủ thông tin")
            return
        }
        
        if !radioCheckBtn.isSelected {
            showAlert(msg: "Vui lòng chọn Đồng ý với điều kiện điều khoản sử dụng dịch vụ")
            return
        }
        
        var name = ""
        let data = tfName.text!.lowercased().replacingOccurrences(of: "đ", with: "d").data(using: .ascii, allowLossyConversion: true)
        if let data = data {
            name = String(data: data, encoding: .ascii) ?? ""
        }
        
        let content = "NCB IZI \(tfCMT.text ?? "") \(name.uppercased().replacingOccurrences(of: " ", with: ""))"
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = content
            controller.recipients = ["8149"]
            controller.messageComposeDelegate = self
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        } else {
            showAlert(msg: "Your device not support message compose")
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        if result == MessageComposeResult.sent {
            showError(msg: "Quý khách đã gửi thành công yêu cầu mở tài khoản IZI. Chúng tôi sẽ liên hệ với bạn trong thời gian sớm nhất") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension NCBOpenIZIAccountStep1ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
    
}
