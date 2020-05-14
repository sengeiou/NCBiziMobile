//
//  NCBVerifyTransactionPresenter.swift
//  NCBApp
//
//  Created by Thuan on 5/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBVerifyTransactionPresenterDelegate {
    func confirmTransferCompleted(info: NCBConfirmTransferInfoModel?, error: String?, code: String?)
}

class NCBVerifyTransactionPresenter {
    
    var delegate: NCBVerifyTransactionPresenterDelegate?
    
    func confirmTransfer(params: [String : Any], type: TransactionType) {
        let apiTransferService = NCBApiTransactionService()
        apiTransferService.confirmTransactionInfo(params: params, type: type, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success || resObj.code == ResponseCodeConstant.t24TimeOuted {
                let info = Mapper<NCBConfirmTransferInfoModel>().map(JSONString: resObj.body)
                self?.delegate?.confirmTransferCompleted(info: info, error: nil, code: resObj.code)
            } else {
                self?.delegate?.confirmTransferCompleted(info: nil, error: resObj.description, code: nil)
            }
        }) { [weak self] (error) in
            self?.delegate?.confirmTransferCompleted(info: nil, error: error, code: nil)
        }
    }
    
}
