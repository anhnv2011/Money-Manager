//
//  ModelTransaction.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import Foundation
import RealmSwift

class Transaction: Object {

    @objc dynamic var ID = ""
    @objc dynamic var category: String?
    @objc dynamic var image: String?
    @objc dynamic var name: String?
    @objc dynamic var date: Date?
    @objc dynamic var amount: String?
    @objc dynamic var stt: String?
//    @objc dynamic var color: UIColor?
    override class func primaryKey() -> String? {
        return "ID"
    }
    
    convenience init(category: String?, image: String?, name: String?, date: Date?, amount: String?, stt: String) {
//        convenience init(image: String?, name: String?, date: Date?, amount: String?, stt: String) {
        self.init()
        self.category = category
        self.image = image
        self.name = name
        self.date = date
        self.amount = amount
        self.stt = stt
    }
    
}
