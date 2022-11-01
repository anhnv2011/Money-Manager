//
//  Extension+UIColor.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import Foundation
import UIKit

extension UIColor {
    class func mainColor() -> UIColor {
        return UIColor.link
    }
    
    class func incomeColor() -> UIColor {
        return UIColor(red: 0.00, green: 0.69, blue: 0.28, alpha: 1.00)
    }
    
    class func expenseColor() -> UIColor {
        return UIColor(red: 0.90, green: 0.08, blue: 0.08, alpha: 1.00)
    }
    
    class func borderColor() -> UIColor {
        return UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
    }
    
    class func separatorColor() -> UIColor {
        return UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
    }
    
    class func iconTabBarColor() -> UIColor {
        return UIColor(red: 0.67, green: 0.67, blue: 0.67, alpha: 1.00)
    }
    
    class func textColor() -> UIColor {
        return UIColor(red: 0.53, green: 0.53, blue: 0.53, alpha: 1.00)
    }
    
    class func iconColor() -> UIColor {
        let iconColor1 = UIColor(red: 0.57, green: 0.73, blue: 0.58, alpha: 1.00)
        let iconColor2 = UIColor(red: 1.00, green: 0.68, blue: 0.02, alpha: 1.00)
        let iconColor3 = UIColor(red: 0.40, green: 0.40, blue: 0.87, alpha: 1.00)
        let iconColor4 = UIColor(red: 0.95, green: 0.49, blue: 0.12, alpha: 1.00)
        let iconColor5 = UIColor(red: 0.00, green: 0.22, blue: 0.65, alpha: 1.00)
        
        let iconColor = [iconColor1, iconColor2, iconColor3, iconColor4, iconColor5]
        
        return iconColor.randomElement()!
    }
    
}
