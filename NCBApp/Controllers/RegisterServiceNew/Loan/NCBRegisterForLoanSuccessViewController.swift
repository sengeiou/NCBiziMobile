//
//  NCBRegisterForLoanSuccessViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/28/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import SnapKit

class NCBRegisterForLoanSuccessViewController: NCBTransactionSuccessfulViewController {
    
    var isRegisterCardVisa = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBRegisterForLoanSuccessViewController {
    
    override func setupView() {
        super.setupView()
        
        hiddenHeaderView()
        updateHeightInfoView(275)
        setButtonTitle("Quay về trang chủ")
        
        let content = UILabel()
        content.font = regularFont(size: 14)
        content.textColor = ColorName.blackText.color
        if !isRegisterCardVisa {
            content.text = "NCB đã tiếp nhận yêu cầu đăng ký vay của quý khách. NCB sẽ liên hệ Quý khách trong thời gian sớm nhất để hoàn tất thủ tục."
        } else {
            content.text = "NCB đã tiếp nhận yêu cầu phát hành thẻ NCB Visa - Platinum của quý khách. NCB sẽ liên hệ Quý khách trong thời gian sớm nhất để hoàn tất thủ tục."
        }
        content.textAlignment = .center
        content.numberOfLines = 0
        
        view.addSubview(content)
        
        content.snp.makeConstraints { (make) in
            make.top.equalTo(infoTblView.snp.top).offset(30)
            make.leading.equalTo(infoTblView.snp.leading).offset(35)
            make.trailing.equalTo(infoTblView.snp.trailing).offset(-35)
        }
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle(!isRegisterCardVisa ? "Đăng ký vay thành công" : "Đăng ký thẻ tín dụng")
    }
    
    override func continueAction() {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: NCBGeneralAccountViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                return
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
