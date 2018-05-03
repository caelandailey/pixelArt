//
//  CountView.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/28/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

class CountView: UIView {
    
    let image: UIImageView = {
        let image = UIImageView(image: UIImage(named: "profile_icon"))
        image.setImageColor(color: .blue)
        return image
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.text = ""
        title.textAlignment = .center
        return title
    }()
    
    //ADD SUBVIEWS AND TARGETS
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(image)
        addSubview(title)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        image.frame = CGRect(x: self.bounds.height*1/5, y: 0, width: self.bounds.height*3/5, height: self.bounds.height*3/5)
        title.frame = CGRect(x: 0, y: self.bounds.height*3/5, width: self.bounds.height, height: self.bounds.height*2/5)
        
        image.setNeedsDisplay()
        title.setNeedsDisplay()
    }

}
