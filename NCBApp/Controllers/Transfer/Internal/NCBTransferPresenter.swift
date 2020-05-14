//
//  NCBTransferPresenter.swift
//  NCBApp
//
//  Created by Thuan on 5/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBTransferPresenterDelegate {
    @objc optional func checkDestinationAccountCompleted(destAccount: NCBDestinationAccountModel?, error: String?)
    @objc optional func pushTransferInfoCompleted(info: NCBTransferInfoModel?, error: String?)
    @objc optional func getInfoAccount247Completed(infoAccount: NCBAccountInfo247Model?, error: String?)
}

class NCBTransferPresenter {
    
    var delegate: NCBTransferPresenterDelegate?
    
    func checkDestinationAccount(params: [String : Any]) {
        let apiTransferService = NCBApiTransactionService()
        apiTransferService.checkDestinationAccount(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let destAccount = Mapper<NCBDestinationAccountModel>().map(JSONString: resObj.body)
                self?.delegate?.checkDestinationAccountCompleted?(destAccount: destAccount, error: nil)
            } else {
                self?.delegate?.checkDestinationAccountCompleted?(destAccount: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.checkDestinationAccountCompleted?(destAccount: nil, error: error)
        }
    }
    
    func pushTransferInfo(params: [String : Any], type: TransactionType) {
        let apiTransferService = NCBApiTransactionService()
        apiTransferService.pushTransactionInfo(params: params, type: type, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let info = Mapper<NCBTransferInfoModel>().map(JSONString: resObj.body)
                self?.delegate?.pushTransferInfoCompleted?(info: info, error: nil)
            } else {
                self?.delegate?.pushTransferInfoCompleted?(info: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.pushTransferInfoCompleted?(info: nil, error: error)
        }
    }
    
    func getInfoAccount247(params: [String : Any]) {
        let apiTransferService = NCBApiTransactionService()
        apiTransferService.getInfoAccount247(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let infoAccount = Mapper<NCBAccountInfo247Model>().map(JSONString: resObj.body)
                self?.delegate?.getInfoAccount247Completed?(infoAccount: infoAccount, error: nil)
            } else {
                self?.delegate?.getInfoAccount247Completed?(infoAccount: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getInfoAccount247Completed?(infoAccount: nil, error: error)
        }
    }
    
}
