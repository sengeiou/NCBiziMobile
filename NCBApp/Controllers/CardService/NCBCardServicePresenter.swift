//
//  NCBCardServicePresenter.swift
//  NCBApp
//
//  Created by ADMIN on 7/24/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import ObjectMapper

@objc protocol NCBCardServicePresenterDelegate {
    
    @objc optional func getCrCardList(services: [NCBCardModel]?, error: String?)
    @objc optional func getListAccNo(services: [NCBGetListAccNoModel]?, error: String?)
    
    @objc optional func updateCardStatusUnlockConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?)
    @objc optional func updateCardStatusUnlockApproval(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?)
    @objc optional func cardActiveConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?)
    @objc optional func cardActiveApproval(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?)
    @objc optional func getCardListAutoDebtDeductionConfirm(services: [NCBCardModel]?, error: String?)
    @objc optional func getCardListAutoDebtDeductionApproval(services: [NCBCardModel]?, error: String?)
    
    @objc optional func getListBranch(services: [NCBBranchModel]?, error: String?)
    @objc optional func getListCardProduct(services: [String]?, error: String?)
    @objc optional func getListCardClass(services: [String]?, error: String?)
    @objc optional func getFeeCard(services: NCBGetFeeCardModel?, error: String?)
    @objc optional func updateCardStatusLock(services: String?, error: String?)
    @objc optional func getListAcctReopenAtm(services: [NCBBranchModel]?, error: String?)
    @objc optional func getFeeAcctReopenAtm(services: NCBGetFeeAcctReopenAtmModel?, error: String?)
    @objc optional func getReasonAcctReopenAtm(services: [NCBReasonAcctReopenAtmModel]?, error: String?)
    @objc optional func reopenAtmConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?)
    @objc optional func reopenAtmApproval(services: [NCBBranchModel]?, error: String?)
    @objc optional func reopenVisaConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?)
    @objc optional func reopenVisaApproval(services: [NCBBranchModel]?, error: String?)

    @objc optional func createAtmConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?)
    @objc optional func createAtmApproval(services: [NCBBranchModel]?, error: String?)
    
     @objc optional func getListCardProductVisa(services: [NCBGetListCardProductVisaModel]?, error: String?)
     @objc optional func createCardVisa(services: String?, error: String?)
    
    
     @objc optional func getFeePin(services: NCBGetFeeCardModel?, error: String?)
     @objc optional func reissuePinConfirm(services: NCBUpdateCardStatusUnlockConfirmModel?, error: String?)
      @objc optional func reissuePinApproval(services: [NCBBranchModel]?, error: String?)
    @objc optional func checkCreateVisa(services: String?, error: String?)
    @objc optional func checkReopenCard(services: String?, error: String?)
    @objc optional func checkReissuePin(services: String?, error: String?)
   
    
}

class NCBCardServicePresenter {
    var delegate: NCBCardServicePresenterDelegate?
    
    func getServiceList(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getCrCardList(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBCardModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getCrCardList?(services: services, error: nil)
            } else {
                self?.delegate?.getCrCardList?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getCrCardList?(services: nil, error: error)
        }
    }
    
    func getListAccNo(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getListAccNo(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBGetListAccNoModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListAccNo?(services: services, error: nil)
            } else {
                self?.delegate?.getListAccNo?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListAccNo?(services: nil, error: error)
        }
    }
    
    func updateCardStatusLock(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.updateCardStatusLock(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                self?.delegate?.updateCardStatusLock?(services: resObj.body, error: nil)
            } else {
                self?.delegate?.updateCardStatusLock?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.updateCardStatusLock?(services: nil, error: error)
        }
    }
    
    
    func updateCardStatusUnlockConfirm(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.updateCardStatusUnlockConfirm(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                
                let services = Mapper<NCBUpdateCardStatusUnlockConfirmModel>().map(JSONString: resObj.body)
                
                self?.delegate?.updateCardStatusUnlockConfirm?(services: services, error: nil)
            } else {
                self?.delegate?.updateCardStatusUnlockConfirm?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.updateCardStatusUnlockConfirm?(services: nil, error: error)
        }
    }
    
    func updateCardStatusUnlockApproval(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.updateCardStatusUnlockApproval(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                
                let services = Mapper<NCBUpdateCardStatusUnlockConfirmModel>().map(JSONString: resObj.body)
                
                self?.delegate?.updateCardStatusUnlockApproval?(services: services, error: nil)
            } else {
                self?.delegate?.updateCardStatusUnlockApproval?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.updateCardStatusUnlockApproval?(services: nil, error: error)
        }
    }
    func cardActiveConfirm(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.cardActiveConfirm(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                
                let services = Mapper<NCBUpdateCardStatusUnlockConfirmModel>().map(JSONString: resObj.body)
                
                self?.delegate?.cardActiveConfirm?(services: services, error: nil)
          
            } else {
                self?.delegate?.cardActiveConfirm?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.cardActiveConfirm?(services: nil, error: error)
        }
    }
    func cardActiveApproval(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.cardActiveApproval(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                
                let services = Mapper<NCBUpdateCardStatusUnlockConfirmModel>().map(JSONString: resObj.body)
                
                self?.delegate?.cardActiveApproval?(services: services, error: nil)
            } else {
                self?.delegate?.cardActiveApproval?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.cardActiveApproval?(services: nil, error: error)
        }
    }

