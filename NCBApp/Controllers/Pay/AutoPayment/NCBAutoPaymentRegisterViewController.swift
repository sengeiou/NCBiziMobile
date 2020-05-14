//
//  NCBAutoPaymentRegisterViewController.swift
//  NCBApp
//
//  Created by Thuan on 6/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBAutoPaymentRegisterViewController: NCBBaseSourceAccountViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tfService: NewNCBCommonTextField!
    @IBOutlet weak var tfProvider: NewNCBCommonTextField!
    @IBOutlet weak var tfCode: NewNCBCommonTextField!
    @IBOutlet weak var continueBtn: NCBCommonButton!
    @IBOutlet weak var lbNote: UILabel!
    
    //MARK: Properties
    
    fileprivate var service: NCBServiceModel?
    fileprivate var provider: NCBServiceProviderModel?
    fileprivate var servicePaymentPresenter: NCBServicePaymentPresenter?
    fileprivate var servicePresenter: NCBPayPresenter?
    fileprivate var providerPresenter: NCBProviderListPresenter?
    fileprivate var serviceList = [NCBServiceModel]()
    fileprivate var providerList = [NCBServiceProviderModel]()
    fileprivate var isChoosingService = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    @IBAction func continueAction(_ sender: Any) {
        guard let _ = service else {
            showAlert(msg: "AUTOBILL-01".getMessage() ?? "Vui lòng chọn dịch vụ")
            return
        }
        
        guard let _ = provider else {
            showAlert(msg: "AUTOBILL-02".getMessage() ?? "Vui lòng chọn Nhà cung cấp dịch vụ")
            return
        }
        
        if tfCode.text == "" {
            showAlert(msg: "AUTOBILL-03".getMessage() ?? "Vui lòng nhập mã khách hàng")
            return
        }
        
        getBillInfo()
    }
    
}

extension NCBAutoPaymentRegisterViewController {
    
    override func setupView() {
        super.setupView()
        
        lbNote.font = italicFont(size: 12)
        lbNote.numberOfLines = 0
        lbNote.textColor = UIColor(hexString: "0083DC")
        
        tfService.addRightArrow()
        tfProvider.addRightArrow()
        
        tfService.delegate = self
        tfProvider.delegate = self
        
        servicePresenter = NCBPayPresenter()
        servicePresenter?.delegate = self
        
        SVProgressHUD.show()
        servicePresenter?.getServiceList(params: ["type": "1"])
        
        providerPresenter = NCBProviderListPresenter()
        providerPresenter?.delegate = self
        
        servicePaymentPresenter = NCBServicePaymentPresenter()
        servicePaymentPresenter?.forCheckBill = true
        servicePaymentPresenter?.delegate = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("THANH TOÁN TỰ ĐỘNG")
        
        tfService.placeholder = "Dịch vụ"
        tfProvider.placeholder = "Nhà cung cấp"
        tfCode.placeholder = "Mã khách hàng"
        
        continueBtn.setTitle("Tiếp tục", for: .normal)
        lbNote.text = "Lưu ý: Nhằm bảo mật thông tin Khách hàng, nhà cung cấp dịch vụ có thể không hiển thị thông tin Khách hàng. Quý khách cần kiểm tra kỹ thông tin trước khi đăng ký dịch vụ thanh toán tự động."
    }
    
}

extension NCBAutoPaymentRegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfService {
            showServiceList()
            return false
        } else if textField == tfProvider {
            showProviderList()
            return false
        }
        return true
    }
    
}

extension NCBAutoPaymentRegisterViewController {
    
    fileprivate func showServiceList() {
        isChoosingService = true
        tfProvider.text = ""
        provider = nil
        
        var items = [BottomSheetStringItem]()
        
        for service in serviceList {
            items.append(BottomSheetStringItem(title: service.serviceName ?? ""))
        }

        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.delegate = self
            vc.setData("Danh sách dịch vụ", items: items, isHasOptionItem: false)
            showBottomSheet(controller: vc, size: 400)
        }
    }
    
    fileprivate func getProviderList() {
        SVProgressHUD.show()
        providerPresenter?.getListProvider(code: service?.serviceCode ?? "")
    }
    
    fileprivate func showProviderList() {
        isChoosingService = false
        guard let _ = service else {
            showAlert(msg: "Vui lòng chọn dịch vụ")
            return
        }
        
        var items = [BottomSheetStringItem]()
        
        for provider in providerList {
            items.append(BottomSheetStringItem(title: provider.providerName ?? ""))
        }
        
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.delegate = self
            vc.setData("Danh sách nhà cung cấp", items: items, isHasOptionItem: false, isHasSearchView: true)
            showBottomSheet(controller: vc, size: 400)
        }
    }
    
    fileprivate func getBillInfo() {
        if tfCode.text == "" {
            return
        }
        
        guard let serviceProvider = provider else {
            return
        }
        
        let params = [
            "acctNo": sourceAccountView?.getSourceAccount() ?? "",
            "custCode": tfCode.text ?? "",
            "channel": "IB",
            "provider": serviceProvider.providerCode ?? "",
            "serviceCode": serviceProvider.serviceCode ?? "",
            "userName": NCBShareManager.shared.getUser()?.username ?? "",
            "partner": serviceProvider.partner ?? ""
            ] as [String: Any]
        
        SVProgressHUD.show()
        switch serviceProvider.partner {
        case PartnerType.PAYOO.rawValue:
            servicePaymentPresenter?.getBillInfoPayoo(params: params)
        case PartnerType.VNPAY.rawValue:
            servicePaymentPresenter?.getBillInfoVNPAY(params: params)
        case PartnerType.NAPAS.rawValue:
            servicePaymentPresenter?.getBillInfoNapas(params: params)
        default:
            break
        }
    }
    
    fileprivate func showVerifyScreen() {
        if let vc = R.storyboard.servicePayment.ncbVerifyServicePaymentViewController() {
            vc.setData(customerCode: tfCode.text ?? "", customerName: "", address: "", period: "", amount: "", sysTrace: "", service: service, serviceProvider: provider, sourceAccount: sourceAccount, billInfoVNPAY: nil, billInfoPayoo: nil, billInfoNapas: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension NCBAutoPaymentRegisterViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        closeBottomSheet()
        if isChoosingService {
            tfService.text = item
            service = serviceList[index]
            getProviderList()
        } else {
            tfProvider.text = item
            provider = providerList[index]
        }
    }
    
}

extension NCBAutoPaymentRegisterViewController: NCBPayPresenterDelegate {
    
    func getServiceListCompleted(services: [NCBServiceModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        serviceList = services ?? []
    }
    
}

extension NCBAutoPaymentRegisterViewController: NCBServicePaymentPresenterDelegate {
    
    func getBillInfoPayooCompleted(billInfo: NCBBillInfoPayooModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        showVerifyScreen()
    }
    
    func getBillInfoVNPAYCompleted(billInfo: NCBBillInfoVNPAYModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        showVerifyScreen()
    }
    
    func getBillInfoNapasCompleted(billInfo: NCBBillInfoNapasModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        showVerifyScreen()
    }
    
}

extension NCBAutoPaymentRegisterViewController: NCBProviderListPresenterDelegate {
    
    func getListProviderCompleted(providerList: [NCBServiceProviderModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        self.providerList = providerList ?? []
    }
    
}
