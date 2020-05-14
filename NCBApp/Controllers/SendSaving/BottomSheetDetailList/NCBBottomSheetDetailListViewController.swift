//
//  NCBBottomSheetDetailListViewController.swift
//  NCBApp
//
//  Created by ADMIN on 8/20/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

struct BottomSheetDetailStringItem {
    var title = ""
    var detail = ""
    var isCheck: Bool?
    
    init(title: String, detail: String,isCheck: Bool? = nil) {
        self.title = title
        self.detail = detail
        self.isCheck = (isCheck != nil) ? isCheck : false
    }
}

protocol NCBBottomSheetDetailListViewControllerDelegate {
    func bottomSheetDetailListDidSelectItem(_ item: String, index: Int)
}

class NCBBottomSheetDetailListViewController: NCBBaseViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var sheetTbv: UITableView!
    @IBOutlet weak var lineView: UIView!{
        didSet{
        }
    }
    //MARK: Properties
    
    fileprivate var items = [BottomSheetDetailStringItem]()
    fileprivate var strTitle = ""
    fileprivate var isHasOptionItem = false
    
    var delegate: NCBBottomSheetDetailListViewControllerDelegate?
    var itemDidSelect: BottomSheetCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension NCBBottomSheetDetailListViewController {
    
    override func setupView() {
        super.setupView()
    
        titleLbl.font = semiboldFont(size: 14)
        titleLbl.textColor = ColorName.blurNormalText.color
        titleLbl.text = strTitle
        
        sheetTbv.register(UINib(nibName: R.nib.ncbBottomSheetDetailListTableCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbBottomSheetDetailListTableCellID.identifier)
        sheetTbv.separatorStyle = .none
        sheetTbv.delegate = self
        sheetTbv.dataSource = self
    }
    
    override func loadLocalized() {
        super.loadLocalized()
    }
    
    func setData(_ title: String, items: [BottomSheetDetailStringItem], isHasOptionItem: Bool, isHasSearchView: Bool? = false) {
        self.strTitle = title
        self.items = items
        self.isHasOptionItem = isHasOptionItem
        
    }
    
}

extension NCBBottomSheetDetailListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbBottomSheetDetailListTableCellID.identifier, for: indexPath) as! NCBBottomSheetDetailListTableCell
        let item = items[indexPath.row]
        cell.titleLbl.text = item.title
        cell.detailLbl.text = item.detail
        cell.isHiddenOption(!isHasOptionItem)
        cell.checkBtn.isSelected = item.isCheck!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.bottomSheetDetailListDidSelectItem(items[indexPath.row].title, index: indexPath.row)
        } else {
            itemDidSelect?(items[indexPath.row].title, indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
