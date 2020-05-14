//
//  NCBMailboxDetailViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import WebKit

class NCBMailboxDetailViewController: NCBBaseViewController {
    
    @IBOutlet weak var contentWebView: UIWebView! {
        didSet {
            contentWebView.delegate = self
            contentWebView.backgroundColor = UIColor.clear
            
        }
    }
    
    var mailData:NCBMailboxModel?
    var presenter:NCBMailboxPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
}

extension NCBMailboxDetailViewController {
    
    override func setupView() {
        super.setupView()
        
        presenter = NCBMailboxPresenter()
        presenter?.delegate = self
        
        var htmlString = "<div style = 'padding-left: 30px; padding-right: 30px; padding-top: 30px'>"
        htmlString.append("<p style = 'font-size:12px; font-family: SFProText-Regular; color: 6B6B6B'>\(mailData?.getCreatedDate() ?? "")</p>")
        htmlString.append("<div>\(mailData?.content ?? "")</div>")
        htmlString.append("</div>")
        contentWebView.loadHTMLString(htmlString, baseURL: nil)
        
        var params: [String: Any] = [:]
        params["userName"] = NCBShareManager.shared.getUser()?.username
        params["emailId"] = mailData?.emailId
        
//        SVProgressHUD.show()
        presenter?.updateStatusEmail(params: params)
        
    }
    
    func setupData(data:NCBMailboxModel) {
        self.mailData = data
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Hộp thư")
    }
}

extension NCBMailboxDetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {

    }
}

extension NCBMailboxDetailViewController:NCBMailboxPresenterDelegate {
    func updateStatusEmail(services: String?, error: String?) {
//        SVProgressHUD.dismiss()
//        if let _error = error {
//            showAlert(msg: _error)
//        }else{
//
//        }
    }
}
