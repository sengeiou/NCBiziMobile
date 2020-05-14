//
//  NCBRegisterVidAcctViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBRegisterVidAcctViewController: NCBBaseViewController {
    
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.font = regularFont(size: 12.0)
            titleLbl.textColor = UIColor.black
            titleLbl.text = "Chọn tài khoản số đẹp theo các số cuối"
        }
    }
    
    @IBOutlet weak var tailNumberClv: UICollectionView! {
        didSet {
            tailNumberClv.register(UINib(nibName: R.nib.ncbTailNumberCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: R.reuseIdentifier.ncbTailNumberCollectionViewCellID.identifier)
            tailNumberClv.delegate = self
            tailNumberClv.dataSource = self
          
        }
    }
    
    @IBOutlet weak var inputTf: UITextField! {
        didSet {
            
            inputTf.font = semiboldFont(size: 28)
            inputTf.textColor = UIColor(hexString: ColorName.blurNormalText.rawValue)
            inputTf.borderStyle = .none
            inputTf.keyboardType = .numberPad
            inputTf.delegate = self
        }
    }
    
    @IBOutlet weak var lineView: UIView! {
        didSet {
            lineView.backgroundColor =  UIColor(hexString:"02A9E9")
        }
    }
    
    @IBOutlet weak var returnAccountTbv: UITableView! {
        didSet {
            returnAccountTbv.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
            returnAccountTbv.separatorStyle = .singleLine
            returnAccountTbv.estimatedRowHeight = 50
            returnAccountTbv.rowHeight = UITableView.automaticDimension
            returnAccountTbv.delegate = self
            returnAccountTbv.dataSource = self
        }
    }
    
    @IBOutlet weak var checkBtn: UIButton! {
        didSet {
            let attributeString = NSMutableAttributedString(string: "Kiểm tra",
                                                            attributes: attributes)
            checkBtn.setAttributedTitle(attributeString, for: .normal)
            checkBtn.backgroundColor = UIColor.clear
        }
    }
    
  @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    var selectTailNumberIndex = 0
    var selectTailNumber = 0
    var isCheck = true
    var tailNumberModel:[NCBTailNumberModel]=[]
    var returnNumberModel: [NCBReturnNumberModel]=[]
    let attributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font : semiboldFont(size: 12),
        NSAttributedString.Key.foregroundColor : UIColor(hexString: ColorName.buttonBlueText.rawValue),
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    
    
    @IBAction func checkAction(_ sender: Any) {
        var params: [String: Any] = [:]
        params["niceNumber"] = inputTf.text
        presenter?.getNiceAccountInfo(params: params)

    }
    
    var product:NCBRegisterNewServiceProductModel!
    var presenter: NCBRegisterNewAcctPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func showNavigationBarBackground() -> Bool {
        return true
    }
}

extension NCBRegisterVidAcctViewController {
    
    override func setupView() {
        super.setupView()
        presenter = NCBRegisterNewAcctPresenter()
        presenter?.delegate = self
        SVProgressHUD.show()
        presenter?.getListTypeNiceNumber(params: [:])

    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Đăng ký mở tài khoản")
    }
    func setData(data:NCBRegisterNewServiceProductModel) {
        self.product = data
    }
}

extension NCBRegisterVidAcctViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return tailNumberModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.ncbTailNumberCollectionViewCellID.identifier, for: indexPath) as! NCBTailNumberCollectionViewCell
        let row = indexPath.row
        let item = tailNumberModel[row]
        cell.titleLbl.text = item.value
        if row == selectTailNumberIndex{
            cell.setBackgroundSelect()
        }else{
            cell.setBackgroundNormal()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 46, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let item = tailNumberModel[row]
        let title = item.value ?? ""
        selectTailNumberIndex = row
        selectTailNumber = Int(title) ?? 0
        tailNumberClv.reloadData()
    }
    
}

extension NCBRegisterVidAcctViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnNumberModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! UITableViewCell
        let item = returnNumberModel[indexPath.row]
        cell.textLabel?.text = item.accountNo
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = regularFont(size: 24)
        cell.textLabel?.textColor = UIColor(hexString: ColorName.blurNormalText.rawValue)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let item = tailNumberModel[row]
        let accNew = returnNumberModel[row]
        
        if inputTf.text == "" {
            showAlert(msg: "Vui lòng nhập đuôi")
            return
        }
        let txtCount = inputTf.text?.count ?? 0
        if txtCount<selectTailNumber {
            showAlert(msg: "Vui lòng nhập đủ đuôi")
            return
        }
        
        if let vc = R.storyboard.registerNewAcct.ncbRegisterVidAcctDetailViewController() {
            vc.setData(product: product, tailNumber: item, newAcc: accNew)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
  
}

extension NCBRegisterVidAcctViewController:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count == 0 && range.length > 0 {
            // Back pressed
            return true
        }
        
        let countTxt = textField.text?.count ?? 0
        if countTxt < selectTailNumber {
            return true
        }else{
            return false
        }

        let numericRegEx = "[0-9]"
        let predicate = NSPredicate(format:"SELF MATCHES %@", numericRegEx)
        let newText = (textField.text as! NSString).replacingCharacters(in: range, with: string)
        return predicate.evaluate(with: string)
    }
    
}

extension NCBRegisterVidAcctViewController:NCBRegisterNewAcctPresenterDelegate {
    
    func getListTypeNiceNumber(services: [NCBTailNumberModel]?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            tailNumberModel = services ?? []
            if tailNumberModel.count>0{
                let item = tailNumberModel[0]
                let title = item.value ?? ""
                selectTailNumber = Int(title) ?? 0
            }
            tailNumberClv.reloadData()
            
        }
    }
    func getNiceAccountInfo(services: [NCBReturnNumberModel]?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            returnNumberModel = services ?? []
            returnAccountTbv.reloadData()
            tableHeightConstraint.constant = CGFloat(returnNumberModel.count*50)
            let attributeString = NSMutableAttributedString(string: "Tìm lại",
                                                            attributes: attributes)
            checkBtn.setAttributedTitle(attributeString, for: .normal)
        }

    }
 
}
