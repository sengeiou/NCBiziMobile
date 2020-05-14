//
//  NCBDebtAccountPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/22/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


protocol NCBDebtAccountPresenterDelegate {
    func getDetailExpiredDebtAccountCompleted(expiredDebtAccount: NCBDebtExpiredAccountModel?, error: String?)
    func getDetailOutOfDateDebtAccountCompleted(outOfDateDebtAccount: NCBDebtOutOfDateAccountModel?, error: String?)
}

class NCBDebtAccountPresenter: NSObject {
    
    var delegate: NCBDebtAccountPresenterDelegate?
    func getDetailExpiredDebtAccount(params: [String : Any]) {
        let apiAccountService = NCBDebtAccountService()
        apiAccountService.getDetailDebtAccount(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModels = Mapper<NCBDebtExpiredAccountModel>().map(JSONString: resObj.body)
                self?.delegate?.getDetailExpiredDebtAccountCompleted(expiredDebtAccount: dataModels, error: nil)
            } else {
                self?.delegate?.getDetailExpiredDebtAccountCompleted(expiredDebtAccount: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getDetailExpiredDebtAccountCompleted(expiredDebtAccount: nil, error: error)
        }
    }
    func getDetailOutOfDateDebtAccount(params: [String : Any]) {
        let apiAccountService = NCBDebtAccountService()
        apiAccountService.getDetailDebtAccount(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModels = Mapper<NCBDebtOutOfDateAccountModel>().map(JSONString: resObj.body)
                self?.delegate?.getDetailOutOfDateDebtAccountCompleted(outOfDateDebtAccount: dataModels, error: nil)
            } else {
                self?.delegate?.getDetailOutOfDateDebtAccountCompleted(outOfDateDebtAccount: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getDetailOutOfDateDebtAccountCompleted(outOfDateDebtAccount: nil, error: error)
        }
    }
}
