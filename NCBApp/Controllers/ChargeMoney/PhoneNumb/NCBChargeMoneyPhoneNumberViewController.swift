//
//  NCBChargeMoneyPhoneNumberViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 6/12/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import ContactsUI

class NCBChargeMoneyPhoneNumberViewController: NCBBaseSourceAccountViewController {

    // MARK: - Outlets
    @IBOutlet weak var phoneNumbTxtF: NewNCBCommonTextField! {
        didSet {
            phoneNumbTxtF.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var nameTextField: NewNCBCommonTextField! {
        didSet {
            nameTextField.keyboardType = .default
        }
    }
    @IBOutlet weak var saveNameLineView: UIView!
    @IBOutlet weak var openContactsBtn: UIButton!
    @IBOutlet weak var valueLbl: UILabel! {
        didSet {
            valueLbl.text = "Mệnh giá nạp tiền (VND)"
        }
    }
    
    @IBOutlet weak var listValueClv: UICollectionView! {
        didSet {
            
            listValueClv.register(UINib(nibName: R.nib.ncbMoneyValueCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.nib.ncbMoneyValueCollectionViewCell.identifier)
            listValueClv.delegate = self
            listValueClv.dataSource = self
        }
    }
    
    @IBOutlet weak var savePhoneNumbBtn: UIButton! {
        didSet {
            savePhoneNumbBtn.setImage(R.image.switch_on(), for: .selected)
            savePhoneNumbBtn.setImage(R.image.switch_off(), for: .normal)
        }
    }
    
    @IBOutlet weak var continueBtn: NCBCommonButton! {
        didSet {
            continueBtn.setTitle("Tiếp tục", for: .normal)
        }
    }
    
    
    // MARK: - Properties
    
    var memName: String?
    var billNo: String?
    
    var listValue: [NCBSendSavingItemModel] = []
    var choosedValue: NCBSendSavingItemModel?
    fileprivate var selectedIndex = -1
    
    var presenter: NCBChargeMoneyPhoneNumberPresenter?
    fileprivate var p: NCBProviderListPresenter?
    let serviceCode = "TOPUP-CARD"
    
    var objects = [CNContact]() // array of PhoneContact(It is model find it below)
    
    var provider: NCBServiceProviderModel?
    
    var saveUser: Bool = false
    
    var numeroADiscar: String = ""
    var userImage: UIImage? = nil
    var nameToSave = ""
    fileprivate var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearData()
        isFirstLoad = false
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
    // MARK: - Actions
    @IBAction func savedPhoneNumb(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        saveUser = sender.isSelected
        nameTextField.isHidden = !saveUser
        saveNameLineView.isHidden = !saveUser
    }
    
    @IBAction func continueTapped(_ sender: UIButton) {
        guard let _phoneNumb = phoneNumbTxtF.text else {
            return
        }
        if _phoneNumb.isEmpty {
            showAlert(msg: "Vui lòng nhập hoặc chọn số điện thoại")
            return
        } else {
            if !_phoneNumb.isPhoneNumber {
                showAlert(msg: "Số điện thoại không hợp lệ, vui lòng kiểm tra lại")
                return
            }
        }
        
        guard let _amt = choosedValue?.value  else {
            showAlert(msg: "Vui lòng chọn số tiền cần nạp")
            return
        }
        
        guard let _amtNumb = Double(_amt) else {
            return
        }
        
        if invalidTransferAmount(_amtNumb, type: .topupPhoneNumb, limitType: .min) {
            showAlert(msg: "TRANSFER-1".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối thiểu 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        if invalidTransferAmount(_amtNumb, type: .topupPhoneNumb, limitType: .max) {
            showAlert(msg: "TRANSFER-2".getMessage()?.replacingOccurrences(of: StringConstant.var1MsgNeedRepalce, with: transferLimitValue) ?? "Hạn mức tối đa 1 lần giao dịch là \(transferLimitValue) VND. Quý khách vui lòng kiểm tra lại")
            return
        }
        
        SVProgressHUD.show()
        checkBalanceRechargeMoney(acctNo: sourceAccount?.acctNo ?? "", amt: _amtNumb)
    }
    
    override func checkBalanceResult(_ result: Bool) {
        SVProgressHUD.dismiss()
        
        if result {
            guard let _phoneNumb = phoneNumbTxtF.text else {
                return
            }
            
            guard let _amtNumb = Double(choosedValue?.value ?? "") else {
                return
            }
            
            let params: [String : Any] = [
                "userName" : NCBShareManager.shared.getUser()?.username ?? "",
                "acctNo" : self.sourceAccount?.acctNo ?? "",
                "billNo" : _phoneNumb,
                "partner" : provider?.partner ?? "",
                "amt" : _amtNumb,
                "mobile" : NCBShareManager.shared.getUser()?.mobile ?? "",
                "typeId" : TransType.rechargePhone.rawValue
            ]
            
            let _vc = NCBChargeMoneyGenerateOTPViewController()
            _vc.sourceAccount = sourceAccount
            _vc.amount = choosedValue?.name
            _vc.targetNumber = phoneNumbTxtF.text
            _vc.params = params
            _vc.transactionType = .topupPhoneNumb
            _vc.didSaveUser = saveUser
            _vc.memName = nameTextField.text
            _vc.exceedLimit = exceedLimit(_amtNumb, type: .topupPhoneNumb)
            self.navigationController?.pushViewController(_vc, animated: true)
        }
    }
    
    @IBAction func openContacts(_ sender: UIButton) {
        let controller = CNContactPickerViewController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func openSavedList(_ sender: Any) {
        let controller = NCBRechargeSavedListViewController()
        controller.onlyMobile = true
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

extension NCBChargeMoneyPhoneNumberViewController {
    
    override func setupView() {
        super.setupView()
        
        setHeaderTitle("NẠP TIỀN ĐIỆN THOẠI")
        
        p = NCBProviderListPresenter()
        SVProgressHUD.show()
        p?.getListProvider(code: serviceCode)
        p?.delegate = self
        
        presenter = NCBChargeMoneyPhoneNumberPresenter()
        presenter?.getListCardValue(params: [:])
        presenter?.delegate = self
        
        phoneNumbTxtF.text = billNo
        if let memName = memName {
            nameTextField.text = memName
            savedPhoneNumb(savePhoneNumbBtn)
        }
    }
    
    fileprivate func clearData() {
        if NCBShareManager.shared.areTrading || isFirstLoad {
            return
        }
        
        phoneNumbTxtF.text = ""
        saveUser = false
        selectedIndex = -1
        listValueClv.reloadData()
        savePhoneNumbBtn.isSelected = saveUser
        nameTextField.isHidden = !saveUser
        saveNameLineView.isHidden = !saveUser
    }
    
}

extension NCBChargeMoneyPhoneNumberViewController: NCBRechargeSavedListViewControllerDelegate {
    
    func phoneItemDidSelect(_ item: NCBBenfitPhoneModel) {
        phoneNumbTxtF.text = item.billNo
        if let memName = item.menName {
            nameTextField.text = memName
            savedPhoneNumb(savePhoneNumbBtn)
        }
    }
    
}

extension NCBChargeMoneyPhoneNumberViewController: NCBChargeMoneyPhoneNumberPresenterDelegate {
    
    func getListCardValueCompleted(cardValues: [NCBSendSavingItemModel]?, error: String?) {
        if let _error = error {
            showAlert(msg: _error)
        }
        
        self.listValue = cardValues ?? []
        listValueClv.reloadData()
    }
}

extension NCBChargeMoneyPhoneNumberViewController: NCBProviderListPresenterDelegate {
    
    func getListProviderCompleted(providerList: [NCBServiceProviderModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        if let providerList = providerList {
            if providerList.count > 0 {
                self.provider = providerList[0]
            }
        }
    }
    
}


extension NCBChargeMoneyPhoneNumberViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.dismiss(animated: true, completion: nil)
        //See if the contact has multiple phone numbers
        if contact.phoneNumbers.count > 1 {
            
            //If so we need the user to select which phone number we want them to use
            let multiplePhoneNumbersAlert = UIAlertController(title: nil, message: "Vui lòng chọn số điện thoại cần nạp tiền.", preferredStyle: .alert)
            
            //Loop through all the phone numbers that we got back
            for number in contact.phoneNumbers {
                
                //Each object in the phone numbers array has a value property that is a CNPhoneNumber object, Make sure we can get that
                let actualNumber = number.value as CNPhoneNumber
                
                //Get the label for the phone number
                var phoneNumberLabel = number.label
                
                //Strip off all the extra crap that comes through in that label
                phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "_", with: "")
                phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "$", with: "")
                phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "!", with: "")
                phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "<", with: "")
                phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: ">", with: "")
                
                //Create a title for the action for the UIAlertVC that we display to the user to pick phone numbers
                let actionTitle = actualNumber.stringValue
                
                //Create the alert action
                let numberAction = UIAlertAction(title: actionTitle, style: .default, handler: {(theAction) -> Void in
                    
                    //See if we can get A frist name
                    if contact.givenName == "" {
                        
                        //If Not check for a last name
                        if contact.familyName == "" {
                            //If no last name set name to Unknown Name
                            self.nameToSave = "Unknown Name"
                        }else{
                            self.nameToSave = contact.familyName
                        }
                        
                    } else {
                        
                        self.nameToSave = contact.givenName
                        
                    }
                    
                    // See if we can get image data
                    if let imageData = contact.imageData {
                        //If so create the image
                        self.userImage = UIImage(data: imageData)!
                    }
                    
                    //Do what you need to do with your new contact information here!
                    //Get the string value of the phone number like this:
                    self.numeroADiscar = actualNumber.stringValue
                    
                    self.phoneNumbTxtF.text = actualNumber.stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted)
                        .joined()
                    self.nameTextField.text = self.nameToSave
                })
                
                //Add the action to the AlertController
                multiplePhoneNumbersAlert.addAction(numberAction)
                
            }
            
            //Add a cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (theAction) -> Void in
                //Cancel action completion
            })
            
            //Add the cancel action
            multiplePhoneNumbersAlert.addAction(cancelAction)
            
            //Present the ALert controller
            self.present(multiplePhoneNumbersAlert, animated: true, completion: nil)
        } else {
            
            //Make sure we have at least one phone number
            if contact.phoneNumbers.count > 0 {
                
                //If so get the CNPhoneNumber object from the first item in the array of phone numbers
                let actualNumber = (contact.phoneNumbers.first?.value)! as CNPhoneNumber
                
                //Get the label of the phone number
                var phoneNumberLabel = contact.phoneNumbers.first!.label
                
                //Strip out the stuff you don't need
                phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "_", with: "")
                phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "$", with: "")
                phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "!", with: "")
                phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "<", with: "")
                phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: ">", with: "")
                
                //Create an empty string for the contacts name
                self.nameToSave = ""
                //See if we can get A frist name
                if contact.givenName == "" {
                    //If Not check for a last name
                    if contact.familyName == "" {
                        //If no last name set name to Unknown Name
                        self.nameToSave = "Unknown Name"
                    }else{
                        self.nameToSave = contact.familyName
                    }
                } else {
                    nameToSave = contact.givenName
                }
                
                // See if we can get image data
                if let imageData = contact.imageData {
                    //If so create the image
                    self.userImage = UIImage(data: imageData)
                }
                
                //Do what you need to do with your new contact information here!
                //Get the string value of the phone number like this:
                self.numeroADiscar = actualNumber.stringValue
                
                self.phoneNumbTxtF.text = actualNumber.stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted)
                    .joined()
                self.nameTextField.text = self.nameToSave
            } else {
                
                //If there are no phone numbers associated with the contact I call a custom funciton I wrote that lets me display an alert Controller to the user
                let alert = UIAlertController(title: "Missing info", message: "You have no phone numbers associated with this contact", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
                
            }
        }
    }

}

extension NCBChargeMoneyPhoneNumberViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.ncbMoneyValueCollectionViewCell.identifier, for: indexPath) as! NCBMoneyValueCollectionViewCell
        item.setDataForItem(listValue[indexPath.row], isSelected: (selectedIndex == indexPath.row))
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 48) / 3, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let item = listValue[indexPath.item]
        self.choosedValue = item
        listValueClv.reloadData()
    }
}

