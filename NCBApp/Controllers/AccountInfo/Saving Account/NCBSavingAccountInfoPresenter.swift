//
//  NCBSavingAccountInfoPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/17/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBSavingAccountInfoPresenterDelegate {
    func getGroupSavingAccountCompleted(savingAccount: NCBGroupSavingAccountModel?, error: String?)
}

class NCBSavingAccountInfoPresenter: NSObject {
    
    var delegate: NCBSavingAccountInfoPresenterDelegate?
    func getListSavingAccount(params: [String : Any]) {
        let apiUserService = NCBSavingAccountService()
        apiUserService.getGroupSavingAccount(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModels = Mapper<NCBGroupSavingAccountModel>().map(JSONString: resObj.body)

                if let isavingGroup = dataModels?.isavingGroup {
                    for group in isavingGroup {
                        if let isavings = group.isavings {
                            let result = isavings.sorted() {
                                ($0.ccy ?? "") < ($1.ccy ?? "")
                            }
                            group.isavings = result
                        }
                    }
                    dataModels?.isavingGroup = isavingGroup
                }
                
                self?.delegate?.getGroupSavingAccountCompleted(savingAccount: dataModels, error: nil)
            } else {
                self?.delegate?.getGroupSavingAccountCompleted(savingAccount: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getGroupSavingAccountCompleted(savingAccount: nil, error: error)
        }
    }
}