    func getCardListAutoDebtDeductionConfirm(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getCardListAutoDebtDeductionConfirm(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBCardModel>().mapArray(JSONString: resObj.body)
            self?.delegate?.getCardListAutoDebtDeductionConfirm?(services: services, error: nil)
            } else {            self?.delegate?.getCardListAutoDebtDeductionConfirm?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in            self?.delegate?.getCardListAutoDebtDeductionConfirm?(services: nil, error: error)
        }
    }
    func getCardListAutoDebtDeductionApproval(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getCardListAutoDebtDeductionApproval(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBCardModel>().mapArray(JSONString: resObj.body)
            self?.delegate?.getCardListAutoDebtDeductionApproval?(services: services, error: nil)
            } else {
            self?.delegate?.getCardListAutoDebtDeductionApproval?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getCardListAutoDebtDeductionApproval?(services: nil, error: error)
        }
    }
    
    
    func getListBranch(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getListBranch(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                //print(resObj.body)
                let services = Mapper<NCBBranchModel>().mapArray(JSONString: resObj.body)
                
                self?.delegate?.getListBranch?(services: services, error: nil)
            } else {
                self?.delegate?.getListBranch?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListBranch?(services: nil, error: error)
        }
    }
    
    func getListCardProduct(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getListCardProduct(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                //print(resObj.body)
                var str = resObj.body
                str = str.replacingOccurrences(of: "[", with: "")
                str = str.replacingOccurrences(of: "]", with: "")
                str = str.replacingOccurrences(of: "\"", with: "")
                str = str.replacingOccurrences(of: "\n", with: "")
                //str = str.replacingOccurrences(of: " ", with: "")
                //str = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                let array = str.components(separatedBy: ",")
                
                self?.delegate?.getListCardProduct?(services: array, error: nil)
            } else {
                self?.delegate?.getListCardProduct?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListCardProduct?(services: nil, error: error)
        }
    }
    
    
    func getListCardClass(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getListCardClass(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                var str = resObj.body
                str = str.replacingOccurrences(of: "[", with: "")
                str = str.replacingOccurrences(of: "]", with: "")
                str = str.replacingOccurrences(of: "\"", with: "")
                str = str.replacingOccurrences(of: "\n", with: "")
                let array = str.components(separatedBy: ",")
                self?.delegate?.getListCardClass?(services: array, error: nil)
            } else {
                self?.delegate?.getListCardClass?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListCardClass?(services: nil, error: error)
        }
    }
    func getFeeCard(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getFeeCard(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                //print(resObj.body)
                let services = Mapper<NCBGetFeeCardModel>().map(JSONString: resObj.body)
                
                self?.delegate?.getFeeCard?(services: services, error: nil)
            } else {
                self?.delegate?.getFeeCard?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getFeeCard?(services: nil, error: error)
        }
    }
    
    
    
    func getListAcctReopenAtm(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getListAcctReopenAtm(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                //print(resObj.body)
                let services = Mapper<NCBBranchModel>().mapArray(JSONString: resObj.body)
                
                self?.delegate?.getListAcctReopenAtm?(services: services, error: nil)
            } else {
                self?.delegate?.getListAcctReopenAtm?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListAcctReopenAtm?(services: nil, error: error)
        }
    }
    func getFeeAcctReopenAtm(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getFeeAcctReopenAtm(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
         let services = Mapper<NCBGetFeeAcctReopenAtmModel>().map(JSONString: resObj.body)
                self?.delegate?.getFeeAcctReopenAtm?(services: services, error: nil)
            } else {
                self?.delegate?.getFeeAcctReopenAtm?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getFeeAcctReopenAtm?(services: nil, error: error)
        }
    }
    func getReasonAcctReopenAtm(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getReasonAcctReopenAtm(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                 let services = Mapper<NCBReasonAcctReopenAtmModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getReasonAcctReopenAtm?(services: services, error: nil)
            } else {
                self?.delegate?.getReasonAcctReopenAtm?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getReasonAcctReopenAtm?(services: nil, error: error)
        }
    }
    func reopenAtmConfirm(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.reopenAtmConfirm(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
           let services = Mapper<NCBUpdateCardStatusUnlockConfirmModel>().map(JSONString: resObj.body)
                self?.delegate?.reopenAtmConfirm?(services: services, error: nil)
            } else {
                self?.delegate?.reopenAtmConfirm?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.reopenAtmConfirm?(services: nil, error: error)
        }
    }
    func reopenAtmApproval(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.reopenAtmApproval(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                //print(resObj.body)
                let services = Mapper<NCBBranchModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.reopenAtmApproval?(services: services, error: nil)
            } else {
                self?.delegate?.reopenAtmApproval?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.reopenAtmApproval?(services: nil, error: error)
        }
    }
    
