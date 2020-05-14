//
//  NCBMenuPresenter.swift
//  NCBApp
//
//  Created by ADMIN on 8/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBMenuPresenterDelegate {
    @objc optional func updateProfileAvatar(success: String?, error: String?)
    @objc optional func logoutCompleted(error: String?)
}

class NCBMenuPresenter {     
    
    var delegate: NCBMenuPresenterDelegate?

    func updateProfileAvatar(params: [String : Any]) {
        let apiUserService = NCBApiUserService()
        apiUserService.updateProfileAvatar(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.updateProfileAvatar?(success: resObj.description, error: nil)
            } else {
                self?.delegate?.updateProfileAvatar?(success: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.updateProfileAvatar?(success: nil, error: error)
        }
    }
    
    func logout() {
        let apiUserService = NCBApiUserService()
        apiUserService.logout(success: { [weak self] (response) in
//            self?.delegate?.logoutCompleted?(error: nil)
        }) { [weak self] (error) in
//            self?.delegate?.logoutCompleted?(error: nil)
        }
    }
    
}
