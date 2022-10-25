//
//  Extension+UIFont.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import Foundation
import UIKit
extension UIFont {
    class func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    class func medium(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    class func semibold(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    class func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
