//
//  NCBCustomerSupportHomeViewController.swift
//  NCBApp
//
//  Created by Van Dong on 06/08/2019.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

enum CustomerSupportCellType: Int {
    case customerInfo  = 0
    case exchangeRate
    case interestRate
    case atmBranch
    case userGuide
    case requentlyAskedQuestions
    case feedback
    
    case none
}

struct CustomerSupportCellMenuItem {
    var title = ""
    var type: CustomerSupportCellType = .customerInfo
    var image: String = ""
}

class NCBCustomerSupportHomeViewController: NCBBaseViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    fileprivate var dataModels = [CustomerSupportCellMenuItem]()
    fileprivate var p: NCBCustomerSupportPresenterDelegate?
    var hiddenCustomerInfo = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func showNavigationBarBackground() -> Bool {
        return true
    }
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Hỗ trợ khách hàng")
    }
    
}

extension NCBCustomerSupportHomeViewController {
    
    override func setupView() {
        super.setupView()
        
        getDataModels()
        
        homeTableView.register(UINib(nibName: R.nib.ncbMenuTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbMenuTableViewCellID.identifier)
        homeTableView.separatorStyle = .none
        homeTableView.delegate = self
        homeTableView.dataSource = self
    }
    fileprivate func getDataModels() {
        dataModels.append(CustomerSupportCellMenuItem(title: "Thông tin khách hàng", type: .customerInfo, image: R.image.ic_customerSupport_customerInfo.name))
        dataModels.append(CustomerSupportCellMenuItem(title: "Tra cứu tỉ giá", type: .exchangeRate, image: R.image.ic_customerSupport_exchangeRate.name))
        dataModels.append(CustomerSupportCellMenuItem(title: "Tra cứu lãi suất", type: .interestRate, image: R.image.ic_customerSupport_interestRate.name))
        dataModels.append(CustomerSupportCellMenuItem(title: "Mạng lưới NCB", type: .atmBranch, image: R.image.ic_customerSupport_atmBranch.name))
        dataModels.append(CustomerSupportCellMenuItem(title: "Hướng dẫn sử dụng", type: .userGuide, image: R.image.ic_customerSupport_userGuid.name))
        dataModels.append(CustomerSupportCellMenuItem(title: "Câu hỏi thường gặp", type: .requentlyAskedQuestions, image: R.image.ic_customerSupport_requentlyQuestion.name))
        dataModels.append(CustomerSupportCellMenuItem(title: "Góp ý báo lỗi ứng dụng", type: .feedback, image: R.image.ic_customerSupport_feedbackErrorApplication.name))
    }
}

extension NCBCustomerSupportHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbMenuTableViewCellID.identifier, for: indexPath) as! NCBMenuTableViewCell
        cell.selectionStyle = .none
        let item = dataModels[indexPath.row]
        if hiddenCustomerInfo && indexPath.row == CustomerSupportCellType.customerInfo.rawValue {
            cell.lbTitle.text = ""
            cell.iconView.image = nil
            cell.separatorView.isHidden = true
        } else {
            cell.lbTitle.text = item.title
            cell.iconView.image = UIImage(named: item.image)?.withRenderingMode((indexPath.row == CustomerSupportCellType.customerInfo.rawValue) ? .alwaysOriginal : .alwaysTemplate)
            cell.iconView.tintColor = UIColor(hexString: "0083DC")
            cell.separatorView.isHidden = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if hiddenCustomerInfo && indexPath.row == CustomerSupportCellType.customerInfo.rawValue {
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataModels[indexPath.row]
        switch item.type {
        case .customerInfo:
            if let vc = R.storyboard.customerSupport.ncbCustomerInfomationViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .exchangeRate:
            if let vc = R.storyboard.exchangeRate.ncbExchangeRateViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .interestRate:
            if let vc = R.storyboard.exchangeRate.ncbInterestRateViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .atmBranch:
            self.navigationController?.pushViewController(NCBNetViewController(), animated: true)
        case .userGuide:
//            if let vc = R.storyboard.customerSupport.ncbUserGuideViewController() {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            if let url = URL(string: "https://www.ncb-bank.vn/huongdan/Guide_NCB_iziMobile.pdf"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        case .requentlyAskedQuestions:
            if let vc = R.storyboard.customerSupport.ncbFrequentlyQuestionViewController() {
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .feedback:
            if let vc = R.storyboard.customerSupport.ncbFeedbackToApplicationErrorViewController(){
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
    
}
