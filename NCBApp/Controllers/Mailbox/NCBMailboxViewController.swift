//
//  NCBMailboxViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/9/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
class NCBMailboxViewController: NCBBaseViewController {
    
    @IBOutlet weak var mailboxTbv: UITableView! {
        didSet {
            mailboxTbv.register(UINib(nibName: R.nib.ncbMailboxTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbMailboxTableViewCellID.identifier)
            mailboxTbv.separatorStyle = .none
            mailboxTbv.estimatedRowHeight = 100
            mailboxTbv.rowHeight = UITableView.automaticDimension
            mailboxTbv.delegate = self
            mailboxTbv.dataSource = self
        }
    }
    var mails:[NCBMailboxModel] = []
    var mailsSort:[NCBMailboxModel] = []
    var presenter:NCBMailboxPresenter?
    var isSort = false
    var deleteIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func showNavigationBarBackground() -> Bool {
        return true
    }
}

extension NCBMailboxViewController {
    
    override func setupView() {
        super.setupView()
        addSortRightBarItem()
        presenter = NCBMailboxPresenter()
        presenter?.delegate = self
        SVProgressHUD.show()
        
        var params: [String: Any] = [:]
        params["userName"] = NCBShareManager.shared.getUser()!.username
        print(params)
        presenter?.getEmailInfo(params: params)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        setHeaderTitle("Hộp thư")
    }
    
    func addSortRightBarItem() {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setImage(R.image.ic_sort(), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        button.addTarget(self, action: #selector(sortMail), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: hasTopNotch ? 10 : 25, left: 15, bottom: 0, right: 0)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func sortMail() {
        if isSort == false{
            isSort = true
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let today = Date()
            let ready = mails.sorted(by: { dateFormatter.date(from:$0.createdDate)?.compare(dateFormatter.date(from:$1.createdDate) ?? today) == .orderedDescending })
            print(ready)
            mailsSort = ready
            mailboxTbv.reloadData()
        }else{
            isSort = false
            mailsSort = mails
            mailboxTbv.reloadData()
        }
    }
}

extension NCBMailboxViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mailsSort.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbMailboxTableViewCellID.identifier, for: indexPath) as! NCBMailboxTableViewCell
        cell.customDelegate = self
        
        let row = indexPath.row
        let item = mailsSort[row]
        cell.setData(data: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let item = mailsSort[row]
        if let vc = R.storyboard.mailbox.ncbMailboxDetailViewController() {
            vc.setupData(data: item)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
}

extension NCBMailboxViewController: NCBMailboxPresenterDelegate{
    func getEmailInfo(services: [NCBMailboxModel]?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            mails = services ?? []
            mailsSort = mails
            mailboxTbv.reloadData()
        }
    }
    func updateStatusEmail(services: String?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            
        }
    }
    func deleteEmail(services: String?, error: String?) {
        SVProgressHUD.dismiss()
        if let _error = error {
            showAlert(msg: _error)
        }else{
            mails.remove(at: deleteIndex)
            mailsSort = mails
            mailboxTbv.reloadData()
        }
    }
}

extension NCBMailboxViewController: NCBMailboxTableViewCellDelegate{
    func deleteAction(item: NCBMailboxModel, indx: Int) {
        deleteIndex = indx
        var params: [String: Any] = [:]
        params["userName"] = NCBShareManager.shared.getUser()!.username
        params["emailId"] = item.emailId
        print(params)
        SVProgressHUD.show()
        presenter?.deleteEmail(params: params)
    }
}
