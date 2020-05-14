//
//  NCBMenuIconDragView.swift
//  NCBApp
//
//  Created by Thuan on 4/3/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit

class NCBMenuIconDragView: UIView {
    
    //MARK: Properties
    
    var lbTitle: UILabel!
    var iconView: UIImageView!
    
    var selectedModel: NCBMenuIconModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    fileprivate func initView() {
        backgroundColor = UIColor.white
        
        let bgView = UIImageView()
        bgView.image = R.image.menu_icon_background()
        addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(58)
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        bgView.addSubview(iconView)
        
        iconView.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.center.equalToSuperview()
        }
        
        lbTitle = UILabel()
        lbTitle.font = regularFont(size: 12)
        lbTitle.textColor = UIColor.black
        lbTitle.textAlignment = .center
        lbTitle.numberOfLines = 2
        addSubview(lbTitle)
        
        lbTitle.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(bgView.snp.bottom).offset(10)
        }
    }
    
}
