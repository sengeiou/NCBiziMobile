//
//  NCBUserGuideViewController.swift
//  NCBApp
//
//  Created by Thuan on 10/30/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

class NCBUserGuideViewController: NCBBaseViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
}

extension NCBUserGuideViewController {
    
    override func setupView() {
        super.setupView()
        
        webView.delegate = self
        
        SVProgressHUD.show()
        if let url = URL(string: "https://www.ncb-bank.vn/Shareholders/HuongDan/Guide_NCB_iziMobile.pdf") {
            webView.loadRequest(URLRequest(url: url))
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Hướng dẫn sử dụng")
    }
    
}
extension NCBUserGuideViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
}
