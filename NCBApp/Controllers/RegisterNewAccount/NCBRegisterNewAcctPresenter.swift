//
//  NCBRegisterNewAcctPresenter.swift
//  NCBApp
//
//  Created by ADMIN on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBRegisterNewAcctPresenterDelegate {
    
    @objc optional func getProductOpenAcountOnline(services: [NCBRegisterNewServiceProductModel]?, error: String?)
      @objc optional func getDescProductOpenAccountOnline(services: String?, error: String?)
      @objc optional func getListTypeNiceNumber(services: [NCBTailNumberModel]?, error: String?)
      @objc optional func getNiceAccountInfo(services: [NCBReturnNumberModel]?, error: String?)
      @objc optional func generateOTPOpenAccountOnline(services: String?, error: String?)
     @objc optional func openAccountOnline(services: String?, error: String?)
   
    
   
}

class NCBRegisterNewAcctPresenter {
    
    var delegate: NCBRegisterNewAcctPresenterDelegate?
    
    func getProductOpenAcountOnline(params: [String: Any]) {
        let apiService = NCBRegisterNewAcctService()
        apiService.getProductOpenAcountOnline(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBRegisterNewServiceProductModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getProductOpenAcountOnline?(services: services, error: nil)
            } else {
                self?.delegate?.getProductOpenAcountOnline?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getProductOpenAcountOnline?(services: nil, error: error)
        }
    }

    func getDescProductOpenAccountOnline(params: [String: Any]) {
        let apiService = NCBRegisterNewAcctService()
        apiService.getDescProductOpenAccountOnline(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = resObj.body
                self?.delegate?.getDescProductOpenAccountOnline?(services: services, error: nil)
            } else {
                self?.delegate?.getDescProductOpenAccountOnline?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getDescProductOpenAccountOnline?(services: nil, error: error)
        }
    }
    
 
   
    func getListTypeNiceNumber(params: [String: Any]) {
        let apiService = NCBRegisterNewAcctService()
        apiService.getListTypeNiceNumber(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                var jsonString = resObj.body
                //jsonString = jsonString.filter { !$0.isNewline }
                jsonString = jsonString.replacingOccurrences(of: "\n ", with: "")
                
                print(jsonString)
                let services = Mapper<NCBTailNumberModel>().mapArray(JSONString: jsonString)
                self?.delegate?.getListTypeNiceNumber?(services: services, error: nil)
            } else {
                self?.delegate?.getListTypeNiceNumber?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListTypeNiceNumber?(services: nil, error: error)
        }
    }
    
    func getNiceAccountInfo(params: [String: Any]) {
        let apiService = NCBRegisterNewAcctService()
        apiService.getNiceAccountInfo(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                let services = Mapper<NCBReturnNumberModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getNiceAccountInfo?(services: services, error: nil)
            } else {
                self?.delegate?.getNiceAccountInfo?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getNiceAccountInfo?(services: nil, error: error)
        }
    }
    
    func generateOTPOpenAccountOnline(params: [String: Any]) {
        let apiService = NCBRegisterNewAcctService()
        apiService.generateOTPOpenAccountOnline(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                var services = resObj.body
                self?.delegate?.generateOTPOpenAccountOnline?(services: services, error: nil)
            } else {
                self?.delegate?.generateOTPOpenAccountOnline?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.generateOTPOpenAccountOnline?(services: nil, error: error)
        }
    }
    func openAccountOnline(params: [String: Any]) {
        let apiService = NCBRegisterNewAcctService()
        apiService.openAccountOnline(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = resObj.description
                self?.delegate?.openAccountOnline?(services: services, error: nil)
            } else {
                self?.delegate?.openAccountOnline?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.openAccountOnline?(services: nil, error: error)
        }
    }
}
