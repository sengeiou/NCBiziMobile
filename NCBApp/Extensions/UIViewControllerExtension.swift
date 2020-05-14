//
//  UIViewControllerExtension.swift
//  NCBApp
//
//  Created by Thuan on 4/1/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import Malert

typealias CompletionHandler = () -> Void
typealias ConfirmHandler = () -> Void
typealias CancelHandler = () -> Void


extension UIViewController {
    
    var navHeight: CGFloat {
            let maxY = UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height ?? 0)
        return maxY
    }
    
    func showAlert(msg: String, confirmTitle: String = "Đóng") {
        if let view = NCBAlertView.instantiateFromNib() {
            let malert = Malert(customView: view, tapToDismiss: false)
            malert.cornerRadius = 15
            malert.backgroundColor = UIColor.clear
            malert.animationType = .fadeIn
            view.setTitle(title: "Thông báo", message: (msg == StringConstant.invalidToken) ? "SYSTEM-3".getMessage() ?? "Hết phiên giao dịch. Quý khách vui lòng đăng nhập lại." : msg, confirmTitle: confirmTitle)
            view.confirmCallback = {
                if msg == StringConstant.invalidToken {
                    doLogout()
                }
                malert.dismiss(animated: true, completion: nil)
            }
            present(malert, animated: true)
        }
    }
    
    func showError(msg: String, confirmTitle: String = "Đóng", completionHandler: @escaping CompletionHandler) {
        if let view = NCBAlertView.instantiateFromNib() {
            let malert = Malert(customView: view, tapToDismiss: false)
            malert.cornerRadius = 15
            malert.backgroundColor = UIColor.clear
            malert.animationType = .fadeIn
            view.setTitle(title: "Thông báo", message: (msg == StringConstant.invalidToken) ? "SYSTEM-3".getMessage() ?? "Hết phiên giao dịch. Quý khách vui lòng đăng nhập lại." : msg, confirmTitle: confirmTitle)
            view.confirmCallback = {
                if msg == StringConstant.invalidToken {
                    doLogout()
                } else {
                    completionHandler()
                }
                malert.dismiss(animated: true, completion: nil)
            }
            present(malert, animated: true)
        }
    }
    
    func showConfirm(msg: String, confirmTitle: String = "Đồng ý", cancelTitle: String = "Huỷ", completionHandler: @escaping CompletionHandler) {
        if let view = NCBAlertView.instantiateFromNib() {
            let malert = Malert(customView: view, tapToDismiss: false)
            malert.cornerRadius = 15
            malert.backgroundColor = UIColor.clear
            malert.animationType = .fadeIn
            view.setTitle(title: "Thông báo", message: msg, confirmTitle: confirmTitle, cancelTitle: cancelTitle)
            view.confirmCallback = {
                completionHandler()
                malert.dismiss(animated: true, completion: nil)
            }
            view.cancelCallback = {
                malert.dismiss(animated: true, completion: nil)
            }
            present(malert, animated: true)
        }
    }
    
    func showAction(msg: String, confirmTitle: String = "Đồng ý", cancelTitle: String = "Huỷ", confirmHandler: @escaping ConfirmHandler, cancelHandler: @escaping CancelHandler) {
        if let view = NCBAlertView.instantiateFromNib() {
            let malert = Malert(customView: view, tapToDismiss: false)
            malert.cornerRadius = 15
            malert.backgroundColor = UIColor.clear
            malert.animationType = .fadeIn
            view.setTitle(title: "Thông báo", message: msg, confirmTitle: confirmTitle, cancelTitle: cancelTitle)
            view.confirmCallback = {
                confirmHandler()
                malert.dismiss(animated: true, completion: nil)
            }
            view.cancelCallback = {
                cancelHandler()
                malert.dismiss(animated: true, completion: nil)
            }
            present(malert, animated: true)
        }
    }
    
    public var sheetViewController: SheetViewController? {
        var parent = self.parent
        while let currentParent = parent {
            if let sheetViewController = currentParent as? SheetViewController {
                return sheetViewController
            } else {
                parent = currentParent.parent
            }
        }
        return nil
    }
    
}
