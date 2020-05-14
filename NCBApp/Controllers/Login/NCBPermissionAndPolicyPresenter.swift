//
//  NCBPermissionAndPolicyPresenter.swift
//  NCBApp
//
//  Created by Thuan on 9/26/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBPermissionAndPolicyPresenterDelegate {
    @objc optional func getTermOfUseCompleted(contents: [NCBTermOfUseModel]?, error: String?)
}

class NCBPermissionAndPolicyPresenter: NSObject {
    var delegate: NCBPermissionAndPolicyPresenterDelegate?
    
    func getTermOfUse(code: String) {
        let apiUserService = NCBAppConfigService()
        apiUserService.getTermOfUse(code: code, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let contents = Mapper<NCBTermOfUseModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getTermOfUseCompleted?(contents: contents, error: nil)
            } else {
                self?.delegate?.getTermOfUseCompleted?(contents: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getTermOfUseCompleted?(contents: nil, error: error)
        }
    }
    
}
