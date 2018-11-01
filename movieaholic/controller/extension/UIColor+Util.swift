//
//  UIColor+Util.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 23/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import UIKit

extension UIColor {
    

    // MARK: Principais tema
    class func primaryColor() -> UIColor {
        return UIColor(red: 51.0/255.0, green: 190.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    }
    
    class func primaryColorDark() -> UIColor {
        return UIColor(red: 0.0/255.0, green: 174.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    } 
    
    class func secondaryColor() -> UIColor {
        return UIColor(red: 67.0/255.0, green: 171.0/255.0, blue: 175.0/255.0, alpha: 1.0)
    }
    
    
    // MARK: Vermelho
    class func redClear() -> UIColor {
        return UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 95.0/255.0, alpha: 1.0)
    }
    
    convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            self.init()
        } else {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: CGFloat(r / 255), green: CGFloat(g / 255), blue: CGFloat(b / 255), alpha: CGFloat(1))
    }
    
    static func fade(fromColor: UIColor, toColor: UIColor, withPercentage: CGFloat) -> UIColor {
        
        var fromRed: CGFloat = 0.0
        var fromGreen: CGFloat = 0.0
        var fromBlue: CGFloat = 0.0
        var fromAlpha: CGFloat = 0.0
        
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0.0
        var toGreen: CGFloat = 0.0
        var toBlue: CGFloat = 0.0
        var toAlpha: CGFloat = 0.0
        
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        //calculate the actual RGBA values of the fade colour
        let red = (toRed - fromRed) * withPercentage + fromRed;
        let green = (toGreen - fromGreen) * withPercentage + fromGreen;
        let blue = (toBlue - fromBlue) * withPercentage + fromBlue;
        let alpha = (toAlpha - fromAlpha) * withPercentage + fromAlpha;
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
