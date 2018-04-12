//
//  ViewHolder.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/11/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class ViewHolder: UIScrollView, UIScrollViewDelegate {
    

    var pixelViewWidth = UIScreen.main.bounds.width*3
    var pixelViewHeight = UIScreen.main.bounds.height*4
    
    let parentView: UIView = {
        let parentView = UIView()
        parentView.translatesAutoresizingMaskIntoConstraints = false
        return parentView
    }()
    
    let pixelView: PixelView = {
        let pixelView = PixelView()
        pixelView.translatesAutoresizingMaskIntoConstraints = false
        pixelView.backgroundColor = UIColor.white
        print("CREATING PIXELVIEW")
        return pixelView
    }()
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pixelView
    }
    
    
    //ADD SUBVIEWS AND TARGETS
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.maximumZoomScale = 50
        
        self.minimumZoomScale = (UIScreen.main.bounds.width/pixelViewWidth > UIScreen.main.bounds.height/pixelViewHeight) ? UIScreen.main.bounds.width/pixelViewWidth : UIScreen.main.bounds.height/pixelViewHeight
        self.zoomScale = 1
        self.bouncesZoom = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.contentSize = CGSize(width: pixelViewWidth, height: pixelViewHeight)
        self.bounces = false
        delegate = self
        pixelView.frame = CGRect(x: 0, y: 0, width: pixelViewWidth, height: pixelViewHeight)
        addSubview(pixelView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

 
    
}
