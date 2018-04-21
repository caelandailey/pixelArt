//
//  ViewHolder.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/11/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class ViewHolder: UIView, UIScrollViewDelegate {
    

    //var pixelViewWidth = UIScreen.main.bounds.width*5
    //var pixelViewHeight = UIScreen.main.bounds.height*5
    let pixelViewSizeFactor: CGFloat = 5
    
    let colorPickerControl: ColorPickerControl = {
        let colorPickerControl = ColorPickerControl()
        colorPickerControl.translatesAutoresizingMaskIntoConstraints = false
        return colorPickerControl
    }()
    
    let pixelView: PixelView = {
        let pixelView = PixelView()
        pixelView.translatesAutoresizingMaskIntoConstraints = false
        pixelView.backgroundColor = UIColor.white
        print("CREATING PIXELVIEW")
        return pixelView
    }()
    
    let pixelScrollView: UIScrollView = {
        
        let pixelScrollView = UIScrollView()
        pixelScrollView.translatesAutoresizingMaskIntoConstraints = false
        pixelScrollView.maximumZoomScale = 50
        pixelScrollView.bouncesZoom = false
        pixelScrollView.showsHorizontalScrollIndicator = false
        pixelScrollView.showsVerticalScrollIndicator = false
        pixelScrollView.bounces = false
     
        return pixelScrollView
    }()
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pixelView
    }
    
    
    //ADD SUBVIEWS AND TARGETS
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white

        let minZoom:CGFloat = 0.2
        let colorPickerFrameHeight: CGFloat = 80
        pixelView.frame = CGRect(x: 0, y: 0, width: frame.width * pixelViewSizeFactor, height: frame.height * pixelViewSizeFactor)
        colorPickerControl.frame = CGRect(x: 0, y: frame.height - colorPickerFrameHeight, width: frame.width, height: colorPickerFrameHeight)
        pixelScrollView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - colorPickerFrameHeight)
        pixelScrollView.addSubview(pixelView)
        pixelScrollView.delegate = self
        pixelScrollView.minimumZoomScale = minZoom
        pixelScrollView.zoomScale = minZoom
        pixelScrollView.contentSize = CGSize(width: pixelView.frame.width, height: pixelView.frame.height)
        
        addSubview(colorPickerControl)
        addSubview(pixelScrollView)
    }
    
    private func viewWidth() -> CGFloat {
        return UIScreen.main.bounds.width*5
    }
    
    private func viewHeight() -> CGFloat {
        return UIScreen.main.bounds.height*5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

 
    
}
