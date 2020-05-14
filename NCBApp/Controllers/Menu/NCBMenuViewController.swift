//
//  NCBMenuViewController.swift
//  NCBApp
//
//  Created by Thuan on 4/5/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import SwiftyAttributes

enum CellType: Int {
    case accountInfo = 0
    case transfer
    case payTheBill
    case recharge
    case saving
    case cardService
    case credit
    case registerNewService
    case searchTransaction
    case otherService
    case userSupport
    case setting
    case mailbox
    case logout
}

struct CellMenuItem {
    var title = ""
    var type: CellType = .accountInfo
    var image: String = ""
}

class NCBMenuViewController: NCBBaseViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var topSpaceAvatarImgView: NSLayoutConstraint!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbCIFNumber: UILabel!
    @IBOutlet weak var lbPackage: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var hotLineBtn:UIButton!{
        didSet{
            hotLineBtn.layer.shadowColor = UIColor.black.cgColor
            hotLineBtn.layer.shadowOffset = CGSize(width: 0, height: 0)
            hotLineBtn.layer.shadowRadius = 5
            hotLineBtn.layer.shadowOpacity = 0.5
        }
    }
     
    @IBAction func callSupport(_ sender: Any) {
        showContact()
    }
    
    //MARK: Properties
    
    fileprivate var dataModels = [CellMenuItem]()
    fileprivate var imagePicker = UIImagePickerController()
    fileprivate var isRegisterNewCard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
}

extension NCBMenuViewController {
    
    override func setupView() {
        super.setupView()
        
        lbUserName.font = semiboldFont(size: 18)
        lbUserName.textColor = UIColor.white
        lbCIFNumber.font = regularFont(size: 12)
        lbCIFNumber.textColor = UIColor.white
        lbPackage.font = regularFont(size: 12)
        lbPackage.textColor = UIColor.white
        
        if hasTopNotch {
            topSpaceAvatarImgView.constant = 5
        }
        
        getDataModels()
        
        tblView.register(UINib(nibName: R.nib.ncbMenuTableViewCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.ncbMenuTableViewCellID.identifier)
        tblView.separatorStyle = .none
        tblView.delegate = self
        tblView.dataSource = self
        
        avatarImg.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(changeAvatarAction))
        avatarImg.addGestureRecognizer(gesture)
    }
    
    override func loadLocalized() {
        super.loadLocalized()
        
        guard let user = NCBShareManager.shared.getUser() else {
            return
        }
        
        lbUserName.text = "\(user.fullname ?? "")"
        lbCIFNumber.text = "Số CIF: \(user.cif ?? "")"
        lbPackage.text = "Gói dịch vụ: \(user.cifType ?? "")"
        
        if !isChangeAvatar {
            let img = NCBShareManager.shared.getUser()?.getAvatar()
            avatarImg.image = img
        }
    }
    
    @objc fileprivate func changeAvatarAction() {
        isChangeAvatar = true
        
        var items = [BottomSheetStringItem]()
        items.append(BottomSheetStringItem(title: "Chụp ảnh mới"))
        items.append(BottomSheetStringItem(title: "Chọn từ máy"))
        if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
            vc.setData("Thay ảnh đại diện", items: items, isHasOptionItem: false)
            vc.delegate = self
            showBottomSheet(controller: vc, size: 300)
        }
    }
    
    fileprivate func getDataModels() {
        dataModels.append(CellMenuItem(title: "Thông tin tài khoản", type: .accountInfo, image: R.image.ic_menu_account_info.name))
        dataModels.append(CellMenuItem(title: "Chuyển khoản", type: .transfer, image: R.image.ic_menu_transfer.name))
        dataModels.append(CellMenuItem(title: "Thanh toán dịch vụ", type: .payTheBill, image: R.image.ic_menu_pay_service.name))
        dataModels.append(CellMenuItem(title: "Nạp tiền", type: .recharge, image: R.image.ic_menu_recharge.name))
        dataModels.append(CellMenuItem(title: "Tiết kiệm", type: .saving, image: R.image.ic_menu_saving.name))
        dataModels.append(CellMenuItem(title: "Dịch vụ thẻ", type: .cardService, image: R.image.ic_menu_card_service.name))
        dataModels.append(CellMenuItem(title: "Tín dụng", type: .credit, image: R.image.ic_menu_credit.name))
        dataModels.append(CellMenuItem(title: "Đăng ký dịch vụ mới", type: .registerNewService, image: R.image.ic_menu_register_new_service.name))
        dataModels.append(CellMenuItem(title: "Trạng thái giao dịch", type: .searchTransaction, image: R.image.ic_feature_search_transaction.name))
        dataModels.append(CellMenuItem(title: "Dịch vụ khác", type: .otherService, image: R.image.ic_menu_other_service.name))
        dataModels.append(CellMenuItem(title: "Hỗ trợ khách hàng", type: .userSupport, image: R.image.ic_menu_user_support.name))
        dataModels.append(CellMenuItem(title: "Cài đặt", type: .setting, image: R.image.ic_menu_setting.name))
        dataModels.append(CellMenuItem(title: "Hộp thư", type: .mailbox, image: R.image.ic_menu_mailbox.name))
        dataModels.append(CellMenuItem(title: "Đăng xuất", type: .logout, image: R.image.ic_menu_logout.name))
    }
    
}

