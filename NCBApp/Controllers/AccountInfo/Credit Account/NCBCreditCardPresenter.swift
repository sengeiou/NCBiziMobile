//
//  NCBCreditCardPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 4/25/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper


protocol NCBCreditCardPresenterDelegate {
    func getListCreditCardCompleted(statementAccount: [NCBCreditCardModel]?, error: String?)
}

class NCBCreditCardPresenter: NSObject {
    
    var delegate: NCBCreditCardPresenterDelegate?
    func getListCreditCard(params: [String : Any]) {
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.getListCreditCard(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let dataModels = Mapper<NCBCreditCardModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListCreditCardCompleted(statementAccount: dataModels, error: nil)
            } else {
                self?.delegate?.getListCreditCardCompleted(statementAccount: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListCreditCardCompleted(statementAccount: nil, error: error)
        }
    }
}
