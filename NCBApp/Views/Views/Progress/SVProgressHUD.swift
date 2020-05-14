//
//  SVProgressHUD.swift
//  NCBApp
//
//  Created by Thuan on 8/21/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation
import Lottie
import SnapKit

fileprivate let progressTag = 27102018

class SVProgressHUD {
    
    class func show() {
        SVProgressHUD.dismiss()
        
        let wrapperView = UIView()
        wrapperView.isUserInteractionEnabled = true
        wrapperView.frame = CGRect(x: 0, y: 0, width: appDelegate.window!.frame.width, height: appDelegate.window!.frame.height)
        wrapperView.tag = progressTag
        appDelegate.window!.addSubview(wrapperView)
        
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 15
        containerView.backgroundColor = UIColor.white
        wrapperView.addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(190)
            make.height.equalTo(130)
        }
        
        containerView.addShadow(offset: CGSize(width: 0, height: 0), color: UIColor.black, opacity: 0.35, radius: 10)
        
        let lbTitle = UILabel()
        lbTitle.text = "Vui lòng chờ trong giây lát"
        lbTitle.font = regularFont(size: 14)
        lbTitle.textColor = ColorName.blackText.color
        containerView.addSubview(lbTitle)
        
        lbTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
        }
        
        let animationView = AnimationView()
        let animation = Animation.named("lottie_trail_loading")
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.loop,
                           completion: { (finished) in
                            if finished {
                                print("Animation Complete")
                            } else {
                                print("Animation cancelled")
                            }
        })
        containerView.addSubview(animationView)
        
        animationView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(lbTitle.snp.bottom).offset(-10)
            make.width.height.equalTo(100)
        }
    }
    
    class func dismiss() {
        for view in appDelegate.window!.subviews {
            if view.tag == progressTag {
                view.removeFromSuperview()
                break
            }
        }
    }
    
}
