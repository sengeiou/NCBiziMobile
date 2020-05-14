//
//  NCBSavingAccountPresenter.swift
//  NCBApp
//
//  Created by Van Dong on 21/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import  ObjectMapper

@objc protocol NCBSavingAccountPresenterDelegate {
    @objc optional func getListSavingAccount(services: [NCBGeneralSavingAccountInfoModel]?, error: String?)
    @objc optional func getDetailSavingAccountCompleted(savingAccount: NCBDetailSavingAccountModel?, error: String?)
    @objc optional func createOTPSavingAccountAddAmount(msgId: String?, error: String?)
    @objc optional func getSavingFinalSettlementAccountsCompleted(savingAccounts: [NCBFinalSettlementSavingAccountModel]?, error: String?)
    @objc optional func getDetailFinalSettlementSavingAccount(savingAccount: NCBDetailSettlementSavingAccountModel?, error: String?)
    @objc optional func getMsgIdFromOTPCompleted(msgId: String?, error: String?)
    @objc optional func getCurrentRateCompleted(rate: String?, error: String?)
}
class NCBSavingAccountPresenter: NSObject {
    var delegate: NCBSavingAccountPresenterDelegate?
    //danh sách tài khoản tiết kiệm
    func getListSavingAccount(params: [String : Any]) {
        let apiUserService = NCBSavingAccountService()
        apiUserService.getAllSavingAccount(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBGeneralSavingAccountInfoModel>().mapArray(JSONString: resObj.body)
                
                self?.delegate?.getListSavingAccount?(services: services, error: nil)
            } else {
                self?.delegate?.getListSavingAccount?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListSavingAccount?(services: nil, error: error)
        }
    }
    
    func getCurrentRate(params: [String : Any]) {
        let apiUserService = NCBSavingAccountService()
        apiUserService.getCurrentRate(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let rate = Double(resObj.body)
                self?.delegate?.getCurrentRateCompleted?(rate: String(rate ?? 0.0), error: nil)
            } else {
                self?.delegate?.getCurrentRateCompleted?(rate: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getCurrentRateCompleted?(rate: nil, error: error)
        }
    }
    
    //chi tiết danh sách tài khoản tiết kiệm
    
    func getDetailSavingAccount(params: [String : Any]) {
        let apiUserService = NCBSavingAccountService()
        apiUserService.getDetailSavingAccount(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let dataModels = Mapper<NCBDetailSavingAccountModel>().map(JSONString: resObj.body)
                self?.delegate?.getDetailSavingAccountCompleted?(savingAccount: dataModels, error: nil)
            } else {
                self?.delegate?.getDetailSavingAccountCompleted?(savingAccount: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getDetailSavingAccountCompleted?(savingAccount: nil, error: error)
        }
    }
    // OTP nộp thêm tiết kiệm
    func createOTPSavingAccountAddAmount(params: [String: Any]){
        let apiService = NCBSavingAccountServiceRepair()
        apiService.createOTPSavingAccountAddAmount(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                self?.delegate?.createOTPSavingAccountAddAmount?(msgId: resObj.body, error: nil)
            } else {
                self?.delegate?.createOTPSavingAccountAddAmount?(msgId: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.createOTPSavingAccountAddAmount?(msgId: nil, error: error)
        }
    }

    //tài khoản tất toán
    func getSavingFinalSettlementAccounts(params: [String : Any]) {
        let apiTotalSavingAccountService = NCBTotalSavingAccountService()
        apiTotalSavingAccountService.getListFinalSettlementSavingAccount(params: params, success: { (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                var dataModels = Mapper<NCBFinalSettlementSavingAccountModel>().mapArray(JSONString: resObj.body)

                if let sortArr = dataModels {
                    let result = sortArr.sorted() {
                        ($0.ccy ?? "") < ($1.ccy ?? "")
                    }
                    dataModels = result
                }

                self.delegate?.getSavingFinalSettlementAccountsCompleted?(savingAccounts: dataModels, error: nil)
            } else {
                self.delegate?.getSavingFinalSettlementAccountsCompleted?(savingAccounts: nil, error: resObj.description)
            }
        }, failure: {[weak self] (error) in
            self?.delegate?.getSavingFinalSettlementAccountsCompleted?(savingAccounts: nil, error: error)
        })
    }

    //chi tiết tài khoản tất toán
    func getDetailFinalSettlementSavingAccount(params: [String : Any]) {
        let apiTotalSavingAccountService = NCBTotalSavingAccountService()
        apiTotalSavingAccountService.getDetailFinalSettlementSavingAccount(params: params, success: { (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let dataModels = Mapper<NCBDetailSettlementSavingAccountModel>().map(JSONString: resObj.body)
                self.delegate?.getDetailFinalSettlementSavingAccount?(savingAccount: dataModels, error: nil)
            } else {
                self.delegate?.getDetailFinalSettlementSavingAccount?(savingAccount: nil, error: resObj.description)
            }
        }, failure: {[weak self] (error) in
            self?.delegate?.getDetailFinalSettlementSavingAccount?(savingAccount: nil, error: error)
        })
    }
    //OTP tất toán tiết kiệm
    func generateOTPFinalSettlementAccount(params: [String : Any]) {
        let apiTotalSavingAccountService = NCBTotalSavingAccountService()
        apiTotalSavingAccountService.generateOTPFinalSettlementSavingAccount(params: params, success: { (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                self.delegate?.getMsgIdFromOTPCompleted?(msgId: resObj.body, error: nil)
            } else {
                self.delegate?.getMsgIdFromOTPCompleted?(msgId: nil, error: resObj.description)
            }
        }, failure: {[weak self] (error) in
            self?.delegate?.getMsgIdFromOTPCompleted?(msgId: nil, error: error)
        })
    }
}
