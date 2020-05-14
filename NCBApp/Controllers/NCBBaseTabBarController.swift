//
//  NCBBaseTabBarController.swift
//  NCBApp
//
//  Created by Thuan on 4/5/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

enum MainTabIndex: Int {
    case home = 0
    case transfer
    case pay
    case saving
    case menu
}

class NCBBaseTabBarController: UITabBarController {
    
    //MARK: Properties
    
    fileprivate var nextTabIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font: regularFont(size: 10)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        
        let home = R.storyboard.main.ncbHomeViewController()!
        let homeNav = UINavigationController(rootViewController: home)
        var item = UITabBarItem(title: "Trang chủ", image: R.image.ic_tabbar_home()?.withRenderingMode(.alwaysOriginal), tag: MainTabIndex.home.rawValue)
        item.selectedImage = R.image.ic_tabbar_home_selected()?.withRenderingMode(.alwaysOriginal)
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        homeNav.tabBarItem = item
        
        let transfer = R.storyboard.main.ncbTransferViewController()!
        let transferNav = UINavigationController(rootViewController: transfer)
        item = UITabBarItem(title: "Chuyển khoản", image: R.image.ic_tabbar_transfer()?.withRenderingMode(.alwaysOriginal), tag: MainTabIndex.transfer.rawValue)
        item.selectedImage = R.image.ic_tabbar_transfer_selected()?.withRenderingMode(.alwaysOriginal)
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        transferNav.tabBarItem = item
        
        let pay = R.storyboard.main.ncbPayViewController()!
        let payNav = UINavigationController(rootViewController: pay)
        item = UITabBarItem(title: "Thanh toán", image: R.image.ic_tabbar_pay()?.withRenderingMode(.alwaysOriginal), tag: MainTabIndex.pay.rawValue)
        item.selectedImage = R.image.ic_tabbar_pay_selected()?.withRenderingMode(.alwaysOriginal)
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        payNav.tabBarItem = item
        
        let saving = R.storyboard.main.ncbSavingAccountViewController()!
//        let saving = R.storyboard.savingAccount.ncbSavingAccountFormsViewController()!
        let savingNav = UINavigationController(rootViewController: saving)
        item = UITabBarItem(title: "Tiết kiệm", image: R.image.ic_tabbar_saving()?.withRenderingMode(.alwaysOriginal), tag: MainTabIndex.saving.rawValue)
        item.selectedImage = R.image.ic_tabbar_saving_selected()?.withRenderingMode(.alwaysOriginal)
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        savingNav.tabBarItem = item
        
        let menu = R.storyboard.main.ncbMenuViewController()!
        let menuNav = UINavigationController(rootViewController: menu)
        item = UITabBarItem(title: "", image: R.image.ic_tabbar_menu()?.withRenderingMode(.alwaysOriginal), tag: MainTabIndex.menu.rawValue)
        item.selectedImage = R.image.ic_tabbar_menu_selected()?.withRenderingMode(.alwaysOriginal)
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        menuNav.tabBarItem = item
        
        viewControllers = [homeNav, transferNav, payNav, savingNav, menuNav]
        tabBar.barTintColor = UIColor.white
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        nextTabIndex = item.tag
    }
    
}

extension NCBBaseTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if NCBShareManager.shared.areTrading {
            showConfirm(msg: "CASE#-1".getMessage() ?? "Quý khách muốn dừng giao dịch đang thực hiện?") { [unowned self] in
                NCBShareManager.shared.areTrading = false
                tabBarController.selectedIndex = self.nextTabIndex
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: keyMainTabIndexChanged), object: nil)
            }
            return false
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: keyMainTabIndexChanged), object: nil)
    }
    
}
