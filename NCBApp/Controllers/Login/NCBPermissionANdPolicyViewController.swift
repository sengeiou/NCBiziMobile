//
//  NCBPermissionAndPolicyViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

typealias NCBPermissionAndPolicyViewControllerCallback = () -> (Void)

class NCBPermissionAndPolicyViewController: NCBBaseViewController {

    @IBOutlet weak var webView: UIWebView! {
        didSet {
            webView.delegate = self
            webView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var agreeBtn: UIButton! {
        didSet {
            agreeBtn.setTitle("Tôi đồng ý", for: .normal)
            agreeBtn.layer.cornerRadius = 25.0
            agreeBtn.layer.masksToBounds = true
            agreeBtn.drawGradient(startColor: UIColor.init(red: 0, green: 192/255, blue: 247/255, alpha: 1), endColor: UIColor.init(red: 0, green: 140/255, blue: 236/255, alpha: 1))
        }
    }
    
    //MARK: Properties
    
    var didAgreePolicyCallback: NCBPermissionAndPolicyViewControllerCallback!
    fileprivate var p: NCBPermissionAndPolicyPresenter?
    var code = "NCB"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.show()
        p?.getTermOfUse(code: code)
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func backAction(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onAgree(_ sender: Any) {
        didAgreePolicyCallback()
        dismiss(animated: true, completion: nil)
    }
}

extension NCBPermissionAndPolicyViewController {
    
    override func setupView() {
        super.setupView()
        
        p = NCBPermissionAndPolicyPresenter()
        p?.delegate = self
        
        if code == "IZI" {
            setCustomHeaderTitle("Điều khoản sử dụng tài khoản IZI")
        } else {
            setCustomHeaderTitle("Điều khoản sử dụng \(appName)")
        }
    }
    
    fileprivate func displayContent(_ contents: [NCBTermOfUseModel]) {
        var htmlString = "<div style = 'padding-left: 30px; padding-right: 30px; padding-top: 30px'>"
        for content in contents {
            htmlString.append("<p style = 'font-size:14px; font-family: SFProDisplay-Bold; color: 000000'>\(content.provisionName ?? "")</p>")
            htmlString.append(content.provisionLink ?? "")
            htmlString.append("</br>")
        }
        htmlString.append("</div>")
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
}

extension NCBPermissionAndPolicyViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
}

extension NCBPermissionAndPolicyViewController: NCBPermissionAndPolicyPresenterDelegate {
    
    func getTermOfUseCompleted(contents: [NCBTermOfUseModel]?, error: String?) {
//        SVProgressHUD.dismiss()
        
        if let error = error {
            SVProgressHUD.dismiss()
            showAlert(msg: error)
            return
        }
        
        displayContent(contents ?? [])
    }
    
}
