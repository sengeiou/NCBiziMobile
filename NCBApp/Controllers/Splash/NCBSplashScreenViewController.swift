//
//  NCBSplashScreenViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
import ObjectMapper

class NCBSplashScreenViewController: NCBBaseViewController {
    
    var p: NCBSplashPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if UserDefaults.standard.object(forKey: keyMenuIconSaved) != nil {
            let json = UserDefaults.standard.object(forKey: keyMenuIconSaved) as! String
            let dataModels = Mapper<NCBMenuIconModel>().mapArray(JSONString: json) ?? [NCBMenuIconModel]()
            for item in dataModels {
                if item.type == "" {
                    UserDefaults.standard.removeObject(forKey: keyMenuIconSaved)
                    UserDefaults.standard.synchronize()
                    break
                }
            }
        }
    }
    
}

extension NCBSplashScreenViewController {
    
    override func setupView() {
        super.setupView()
        
        UserDefaults.standard.removeObject(forKey: "Flash")
        
        p = NCBSplashPresenter()
        p?.delegate = self
        p?.getAllMessage()
    }
    
    
    func getBannerParams() -> [String : Any] {
        let params: [String : Any] = [
            "banerCode": "",
        ]
        return params
    }
    func getVersionParams() -> [String : Any] {
        let params: [String : Any] = [
            "version": appVersion,
            "os": "IOS"
        ]
        return params
    }
    
    fileprivate func hasVersionUpdate(_ versionInfo: NCBCheckVersionUpdateModel?) -> Bool {
        if versionInfo?.upgrade == true && versionInfo?.mandantory == true {
            showError(msg: "INFO-01".getMessage() ?? "", confirmTitle: "Cập nhật") {
                openAppstore()
            }
            return true
        } else if versionInfo?.upgrade == true && versionInfo?.mandantory == false{
            showAction(msg: "INFO-01".getMessage() ?? "", confirmTitle: "Cập nhật", cancelTitle: "Bỏ qua", confirmHandler: {
                openAppstore()
            }) { [weak self] in
                self?.nextScreen()
            }
            return true
        }
        
        return false
    }
    
    fileprivate func nextScreen() {
        if let _ = UserDefaults.standard.value(forKey: "DidLogin") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let vc = R.storyboard.login.ncbMainLoginViewController() {
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let vc = R.storyboard.splash.ncbActiveServiceViewController() {
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                }
            }
        }
    }
    
}

extension NCBSplashScreenViewController: NCBSplashPresenterDelegate {
    
    func getHotline(services: [String]?, error: String?) {
        p?.getBanner(params: getBannerParams())
        
        if let services = services {
            let phone = services.last
            UserDefaults.standard.set(phone, forKey: keyHotLine)
        }
    }
    
    func getAllMessageCompleted(messages: [NCBMessageModel]?, error: String?) {
//        if let _ = error {
//            return
//        }
        
        p?.getHotline(params: [:])
        
        NCBShareManager.shared.messages = messages
    }
    
    func getBanner(services: [NCBBannerModel]?, error: String?) {
        let banner = services ?? []
        UserDefaults.standard.set(banner.toJSONString(), forKey: "Banner")
        
        for item in banner {
            if item.bannerCode == BannerCodeType.FLASH.rawValue {
                let urlImg = item.urlImg ?? ""
                UserDefaults.standard.setValue(urlImg, forKey: "Flash")
                break
            }
        }
        
        p?.getVersion(params: getVersionParams())

    }
    
    func getVersion(services: NCBCheckVersionUpdateModel?, error: String?) {
        if hasVersionUpdate(services) {
            return
        }
        
        nextScreen()
    }
    
}
