//
//  NCBDetailSavingAccountInfoPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/18/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


protocol NCBDetailSavingAccountInfoPresenterDelegate {
    func getDetailSavingAccountCompleted(savingAccount: NCBDetailSavingAccountModel?, error: String?)
}

class NCBDetailSavingAccountInfoPresenter: NSObject {
    
    var delegate: NCBDetailSavingAccountInfoPresenterDelegate?
    func getDetailSavingAccount(params: [String : Any]) {
        let apiUserService = NCBSavingAccountService()
        apiUserService.getDetailSavingAccount(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let dataModels = Mapper<NCBDetailSavingAccountModel>().map(JSONString: resObj.body)
                self?.delegate?.getDetailSavingAccountCompleted(savingAccount: dataModels, error: nil)
            } else {
                self?.delegate?.getDetailSavingAccountCompleted(savingAccount: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getDetailSavingAccountCompleted(savingAccount: nil, error: error)
        }
    }
}
