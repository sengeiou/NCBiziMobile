//
//  NCBNewRegisterVidAcctViewController.swift
//  NCBApp
//
//  Created by ADMIN on 9/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

fileprivate let widthInputView = 32

class NCBNewRegisterVidAcctViewController: NCBBaseViewController {
    
    @IBOutlet weak var scroll: UIScrollView! {
        didSet {
        }
    }
    @IBOutlet weak var tailNumberTf: NewNCBCommonTextField! {
        didSet {
            tailNumberTf.placeholder = "Chọn tài khoản số đẹp theo"
            tailNumberTf.addRightArrow(true)
            tailNumberTf.delegate = self
        }
    }
    @IBOutlet weak var widthInputNumberView: NSLayoutConstraint!
    @IBOutlet var inputNumberView: UIView! {
        didSet {
        }
    }
    
    @IBOutlet weak var lineView: UIView! {
        didSet {
            lineView.backgroundColor = UIColor(hexString: "BBBBBB")
        }
    }
    
    @IBOutlet weak var returnAccountTbv: UITableView! {
        didSet {
            returnAccountTbv.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
            returnAccountTbv.separatorStyle = .none
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
    @IBOutlet weak var continueBtn: NCBCommonButton! {
        didSet {
            continueBtn.setTitle("Tiếp tục", for: .normal)
            continueBtn.isHidden = true
        }
    }
    
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    var selectTailNumberIndex = 0
    var selectTailNumber = 0
    var tailNumberModel:[NCBTailNumberModel]=[]
    var returnNumberModel: [NCBReturnNumberModel]=[]
    let attributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font : semiboldFont(size: 12)!,
        NSAttributedString.Key.foregroundColor : UIColor(hexString: ColorName.buttonBlueText.rawValue),
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    var tailNumberString = ""
    var akOptView: AKOtpView?
    
    @IBAction func checkAction(_ sender: Any) {
        if let otpView = akOptView, !otpView.enoughInfo {
            showAlert(msg: "Vui lòng nhập đủ \(selectTailNumber) số cuối.")
            return
        }
        
        var params: [String: Any] = [:]
        params["niceNumber"] = tailNumberString
        
        SVProgressHUD.show()
        presenter?.getNiceAccountInfo(params: params)
        
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if returnNumberModel.count < 1 {
            return
        }
        
        let item = tailNumberModel[selectTailNumberIndex]
        let accNew = returnNumberModel[0]
        
        if let vc = R.storyboard.registerNewAcct.ncbRegisterVidAcctDetailViewController() {
            vc.setData(product: product, tailNumber: item, newAcc: accNew)
            self.navigationController?.pushViewController(vc, animated: true)
        }
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

extension NCBNewRegisterVidAcctViewController {
    
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

    func setupInputNumberView() {
        if akOptView == nil{
            widthInputNumberView.constant = CGFloat(widthInputView*selectTailNumber)
            akOptView = AKOtpView()
            akOptView!.textNormalColor = UIColor.black
            akOptView!.numberOfDigits = selectTailNumber
            akOptView!.setupView(withFont: semiboldFont(size: 24)) { [weak self] (code) in
                self?.tailNumberString = code
            }
            akOptView!.initView(CGFloat(widthInputView*selectTailNumber))
            inputNumberView.addSubview(akOptView!)
            
            akOptView!.snp.makeConstraints { (make) in
                make.leading.top.equalToSuperview()
                make.width.height.equalToSuperview()
            }
        }
    }
    
    func removeInputNumberView(){
        if akOptView != nil{
            akOptView!.removeFromSuperview()
            akOptView = nil
        }
    }
    
    func showList() {
        var items = [BottomSheetStringItem]()
        for item in tailNumberModel {
            let name = item.name ?? ""
            items.append(BottomSheetStringItem(title: name, isCheck: false))
        }
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.setData("Chọn tài khoản số đẹp theo", items: items, isHasOptionItem: true)
            vc.delegate = self
            showBottomSheet(controller: vc, size: 400)
        }
    }
}

extension NCBNewRegisterVidAcctViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnNumberModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        let item = returnNumberModel[indexPath.row]
        cell.textLabel?.text = item.accountNo
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = regularFont(size: 24)
        cell.textLabel?.textColor = UIColor(hexString: ColorName.blurNormalText.rawValue)
        cell.selectionStyle = .none
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension NCBNewRegisterVidAcctViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showList()
        return false
    }
    
}

extension NCBNewRegisterVidAcctViewController:NCBRegisterNewAcctPresenterDelegate {
    
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
                tailNumberTf.text = item.name ?? ""
                removeInputNumberView()
                setupInputNumberView()
            }
            //tailNumberClv.reloadData()
        }
    }
    func getNiceAccountInfo(services: [NCBReturnNumberModel]?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let _error = error {
            showAlert(msg: _error)
        }else{
            continueBtn.isHidden = (services?.count == 0)
            returnNumberModel = services ?? []
            returnAccountTbv.reloadData()
            tableHeightConstraint.constant = CGFloat(returnNumberModel.count*50)
            let attributeString = NSMutableAttributedString(string: "Tìm lại",
                                                            attributes: attributes)
            checkBtn.setAttributedTitle(attributeString, for: .normal)
        }
    }
}
extension NCBNewRegisterVidAcctViewController: NCBBottomSheetListViewControllerDelegate {
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        removeBottomSheet()
        selectTailNumberIndex = index
        let item = tailNumberModel[index]
        let title = item.value ?? ""
        selectTailNumber = Int(title) ?? 0
        tailNumberTf.text = item.name ?? ""
        removeInputNumberView()
        setupInputNumberView()
    }
}
