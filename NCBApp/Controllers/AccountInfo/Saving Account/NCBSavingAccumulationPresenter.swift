//
//  NCBSavingAccumulationPresenter.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/8/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

protocol NCBSavingAccumulationPresenterDelegate {
    func getSavingConfigCompleted(savingAccount: NCBSendSavingAmountModel?, error: String?)
    func getInterestRateCompleted(rate: String?, error: String?)
}

class NCBSavingAccumulationPresenter: NSObject {
    
    var delegate: NCBSavingAccumulationPresenterDelegate?
    func getSavingConfig() {
        let apiSavingConfigService = NCBTotalSavingAccountService()
        apiSavingConfigService.getSavingConfig(success: { (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let dataModels = Mapper<NCBSendSavingAmountModel>().map(JSONString: resObj.body)
                self.delegate?.getSavingConfigCompleted(savingAccount: dataModels, error: nil)
            } else {
                self.delegate?.getSavingConfigCompleted(savingAccount: nil, error: resObj.description)
            }
        }, failure: {[weak self] (error) in
            self?.delegate?.getSavingConfigCompleted(savingAccount: nil, error: error)
        })
    }
    
    func getInterestRate(params: [String : Any]) {
        let apiSavingConfigService = NCBTotalSavingAccountService()
        apiSavingConfigService.getInterestRate(params: params, success: { (response) in
            let resObj = DefaultRequestSuccessHandler(response)
           
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let rate = Double(resObj.body)
                self.delegate?.getInterestRateCompleted(rate: String(rate ?? 0.0), error: nil)
            } else {
                self.delegate?.getInterestRateCompleted(rate: nil, error: resObj.description)
            }
        }, failure: {[weak self] (error) in
            self?.delegate?.getInterestRateCompleted(rate: nil, error: error)
        })
    }
}