extension NCBMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.ncbMenuTableViewCellID.identifier, for: indexPath) as! NCBMenuTableViewCell
        cell.selectionStyle = .none
        let item = dataModels[indexPath.row]
        
        if indexPath.row >= CellType.userSupport.rawValue {
            cell.backgroundColor = UIColor(hexString: "F6F6F6")
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        if indexPath.row == CellType.credit.rawValue || indexPath.row == CellType.otherService.rawValue {
            cell.iconView.image = nil
            cell.lbTitle.text = ""
            cell.separatorView.isHidden = true
        } else {
            cell.iconView.image = UIImage(named: item.image)?.withRenderingMode(.alwaysTemplate)
            cell.iconView.tintColor = UIColor(hexString: (indexPath.row >= CellType.userSupport.rawValue) ? "6B6B6B" : "0083DC")
            cell.lbTitle.text = item.title
            cell.separatorView.isHidden = (indexPath.row == CellType.registerNewService.rawValue || indexPath.row == CellType.logout.rawValue)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == CellType.credit.rawValue || indexPath.row == CellType.otherService.rawValue {
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataModels[indexPath.row]
        switch item.type {
        case .accountInfo:
            if let vc = R.storyboard.accountInfo.ncbGeneralAccountViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .transfer:
//            openTabFromIndex(MainTabIndex.transfer.rawValue)
            if let vc = R.storyboard.main.ncbTransferViewController() {
                vc.showBack = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .saving:
//            openTabFromIndex(MainTabIndex.saving.rawValue)
            if let vc = R.storyboard.main.ncbSavingAccountViewController() {
                vc.showBack = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .setting:
            if let vc = R.storyboard.setting.ncbSettingsViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .recharge:
            if let vc = R.storyboard.chargeMoney.ncbChargeMoneyViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
       case .cardService:
            if let vc = R.storyboard.cardService.ncbCardServiceViewController() {
               self.navigationController?.pushViewController(vc, animated: true)
            }
        case .registerNewService:
            var items = [BottomSheetStringItem]()
            items.append(BottomSheetStringItem(title: "Đăng ký tài khoản mới", isCheck: false))
            items.append(BottomSheetStringItem(title: "Đăng ký phát hành thẻ", isCheck: false))
            items.append(BottomSheetStringItem(title: "Đăng ký SMS Banking", isCheck: false))
            if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                vc.setData("Đăng ký dịch vụ mới", items: items, isHasOptionItem: true)
                vc.delegate = self
                showBottomSheet(controller: vc, size: 330)
            }
            break
        case .userSupport:
            if let vc = R.storyboard.customerSupport.ncbCustomerSupportHomeViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .logout:
            showConfirm(msg: "Quý khách có chắc chắn muốn đăng xuất ứng dụng?") { [weak self] in
//                doLogout()
                self?.userLogout()
            }
        case .payTheBill:
//            openTabFromIndex(MainTabIndex.pay.rawValue)
            if let vc = R.storyboard.main.ncbPayViewController() {
                vc.showBack = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .mailbox:
            if let vc = R.storyboard.mailbox.ncbMailboxViewController(){
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .searchTransaction:
            if let vc = R.storyboard.home.ncbSearchTransactionViewController() {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
}

extension NCBMenuViewController: NCBBottomSheetListViewControllerDelegate {
    
    func bottomSheetListDidSelectItem(_ item: String, index: Int) {
        removeBottomSheet()
        if isChangeAvatar {
            switch index {
            case 0:
                imagePicker.delegate = self
                showPhotoSource(imagePicker, sourceType: .camera)
            case 1:
                imagePicker.delegate = self
                showPhotoSource(imagePicker, sourceType: .savedPhotosAlbum)
            default:
                break
            }
            return
        }
        
        if isRegisterNewCard == false{
            switch index {
            case 0:
                if let vc = R.storyboard.registerNewAcct.ncbRegisterNewAccountViewController() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 1:
                isRegisterNewCard = true
                
                var items = [BottomSheetStringItem]()
                items.append(BottomSheetStringItem(title: "Phát hành mới thẻ ATM", isCheck: false))
                items.append(BottomSheetStringItem(title: "Phát hành mới thẻ tín dụng", isCheck: false))
                items.append(BottomSheetStringItem(title: "Phát hành lại", isCheck: false))
                if let vc = R.storyboard.bottomSheet.ncbBottomSheetListViewController() {
                    vc.setData("Đăng ký phát hành thẻ", items: items, isHasOptionItem: true)
                    vc.delegate = self
                    showBottomSheet(controller: vc, size: 330)
                }
                break
            case 2:
                if let vc = R.storyboard.registerSMSBanking.ncbRegisterSMSBankingViewController(){
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            default:
                break
            }
        } else {
            switch index {
            case 0:
                if let vc = R.storyboard.cardService.ncbRegistrationATMViewController() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 1:
                if let vc = R.storyboard.cardService.ncbRegistrationCreditCardViewController() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case 2:
                if let vc = R.storyboard.cardService.ncbCardReissueViewController() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            default:
                break
            }
            isRegisterNewCard = false
        }
        
    }
}

extension NCBMenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        let img = image.resizeImage(targetSize: CGSize(width: 500, height: 500))
        avatarImg.image = img
        uploadProfileImage(image: img)
    }
    
}
