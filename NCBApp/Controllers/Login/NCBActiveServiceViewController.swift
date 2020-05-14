//
//  NCBActiveServiceViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBActiveServiceViewController: NCBBaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var hasAccountBtn: NCBCommonButton! {
        didSet {
            hasAccountBtn.drawGradient(startColor: UIColor(hexString: "00C0F7"), endColor: UIColor(hexString: "008CEC"))
        }
    }
    @IBOutlet weak var noAccountBtn: NCBCommonButton! {
        didSet {
            noAccountBtn.drawGradient(startColor: UIColor(hexString: "00C0F7"), endColor: UIColor(hexString: "008CEC"))
        }
    }
    @IBOutlet weak var viButton: UIButton!
    @IBOutlet weak var enButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    //MARK: Properties
    
    var floatMenu = Floaty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func setupView() {
        super.setupView()
        
//        setupLoginBackground()
        
        let langCode = NCBLocalization.shared().getLangCode()
        if langCode.hasPrefix("vi") {
            viButton.titleLabel?.font = boldFont(size: 12)
            enButton.titleLabel?.font = lightFont(size: 12)
        }else {
            viButton.titleLabel?.font = lightFont(size: 12)
            enButton.titleLabel?.font = boldFont(size: 12)
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        questionLabel.text = "Chào mừng bạn đến với \(appName)"
        hasAccountBtn.setTitle(localized("Bạn là khách hàng NCB"), for: .normal)
        noAccountBtn.setTitle(localized("Bạn là khách hàng mới"), for: .normal)
        setupMenu()
    }
    
    func setupMenu() {
        floatMenu.removeFromSuperview()
        floatMenu = Floaty()
        
        floatMenu.hasShadow = false
        floatMenu.fabDelegate = self
        floatMenu.size = 42
        floatMenu.buttonImage = UIImage(named: "ic_login.pdf")
        floatMenu.buttonImageFocus = UIImage(named: "ic_login_focus.pdf")
        floatMenu.sticky = false
        
        
        let dichVuItem = FloatyItem()
        dichVuItem.hasShadow = false
        dichVuItem.icon = UIImage(named: "ic_registerNewService")
        dichVuItem.imageSize = CGSize(width: 42, height: 42)
        dichVuItem.itemBackgroundColor = UIColor.clear
        // item.backgroundColor = UIColor.init(red: 0, green: 189/255, blue: 252/255, alpha: 1)
        dichVuItem.title = localized("login.menu.register.service")
        dichVuItem.titleLabel.font = regularFont(size: 14)
        dichVuItem.titleLabel.textAlignment = .right
        
        dichVuItem.handler = { dichVuItem in
            self.floatMenu.close()
            self.showServiceRegister()
        }
        floatMenu.addItem(item: dichVuItem)
        
        let lienHeItem = FloatyItem()
        lienHeItem.hasShadow = false
        lienHeItem.icon = UIImage(named: "ic_contact")
        lienHeItem.imageSize = CGSize(width: 42, height: 42)
        // item.backgroundColor = UIColor.init(red: 0, green: 189/255, blue: 252/255, alpha: 1)
        lienHeItem.title = localized("login.menu.contact")
        lienHeItem.titleLabel.font = regularFont(size: 14)
        lienHeItem.titleLabel.textAlignment = .right
        
        lienHeItem.handler = { lienHeItem in
            self.floatMenu.close()
            self.showContact()
        }
        floatMenu.addItem(item: lienHeItem)
        
        let hoTroItem = FloatyItem()
        hoTroItem.hasShadow = false
        hoTroItem.icon = UIImage(named: "ic_support")
        hoTroItem.imageSize = CGSize(width: 42, height: 42)
        // item.backgroundColor = UIColor.init(red: 0, green: 189/255, blue: 252/255, alpha: 1)
        hoTroItem.title = localized("login.menu.support")
        hoTroItem.titleLabel.font = regularFont(size: 14)
        hoTroItem.titleLabel.textAlignment = .right
        hoTroItem.handler = { hoTroItem in
            self.floatMenu.close()
            self.showSupport()
        }
        floatMenu.addItem(item: hoTroItem)
        
        let mangLuoiItem = FloatyItem()
        mangLuoiItem.hasShadow = false
        mangLuoiItem.icon = UIImage(named: "ic_network")
        mangLuoiItem.imageSize = CGSize(width: 42, height: 42)
        // item.backgroundColor = UIColor.init(red: 0, green: 189/255, blue: 252/255, alpha: 1)
        mangLuoiItem.title = localized("login.menu.network")
        mangLuoiItem.titleLabel.font = regularFont(size: 14)
        mangLuoiItem.titleLabel.textAlignment = .right
        mangLuoiItem.handler = { mangLuoiItem in
            self.floatMenu.close()
            self.showNet()
        }
        floatMenu.addItem(item: mangLuoiItem)
        
        view.addSubview(floatMenu)
    }
    
    // MARK: - Actions
    @IBAction func onEN(_ sender: Any) {
        NCBLocalization.shared().setLanguage("en")
        loadLocalized()
        viButton.titleLabel?.font = lightFont(size: 12)
        enButton.titleLabel?.font = boldFont(size: 12)
    }
    
    @IBAction func onVI(_ sender: Any) {
        NCBLocalization.shared().setLanguage("vi")
        loadLocalized()
        viButton.titleLabel?.font = boldFont(size: 12)
        enButton.titleLabel?.font = lightFont(size: 12)
    }
    
    @IBAction func hasActiveAccount(_ sender: Any) {
        if let _vc = R.storyboard.login.instantiateInitialViewController() {
            let nav = UINavigationController(rootViewController: _vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func dontHaveActiveAccount(_ sender: Any) {
        if let vc = R.storyboard.registerNewService.instantiateInitialViewController() {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

// MARK: - Floaty Delegate Methods

extension NCBActiveServiceViewController: FloatyDelegate {
    
    func floatyWillOpen(_ floaty: Floaty) {
        print("Floaty Will Open")
        
    }
    func floatyDidOpen(_ floaty: Floaty) {
        print("Floaty Did Open")
        
    }
    
    func floatyWillClose(_ floaty: Floaty) {
        print("Floaty Will Close")
    }
    
    func floatyDidClose(_ floaty: Floaty) {
        print("Floaty Did Close")
        
    }
}
