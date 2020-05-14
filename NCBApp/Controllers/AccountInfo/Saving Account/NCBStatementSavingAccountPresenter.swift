//
//  NCBStatementSavingAccountPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/19/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


@objc protocol NCBStatementSavingAccountPresenterDelegate {
     @objc optional func getDetailStatementSavingAccountCompleted(statementAccount: [NCBDetailStatementSavingAccountModel]?, error: String?)
    @objc optional func getSavingHistoryCompleted(historyList: [NCBDetailStatementSavingAccountModel]?, error: String?)
}

class NCBStatementSavingAccountPresenter: NSObject {
    
    var delegate: NCBStatementSavingAccountPresenterDelegate?
    var totalPage = 0
    
    func getDetailSavingAccount(params: [String : Any]) {
        let apiUserService = NCBSavingAccountService()
        apiUserService.getDetailStatementSavingAccount(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModels = Mapper<NCBDetailStatementSavingAccountModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getDetailStatementSavingAccountCompleted?(statementAccount: dataModels, error: nil)
            } else {
                self?.delegate?.getDetailStatementSavingAccountCompleted?(statementAccount: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getDetailStatementSavingAccountCompleted?(statementAccount: nil, error: error)
        }
    }
    
    func getSavingHistory(params: [String : Any]) {
        let apiUserService = NCBSavingAccountService()
        apiUserService.getSavingHistory(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let json = resObj.body.convertToDictionary()
                self?.totalPage = json?["totalPage"] as? Int ?? 0
                let dataModels = Mapper<NCBDetailStatementSavingAccountModel>().mapArray(JSONObject: json?["data"])
                self?.delegate?.getSavingHistoryCompleted?(historyList: dataModels, error: nil)
            } else {
                self?.delegate?.getSavingHistoryCompleted?(historyList: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getSavingHistoryCompleted?(historyList: nil, error: error)
        }
    }
    
}
