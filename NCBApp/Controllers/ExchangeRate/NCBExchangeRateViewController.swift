//
//  NCBExchangeRateViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/6/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBExchangeRateViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var lbTitle1: UILabel!
    @IBOutlet weak var lbTitle2: UILabel!
    @IBOutlet weak var lbCurrency: UILabel!
    @IBOutlet weak var lbExchangeRateBuy: UILabel!
    @IBOutlet weak var lbExchangeRateBuyTM: UILabel!
    @IBOutlet weak var lbExchangeRateBuyCK: UILabel!
    @IBOutlet weak var lbExchangeRateSell: UILabel!
    @IBOutlet weak var lbExchangeRateSellTM: UILabel!
    @IBOutlet weak var lbExchangeRateSellCK: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    fileprivate var p: NCBExchangeRatePresenter?
    fileprivate var dataModels = [NCBExchangeRateInfoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
}

extension NCBExchangeRateViewController {
    
    override func setupView() {
        super.setupView()
        
        lbTitle1.font = regularFont(size: 12)
        lbTitle1.textColor = ColorName.blackText.color
        
        lbTitle2.font = regularFont(size: 12)
        lbTitle2.textColor = ColorName.blackText.color
        
        lbCurrency.font = boldFont(size: 12)
        lbCurrency.textColor = UIColor.white
        
        lbExchangeRateBuy.font = boldFont(size: 12)
        lbExchangeRateBuy.textColor = UIColor.white
        
        lbExchangeRateSell.font = boldFont(size: 12)
        lbExchangeRateSell.textColor = UIColor.white
        
        lbExchangeRateBuyTM.font = regularFont(size: 10)
        lbExchangeRateBuyTM.textColor = UIColor.white
        lbExchangeRateBuyCK.font = regularFont(size: 10)
        lbExchangeRateBuyCK.textColor = UIColor.white
        lbExchangeRateSellTM.font = regularFont(size: 10)
        lbExchangeRateSellTM.textColor = UIColor.white
        lbExchangeRateSellCK.font = regularFont(size: 10)
        lbExchangeRateSellCK.textColor = UIColor.white
        
        tblView.register(UINib(nibName: R.nib.ncbExchangeRateTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbExchangeRateTableViewCellID.identifier)
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
        
        p = NCBExchangeRatePresenter()
        p?.delegate = self
        
        SVProgressHUD.show()
        p?.getExchangeRates(params: ["date": ddMMyyyyFormatter.string(from: Date())])
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setCustomHeaderTitle("Tra cứu tỷ giá Việt Nam Đồng")
        lbCurrency.text = "Ngoại tệ"
        lbExchangeRateBuy.text = "Tỷ giá mua"
        lbExchangeRateSell.text = "Tỷ giá bán"
        lbExchangeRateBuyTM.text = "TM"
        lbExchangeRateBuyCK.text = "CK"
        lbExchangeRateSellTM.text = "TM"
        lbExchangeRateSellCK.text = "CK"
    }
    
}

extension NCBExchangeRateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbExchangeRateTableViewCellID.identifier, for: indexPath) as! NCBExchangeRateTableViewCell
        let info = dataModels[indexPath.row]
        cell.setData(info)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 41
    }
    
}

extension NCBExchangeRateViewController: NCBExchangeRatePresenterDelegate {
    
    func getExchangeRatesCompleted(_ exchangeRate: NCBExchangeRateModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        dataModels = exchangeRate?.rateDetail ?? []
        lbTitle1.text = exchangeRate?.effectDate
        lbTitle2.text = exchangeRate?.everageRate
        tblView.reloadData()
    }
    
}
