//
//  Categories.swift
//  Money Manager
//
//  Created by MAC on 10/26/22.
//

import Foundation
import SwiftyJSON

struct Categories: Decodable {
    var category: String
    var name: [String]
    var image: [String]
    
    init(_ json: JSON) {
        self.category = json["category"].stringValue
        self.name = json["name"].arrayValue.map { $0.stringValue }
        self.image = json["image"].arrayValue.map { $0.stringValue }
    }
}
