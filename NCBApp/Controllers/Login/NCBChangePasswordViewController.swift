//
//  NCBChangePasswordViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBChangePasswordViewController: NCBBaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var newPWContainerView: UIView! {
        didSet {
            newPWContainerView.layer.borderColor = UIColor(hexString: "02A9E9").cgColor
            newPWContainerView.layer.borderWidth = 1.0
            newPWContainerView.layer.cornerRadius = 25.0
            newPWContainerView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var retypePWContainerView: UIView! {
        didSet {
            retypePWContainerView.layer.borderColor = UIColor(hexString: "02A9E9").cgColor
            retypePWContainerView.layer.borderWidth = 1.0
            retypePWContainerView.layer.cornerRadius = 25.0
            retypePWContainerView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var newPassWordTxtF: UITextField! {
        didSet {
            newPassWordTxtF.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var retypeNewPasswordTxtF: UITextField! {
        didSet {
            retypeNewPasswordTxtF.isSecureTextEntry = true
            
        }
    }
    @IBOutlet weak var changePasswordBtn: UIButton! {
        didSet {
            changePasswordBtn.layer.cornerRadius = 25.0
            changePasswordBtn.layer.masksToBounds = true
            changePasswordBtn.drawGradient(startColor: UIColor.init(red: 0, green: 192/255, blue: 247/255, alpha: 1), endColor: UIColor.init(red: 0, green: 140/255, blue: 236/255, alpha: 1))
        }
    }
    
    @IBOutlet weak var checkAgreePolicyBtn: UIButton!{
        didSet{
            checkAgreePolicyBtn.setImage(R.image.radio_uncheck(), for: .normal)
            checkAgreePolicyBtn.setImage(R.image.radio_checked(), for: .selected)
            checkAgreePolicyBtn.isSelected = true
        }
    }
    @IBOutlet weak var permissionTxtV: UITextView!{
        didSet{
            setupTextView()
            permissionTxtV.backgroundColor = UIColor.clear
            permissionTxtV.delegate = self
        }
    }
    
    var p: NCBMainLoginPresenter?
    
    override func loadLocalized() {
        titleLbl.text = "Quý khách vui lòng nhập thông tin để đổi mật khẩu lần đầu"
        newPassWordTxtF.attributedPlaceholder = NSAttributedString.init(string: "Nhập mật khẩu mới", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        newPassWordTxtF.textColor = UIColor.white
        retypeNewPasswordTxtF.attributedPlaceholder = NSAttributedString.init(string: "Nhập lại mật khẩu mới", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        retypeNewPasswordTxtF.textColor = UIColor.white
        changePasswordBtn.setTitle("Đổi mật khẩu", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func changePassword(_ sender: UIButton) {
        if newPassWordTxtF.text == "" {
            showAlert(msg: "ACTIVE_CHANGEPASS-1".getMessage() ?? "Quý khách vui lòng nhập mật khẩu mới")
            return
        }
        
        if newPassWordTxtF.text == NCBShareManager.shared.getUser()?.username {
            showAlert(msg: "ACTIVE_CHANGEPASS-4".getMessage() ?? "Mật khẩu không được trùng với tên đăng nhập. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        if !newPassWordTxtF.text!.passwordValid {
            showAlert(msg: "ACTIVE_CHANGEPASS-3".getMessage() ?? "Mật khẩu phải có độ dài tối thiểu 08 ký tự, bao gồm các ký tự chữ và số, có chứa chữ hoa, chữ thường và ký tự đặc biệt.")
            return
        }
        
        if retypeNewPasswordTxtF.text == "" {
            showAlert(msg: "ACTIVE_CHANGEPASS-2".getMessage() ?? "Quý khách vui lòng nhập lại mật khẩu mới")
            return
        }
        
        if newPassWordTxtF.text != retypeNewPasswordTxtF.text{
            showAlert(msg: "ACTIVE_CHANGEPASS-5".getMessage() ?? "Nhập xác nhận mật khẩu mới và Nhập mật khẩu mới không trùng nhau. Quý khách vui lòng kiểm tra lại.")
            return
        }
        
        if !checkAgreePolicyBtn.isSelected {
            showAlert(msg: "Vui lòng chọn Đồng ý với điều kiện điều khoản sử dụng dịch vụ")
            return
        }
        
        SVProgressHUD.show()
        let params: [String : Any] = [
            "username" : NCBShareManager.shared.getUser()?.username ?? "",
            "newpass" : newPassWordTxtF.text!,
            "oldpass" : ""
        ]
        
        p?.updatePass4Active(params: params)
    }
    
    func setupTextView() {
        let fullString = "Tôi đồng ý với các Điều kiện và điều khoản sử dụng dịch vụ \(appName)"
        let attributeSubString = "Điều kiện và điều khoản"
        let range = (fullString as NSString).range(of: attributeSubString)
        let defaultFont = UIFont.systemFont(ofSize: 15)
        let attributedString = NSMutableAttributedString(string: fullString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: R.font.sfProTextRegular(size: 14) ?? defaultFont])
        let url = "http://stackoverflow.com"
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:  UIColor(hexString: "02A9E9"), range: range)
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(hexString: "02A9E9"), NSAttributedString.Key.font: R.font.sfProTextMedium(size: 14) ?? defaultFont], range: range)
        _ = attributedString.setAsLink(textToFind: attributeSubString, linkURL: url)
        permissionTxtV.attributedText = attributedString
    }
}

extension NCBChangePasswordViewController{
    override func setupView() {
        super.setupView()
        
        p = NCBMainLoginPresenter()
        p?.delegate = self
    }
}

extension NCBChangePasswordViewController: NCBMainLoginPresenterDelegate {
    
    func changePassWhenActiveCompleted(success: String?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
            return
        }

        UserDefaults.standard.setValue(true, forKey: "DidLogin")
        NCBShareManager.shared.setUserID(NCBShareManager.shared.getUser()?.username ?? "")
        gotoMain()
    }

}

extension NCBChangePasswordViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if let vc = R.storyboard.login.ncbPermissionAndPolicyViewController() {
            let nav = UINavigationController(rootViewController: vc)
            vc.didAgreePolicyCallback = { [weak self] () -> (Void) in
                self?.checkAgreePolicyBtn.isSelected = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        return false
    }
    
}
