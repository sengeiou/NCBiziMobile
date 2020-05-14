//
//  NCBFeedbackToApplicationViewController.swift
//  NCBApp
//
//  Created by Van Dong on 06/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBFeedbackToApplicationViewController: NCBBaseViewController {
    
    @IBOutlet weak var tfType: NewNCBCommonTextField!
    @IBOutlet weak var tfProduct: NewNCBCommonTextField!
    @IBOutlet weak var tfContent: NCBContentTextField!
    @IBOutlet weak var sendBtn: NCBStatementButton!
    
    fileprivate var p: NCBCustomerSupportPresenter?
    fileprivate var options: NCBFeedbackModel?
    fileprivate var typeItems = [String]()
    fileprivate var productItems = [String]()
    fileprivate var typeIndex: Int?
    fileprivate var productIndex: Int?
    fileprivate var isShowingType = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    override func setupView() {
        super.setupView()
        
        tfType.placeholder = "Loại góp ý"
        tfType.addRightArrow(true)
        tfType.delegate = self
        tfProduct.placeholder = "Loại sản phẩm"
        tfProduct.addRightArrow(true)
        tfProduct.delegate = self
        tfContent.placeholder = "Nội dung góp ý/Báo lỗi"
        tfContent.allowUnlimit = true
        sendBtn.setTitle("Gửi góp ý", for: .normal)
        sendBtn.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        
        p = NCBCustomerSupportPresenter()
        p?.delegate = self
        
        SVProgressHUD.show()
        p?.getDataOptionFeedback()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setCustomHeaderTitle("Góp ý/Báo lỗi ứng dụng")
    }
    
    @objc func sendAction() {
        guard let typeIndex = typeIndex else {
            showAlert(msg: "Vui lòng chọn loại góp ý")
            return
        }
        
        guard let type = options?.lstFeedbackType?[typeIndex] else {
            showAlert(msg: "Vui lòng chọn loại góp ý")
            return
        }
        
        guard let productIndex = productIndex else {
            showAlert(msg: "Vui lòng chọn loại sản phẩm")
            return
        }
        
        guard let product = options?.lstProductService?[productIndex] else {
            showAlert(msg: "Vui lòng chọn loại sản phẩm")
            return
        }
        
        if tfContent.text == "" {
            showAlert(msg: "Vui lòng nhập nội dung")
            return
        }
        
        let params: [String: Any] = [
            "address": "",
            "description": tfContent.text ?? "",
            "email": "",
            "name": NCBShareManager.shared.getUser()?.fullname ?? "",
            "phone": NCBShareManager.shared.getUser()?.mobile ?? "",
            "productCode": product.code ?? "",
            "productName": product.name ?? "",
            "type": type.value ?? "",
        ]
        
        SVProgressHUD.show()
        p?.sendFeedback(params: params)
    }
    
    fileprivate func showType() {
        isShowingType = true
        var models = [BottomSheetStringItem]()
        for item in typeItems {
            models.append(BottomSheetStringItem(title: item, isCheck: item == tfType.text!))
        }
        
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.delegate = self
            vc.setData("Chọn loại góp ý", items: models, isHasOptionItem: true)
            showBottomSheet(controller: vc, size: 350)
        }
    }
    
    fileprivate func showProduct() {
        isShowingType = false
        var models = [BottomSheetStringItem]()
        for item in productItems {
            models.append(BottomSheetStringItem(title: item, isCheck: item == tfProduct.text!))
        }
        
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.delegate = self
            vc.setData("Chọn loại sản phẩm", items: models, isHasOptionItem: true)
            showBottomSheet(controller: vc, size: 350)
        }
    }

}

extension NCBFeedbackToApplicationViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case tfType:
            showType()
        default:
            showProduct()
        }
        return false
    }
    
}

extension NCBFeedbackToApplicationViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        closeBottomSheet()
        if isShowingType {
            tfType.text = item
            typeIndex = index
        } else {
            tfProduct.text = item
            productIndex = index
        }
    }
    
}

extension NCBFeedbackToApplicationViewController: NCBCustomerSupportPresenterDelegate {
    
    func getDataOptionFeedbackCompleted(options: NCBFeedbackModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        self.options = options
        
        if let options = options?.lstFeedbackType {
            for option in options {
                typeItems.append(option.name ?? "")
            }
        }
        
        if let options = options?.lstProductService {
            for option in options {
                productItems.append(option.name ?? "")
            }
        }
    }
    
    func sendFeedbackCompleted(error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        showError(msg: "NCB đã nhận được nội dung góp ý/báo lỗi của Quý khách về ứng dụng \(appName). Cảm ơn Quý khách đã luôn tin dùng sản phẩm dịch vụ NCB") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
