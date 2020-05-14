//
//  NCBRegisterNewAccountViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBRegisterNewAccountViewController: NCBBaseViewController {
    
    @IBOutlet weak var titleLbl: UILabel! {
        didSet {
            titleLbl.font = regularFont(size: 12)
            titleLbl.textColor = UIColor.black
            titleLbl.text = "Quý khách vui lòng chọn sản phẩm tài khoản"
        }
    }
    
    @IBOutlet weak var productTbv: UITableView! {
        didSet {
            
            productTbv.register(UINib(nibName: R.nib.ncbRegisterNewAccMainTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbRegisterNewAccMainTableViewCellID.identifier)
            productTbv.separatorStyle = .none
            productTbv.estimatedRowHeight = 90
            productTbv.rowHeight = UITableView.automaticDimension
            productTbv.delegate = self
            productTbv.dataSource = self
        }
    }
    
    var products:[NCBRegisterNewServiceProductModel] = []
    var presenter: NCBRegisterNewAcctPresenter?
    fileprivate var refreshTokenPresenter: NCBOTPAuthenticationPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func showNavigationBarBackground() -> Bool {
        return true
    }
}

extension NCBRegisterNewAccountViewController {
    
    override func setupView() {
        super.setupView()
        
        presenter = NCBRegisterNewAcctPresenter()
        presenter?.delegate = self
        
        refreshTokenPresenter = NCBOTPAuthenticationPresenter()
        refreshTokenPresenter?.delegate = self
        
        SVProgressHUD.show()
        refreshTokenPresenter?.refreshToken()
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Đăng ký mở tài khoản")
    }
}

extension NCBRegisterNewAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbRegisterNewAccMainTableViewCellID.identifier, for: indexPath) as! NCBRegisterNewAccMainTableViewCell
        
        let row = indexPath.row
        let item = products[row]
        cell.titleLbl.text = item.name
        return cell
        
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = R.storyboard.registerNewAcct.ncbRegisterNewAcctDetailViewController() {
            let row = indexPath.row
            let item = products[row]
            vc.setData(data: item)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
  
}

extension NCBRegisterNewAccountViewController: NCBOTPAuthenticationPresenterDelegate {
    
    func refreshTokenCompleted(error: String?) {
        var params: [String: Any] = [:]
        params["cif"] = NCBShareManager.shared.getUser()!.cif
        presenter?.getProductOpenAcountOnline(params: params)
    }
    
}

extension NCBRegisterNewAccountViewController:NCBRegisterNewAcctPresenterDelegate {
    
    func getProductOpenAcountOnline(services: [NCBRegisterNewServiceProductModel]?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            products = services ?? []
            productTbv.reloadData()
        }
    }
    
}
