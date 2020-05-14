//
//  NCBAccountStatementPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/16/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBAccountStatementPresenterDelegate {
    func getDealStatementCompleted(listDealStatement: [NCBDetailHistoryDealItemModel]?,error: String?)
}

class NCBAccountStatementPresenter: NSObject {
    
    var delegate: NCBAccountStatementPresenterDelegate?
    var lastPage = false
    
    func getListDealStatement(params: [String : Any]) {
        let apiUserService = NCBDealService()
        apiUserService.getListDealStatement(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModel = Mapper<NCBDealStatementModel>().map(JSONString: resObj.body)
                self?.lastPage = dataModel?.last ?? false
                self?.delegate?.getDealStatementCompleted(listDealStatement: dataModel?.content, error: nil)
            } else {
                self?.delegate?.getDealStatementCompleted(listDealStatement: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getDealStatementCompleted(listDealStatement: nil, error: error)
        }
    }
}
