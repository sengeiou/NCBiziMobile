//
//  NCBHomeSlideShowImageView.swift
//  NCBApp
//
//  Created by Thuan on 4/2/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import UIKit
import ImageSlideshow
import SnapKit

protocol NCBHomeSlideShowImageViewDelegate {
    func bannerDidSelectAt(_ index: Int)
}

class NCBHomeSlideShowImageView: UIView {
    
    let slideView = ImageSlideshow()
    var delegate: NCBHomeSlideShowImageViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func reloadView(_ dataModels: [NCBBannerModel], autoScroll: Bool) {
        slideView.pageIndicator = .none
        if autoScroll {
            slideView.slideshowInterval = 3.0
        } else if dataModels.count > 0 {
            let item = dataModels[0]
            if item.oneTimeShow == true {
                addPopupShowed(item)
            }
        }
        
        var inputs = [KingfisherSource]()
        for banner in dataModels {
            let urlStr = banner.urlImg?.replacingSpace ?? ""
            if let source = KingfisherSource(urlString: urlStr) {
                inputs.append(source)
            }
        }
        
        slideView.contentScaleMode = .scaleToFill
        slideView.setImageInputs(inputs)
        
        addSubview(slideView)
        
        slideView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.leading.top.equalToSuperview()
        }
        
        if let _ = delegate {
            slideView.currentPageChanged = { [weak self] page in
                self?.checkViewed(autoScroll, page: page, dataModels: dataModels)
            }
            
            slideView.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(slideShowDidSelect(_:)))
            slideView.addGestureRecognizer(gesture)
        }
    }
    
    fileprivate func checkViewed(_ autoScroll: Bool, page: Int, dataModels: [NCBBannerModel]) {
        if autoScroll {
            return
        }
        
        let item = dataModels[page]
        if item.oneTimeShow == true {
            addPopupShowed(item)
        }
    }
    
    @objc func slideShowDidSelect(_ sender: UITapGestureRecognizer) {
        guard let slideView = sender.view as? ImageSlideshow else {
            return
        }
        
        let page = slideView.currentPage
        delegate?.bannerDidSelectAt(page)
    }

}
