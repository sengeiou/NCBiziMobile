//
//  NCBCreditCardStatementPresenter.swift
//  NCBApp
//
//  Created by Thuan on 7/26/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBCreditCardStatementPresenterDelegate {
    func getBillStatementListCompleted(_ billList: [NCBBillStatementModel]?, error: String?)
    func getAccountStatementListCompleted(_ statement: NCBAccountStatementModel?, error: String?)
}

class NCBCreditCardStatementPresenter {
    
    var delegate: NCBCreditCardStatementPresenterDelegate?
    
    func getBillStatementList(_ cardNo: String) {
        let params: [String: Any] = [
            "userId": NCBShareManager.shared.getUserID(),
            "cifno": NCBShareManager.shared.getUser()?.cif ?? "",
            "cardNo": cardNo
        ]
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.getBillStatementList(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let billList = Mapper<NCBBillStatementModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getBillStatementListCompleted(billList, error: nil)
            } else {
                self?.delegate?.getBillStatementListCompleted(nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getBillStatementListCompleted(nil, error: error)
        }
    }
    
    func getAccountStatementList(_ params: [String: Any]) {
        let apiCreditCardService = NCBCreditCardService()
        apiCreditCardService.getAccountStatementList(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let statement = Mapper<NCBAccountStatementModel>().map(JSONString: resObj.body)
                self?.delegate?.getAccountStatementListCompleted(statement, error: nil)
            } else {
                self?.delegate?.getAccountStatementListCompleted(nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getAccountStatementListCompleted(nil, error: error)
        }
    }
    
}
