//
//  UIImage+Util.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 23/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit

extension UIImage {
    
    //-------------------------------------------------------------------------------------------------------------
    // MARK: Métodos
    //-------------------------------------------------------------------------------------------------------------
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
