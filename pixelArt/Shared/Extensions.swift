//
//  Extensions.swift
//  pixelArt
//
//  Created by Caelan Dailey on 4/21/18.
//  Copyright © 2018 Caelan Dailey. All rights reserved.
//

import Foundation
import UIKit

// Extensions
extension UIImageView {
    
    // Download an image
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        
        // Start task
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType,
                mimeType.hasPrefix("image"),
                let data = data,
                error == nil,
                let image = UIImage(data: data)
                
                else {
                    return
            }
            // Set image
            DispatchQueue.main.async() { self.image = image}
            }.resume()
    }
    
    // Download
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

// Setting the color of an image
extension UIImageView {
    func setImageColor(color: UIColor) {
        // Render
        let temp = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        // Set image
        self.image = temp
        // Set color
        self.tintColor = color
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        
        // Make sure values correct
        assert(red >= 0 && red <= 255, "Invalid red")
        assert(green >= 0 && green <= 255, "Invalid green")
        assert(blue >= 0 && blue <= 255, "Invalid blue")
        
        // Init with values
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    // Gets values from int
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    // Sets to int
    func toHexInt() -> Int {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)

        return (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    }
}