    func reopenVisaConfirm(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.reopenVisaConfirm(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBUpdateCardStatusUnlockConfirmModel>().map(JSONString: resObj.body)
                self?.delegate?.reopenVisaConfirm?(services: services, error: nil)
            } else {
                self?.delegate?.reopenVisaConfirm?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.reopenVisaConfirm?(services: nil, error: error)
        }
    }
    func reopenVisaApproval(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.reopenVisaApproval(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                let services = Mapper<NCBBranchModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.reopenVisaApproval?(services: services, error: nil)
            } else {
                self?.delegate?.reopenVisaApproval?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.reopenVisaApproval?(services: nil, error: error)
        }
    }
    
    func createAtmConfirm(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.createAtmConfirm(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                //print(resObj.body)
              let services = Mapper<NCBUpdateCardStatusUnlockConfirmModel>().map(JSONString: resObj.body)
                self?.delegate?.createAtmConfirm?(services: services, error: nil)
            } else {
                self?.delegate?.createAtmConfirm?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.createAtmConfirm?(services: nil, error: error)
        }
    }
    func createAtmApproval(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.createAtmApproval(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                //print(resObj.body)
                let services = Mapper<NCBBranchModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.createAtmApproval?(services: services, error: nil)
            } else {
                self?.delegate?.createAtmApproval?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.createAtmApproval?(services: nil, error: error)
        }
    }
    
    func getListCardProductVisa(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getListCardProductVisa(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                //print(resObj.body)
                let services = Mapper<NCBGetListCardProductVisaModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.getListCardProductVisa?(services: services, error: nil)
            } else {
                self?.delegate?.getListCardProductVisa?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getListCardProductVisa?(services: nil, error: error)
        }
    }
    
    func createCardVisa(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.createCardVisa(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                //print(resObj.body)
                //let services = Mapper<NCBBranchModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.createCardVisa?(services: resObj.body, error: nil)
            } else {
                self?.delegate?.createCardVisa?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.createCardVisa?(services: nil, error: error)
        }
    }
    
    
    func getFeePin(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.getFeePin(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                //print(resObj.body)
                let services = Mapper<NCBGetFeeCardModel>().map(JSONString: resObj.body)
                self?.delegate?.getFeePin?(services: services, error: nil)
            } else {
                self?.delegate?.getFeePin?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.getFeePin?(services: nil, error: error)
        }
    }
    
    func reissuePinConfirm(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.reissuePinConfirm(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                 let services = Mapper<NCBUpdateCardStatusUnlockConfirmModel>().map(JSONString: resObj.body)
                self?.delegate?.reissuePinConfirm?(services: services, error: nil)
            } else {
                self?.delegate?.reissuePinConfirm?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.reissuePinConfirm?(services: nil, error: error)
        }
    }
    
    func reissuePinApproval(params: [String: Any]) {
        let apiService = NCBApiCardService()
        apiService.reissuePinApproval(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            if resObj.code == ResponseCodeConstant.success {
                //print(resObj.body)
                let services = Mapper<NCBBranchModel>().mapArray(JSONString: resObj.body)
                self?.delegate?.reissuePinApproval?(services: services, error: nil)
            } else {
                self?.delegate?.reissuePinApproval?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.reissuePinApproval?(services: nil, error: error)
        }
    }
    
    func checkCreateVisa(params: [String: Any]) {
        let apiService = NCBApiCardService()
      
        apiService.checkCreateVisa(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                self?.delegate?.checkCreateVisa?(services: resObj.description, error: nil)
            } else {
                self?.delegate?.checkCreateVisa?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.checkCreateVisa?(services: nil, error: error)
        }
    }
    func checkReopenCard(params: [String: Any]) {
        let apiService = NCBApiCardService()
        
        apiService.checkReopenCard(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            
            if resObj.code == ResponseCodeConstant.success {
                self?.delegate?.checkReopenCard?(services: nil, error: nil)
            } else {
                self?.delegate?.checkReopenCard?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.checkReopenCard?(services: nil, error: error)
        }
    }
    
    func checkReissuePin(params: [String: Any]) {
        let apiService = NCBApiCardService()
        
        apiService.checkReissuePin(params: params, success: { [weak self] (response) in
            let resObj = DefaultRequestSuccessHandler(response)
            
            if resObj.code == ResponseCodeConstant.success {
                print(resObj.body)
                self?.delegate?.checkReissuePin?(services: resObj.description, error: nil)
            } else {
                self?.delegate?.checkReissuePin?(services: nil, error: resObj.description)
            }
        }) { [weak self] (error) in
            self?.delegate?.checkReissuePin?(services: nil, error: error)
        }
    }
}


