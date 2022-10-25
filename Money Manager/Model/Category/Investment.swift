//
//  Investment.swift
//  Money Manager
//
//  Created by MAC on 10/26/22.
//

import Foundation
import UIKit

struct Investment {
    var image: UIImage?
    var name: String?
    
    init(image: UIImage? = nil, name: String? = nil) {
        self.image = image
        self.name = name
    }
    
}
