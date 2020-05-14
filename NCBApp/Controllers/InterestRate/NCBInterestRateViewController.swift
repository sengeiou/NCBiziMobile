//
//  NCBInterestRateViewController.swift
//  NCBApp
//
//  Created by Thuan on 8/7/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

class NCBInterestRateViewController: NCBBaseViewController {
    
    @IBOutlet weak var vndBtn: UIButton!
    @IBOutlet weak var usdBtn: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lbPeriod: UILabel!
    @IBOutlet weak var lbMethod: UILabel!
    @IBOutlet weak var lbPeriodLast: UILabel!
    @IBOutlet weak var lbPeriod1m: UILabel!
    @IBOutlet weak var lbPeriod3m: UILabel!
    @IBOutlet weak var lbPeriod6m: UILabel!
    @IBOutlet weak var lbPeriod12m: UILabel!
    @IBOutlet weak var lbPeriodFirst: UILabel!
    
    fileprivate var p: NCBInterestRatePresenter?
    fileprivate var dataModels = [NCBInterestRateInfoModel]()
    fileprivate var interestRate: NCBInterestRateModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    
}

extension NCBInterestRateViewController {
    
    override func setupView() {
        super.setupView()
        
        vndBtn.titleLabel?.font = regularFont(size: 12)
        vndBtn.setTitleColor(ColorName.blackText.color, for: .normal)
        vndBtn.setTitleColor(UIColor(hexString: "0083DC"), for: .selected)
        vndBtn.backgroundColor = UIColor(hexString: "D8EAFA")
        vndBtn.isSelected = true
        vndBtn.addTarget(self, action: #selector(changeType(_:)), for: .touchUpInside)
        
        usdBtn.titleLabel?.font = regularFont(size: 12)
        usdBtn.setTitleColor(ColorName.blackText.color, for: .normal)
        usdBtn.setTitleColor(UIColor(hexString: "0083DC"), for: .selected)
        usdBtn.backgroundColor = UIColor(hexString: "EDEDED")
        usdBtn.addTarget(self, action: #selector(changeType(_:)), for: .touchUpInside)
        
        lbPeriod.font = boldFont(size: 12)
        lbPeriod.textColor = UIColor.white
        
        lbMethod.font = boldFont(size: 12)
        lbMethod.textColor = UIColor.white
        
        lbPeriodLast.font = regularFont(size: 10)
        lbPeriodLast.textColor = UIColor.white
        
        lbPeriodFirst.font = regularFont(size: 10)
        lbPeriodFirst.textColor = UIColor.white
        
        lbPeriod1m.font = regularFont(size: 10)
        lbPeriod1m.textColor = UIColor.white
        
        lbPeriod3m.font = regularFont(size: 10)
        lbPeriod3m.textColor = UIColor.white
        
        lbPeriod6m.font = regularFont(size: 10)
        lbPeriod6m.textColor = UIColor.white
        
        lbPeriod12m.font = regularFont(size: 10)
        lbPeriod12m.textColor = UIColor.white
        
        tblView.register(UINib(nibName: R.nib.ncbInterestRateTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbInterestRateTableViewCellID.identifier)
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
        
        p = NCBInterestRatePresenter()
        p?.delegate = self
        
        SVProgressHUD.show()
        p?.getInterestRates(params: ["date": ddMMyyyyFormatter.string(from: Date())])
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        setHeaderTitle("Tra cứu lãi suất")
        vndBtn.setTitle("Loại tiền tệ VND", for: .normal)
        usdBtn.setTitle("Loại tiền tệ USD", for: .normal)
        lbPeriod.text = "Kỳ hạn"
        lbMethod.text = "Phương thức tính lãi(ĐVT%/năm)"
        lbPeriodLast.text = "Cuối kỳ"
        lbPeriodFirst.text = "Đầu kỳ"
        lbPeriod1m.text = "1tháng"
        lbPeriod3m.text = "3tháng"
        lbPeriod6m.text = "6tháng"
        lbPeriod12m.text = "12tháng"
    }
    
    @objc func changeType(_ sender: UIButton) {
        if sender.isSelected {
            return
        }
        
        vndBtn.isSelected = (sender == vndBtn)
        usdBtn.isSelected = (sender == usdBtn)
        
        vndBtn.backgroundColor = vndBtn.isSelected ? UIColor(hexString: "D8EAFA") : UIColor(hexString: "EDEDED")
        usdBtn.backgroundColor = usdBtn.isSelected ? UIColor(hexString: "D8EAFA") : UIColor(hexString: "EDEDED")
        
        dataModels = (vndBtn.isSelected ? interestRate?.restInfoVND : interestRate?.restInfoUSD) ?? []
        tblView.reloadData()
    }
    
}

extension NCBInterestRateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbInterestRateTableViewCellID.identifier, for: indexPath) as! NCBInterestRateTableViewCell
        let info = dataModels[indexPath.row]
        cell.setData(info)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 51
    }
    
}

extension NCBInterestRateViewController: NCBInterestRatePresenterDelegate {
    
    func getInterestRatesCompleted(_ interestRate: NCBInterestRateModel?, error: String?) {
        SVProgressHUD.dismiss()
        
        if let error = error {
            showAlert(msg: error)
            return
        }
        
        self.interestRate = interestRate
        dataModels = interestRate?.restInfoVND ?? []
        tblView.reloadData()
    }
    
}
