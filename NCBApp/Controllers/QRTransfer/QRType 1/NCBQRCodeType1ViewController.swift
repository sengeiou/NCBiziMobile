//
//  NCBQRCodeType1ViewController.swift
//  NCBApp
//
//  Created by Lê Sơn on 5/29/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import AVFoundation

enum QRType: String {
    case animated = "000003"
    case quiet = "000002"
    case internalTransfer = "000001"
}

class NCBQRCodeType1ViewController: NCBBaseViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var transferHistoriesBtn: UIControl! {
        didSet {
            
        }
    }
    @IBOutlet weak var historyLbl: UILabel! {
        didSet {
            historyLbl.text = "Lịch sử giao dịch"
        }
    }
    @IBOutlet weak var historyImg: UIImageView! {
        didSet {
            historyImg.image = R.image.ic_history()
        }
    }
    
    
    
    @IBOutlet weak var supportUnitBtn: UIControl! {
        didSet {
        }
    }
    @IBOutlet weak var supportUnitLbl: UILabel! {
        didSet {
            supportUnitLbl.text = "Đơn vị hỗ trợ"
        }
    }
    @IBOutlet weak var supportUnitImg: UIImageView! {
        didSet {
            supportUnitImg.image = R.image.ic_history()
        }
    }
    
    
    @IBOutlet weak var scanQRBtn: UIControl! {
        didSet {
            
        }
    }
    @IBOutlet weak var scanQRLbl: UILabel! {
        didSet {
            scanQRLbl.text = "Quét ảnh"
        }
    }
    @IBOutlet weak var scanQRImg: UIImageView! {
        didSet {
            scanQRImg.image = R.image.ic_history()
        }
    }
    
    
    
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    @IBOutlet weak var focusScanArea: UIView! {
        didSet {
            
        }
    }
    // MARK: - Properties
    
    let rightNavBarButton: UIBarButtonItem = UIBarButtonItem(image: R.image.ic_qrCode(), style: .plain, target: self, action: #selector(scanQR(_:)))
    
    var metadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput() {
        didSet {
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.rectOfInterest = CGRect.zero
            self.view.bringSubviewToFront(focusScanArea)
        }
    }
    
    let imagePicker = UIImagePickerController()
    
    var qrType: QRType = .animated
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }

    
    @objc func scanQR(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func searchQRHistoryTransfer(_ sender: UIControl) {
        if let _vc = R.storyboard.qrTransfer.ncbHistoryQRTransferViewController() {
            self.navigationController?.pushViewController(_vc, animated: true)
        }
    }
    
    @IBAction func scanQRFromLibrary(_ sender: UIControl) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension NCBQRCodeType1ViewController{
    override func setupView() {
        setHeaderTitle("QUÉT MÃ QR")
         self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print(output.description)
    }
}

extension NCBQRCodeType1ViewController: QRScannerViewDelegate {
    func qrScanningDidFail() {
        print("Failed...!!!")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        print(str ?? "")
        let infoArr = str?.components(separatedBy: "|")
        
        if let _qrTypeString = infoArr?[1], qrType.rawValue == _qrTypeString {
            
            switch _qrTypeString {
            case QRType.animated.rawValue :
                let qrCodeModel = NCBQRCodeFirstTypeAnimatedScanModel()
                qrCodeModel.merchantName = infoArr?[0]
                qrCodeModel.transCodeType = infoArr?[1]
                qrCodeModel.merchantUnitName = infoArr?[2]
                qrCodeModel.merchantCode = infoArr?[3]
                qrCodeModel.TID = infoArr?[4]
                qrCodeModel.productCode = infoArr?[5]
                qrCodeModel.dealCode = infoArr?[6]
                qrCodeModel.amount = infoArr?[7]
                qrCodeModel.moneyCode = infoArr?[8]
                qrCodeModel.settlementDate = infoArr?[9]
                qrCodeModel.content = infoArr?[10]
                print(qrCodeModel)
                
                if let _vc = R.storyboard.qrTransfer.ncbqrFirstTypeAnimatedTransferViewController() {
                    _vc.qrFirstTypeModel = qrCodeModel
                    self.navigationController?.pushViewController(_vc, animated: true)
                }
            default:
                break
            }
        }
    }
    
    func qrScanningDidStop() {
        print("Stopped...!!!")
    }

}

extension NCBQRCodeType1ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let qrcodeImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
            let ciImage:CIImage=CIImage(image:qrcodeImg)!
            var qrCodeLink=""
            
            let features=detector.features(in: ciImage)
            for feature in features as! [CIQRCodeFeature] {
                qrCodeLink += feature.messageString!
            }
            
            if qrCodeLink=="" {
                print("nothing")
            }else{
                // If QRCode found. Doing here......
                print("message: \(qrCodeLink)")
            }
        }
        else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
