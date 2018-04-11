//
//  ViewHolder.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/11/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class ViewHolder: UIScrollView, PixelDelegate, PixelViewDelegate, UIScrollViewDelegate {
    
    let parentView: UIView = {
        let parentView = UIView()
        //parentView.translatesAutoresizingMaskIntoConstraints = true
        return parentView
    }()
    
    let pixelView: PixelView = {
        let pixelView = PixelView()
        //pixelView.translatesAutoresizingMaskIntoConstraints = false
        pixelView.backgroundColor = UIColor.white
        print("CREATING PIXELVIEW")
        return pixelView
    }()
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return parentView
    }
    
    
    //ADD SUBVIEWS AND TARGETS
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.maximumZoomScale = 100
        self.minimumZoomScale = 1
        self.zoomScale = 50
        addSubview(parentView)
        parentView.addSubview(pixelView)
        delegate = self
        //addSubview(pixelView)
        
    }
    
    override func layoutSubviews() {
        let frame = self.frame
        pixelView.frame = frame
        parentView.frame = frame
        pixelView.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pixelsLoaded(_ pos: [CGPoint], color: [CGColor]) {
        //
    }
    
    func cellTouchesBegan(_ pos: CGPoint, color: CGColor) {
        //
    }
    
    
   
 
    
}
