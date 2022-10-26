//
//  DBManager.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import Foundation
import RealmSwift

class DataBaseManager {
    private var database: Realm
    static let shared = DataBaseManager()
    
    private init() {
        database = try!Realm()
    }
    
    func addData(_ object: Transaction) {
        try! database.write({
            object.ID = UUID().uuidString
            database.add(object)
        })
    }
    
    func getData() -> Results<Transaction> {
        let results: Results<Transaction> = database.objects(Transaction.self).sorted(byKeyPath: "date", ascending: false)
        return results
    }
    
    func getMonthData(_ beginningOfMonth: Date, _ endOfMonth: Date) -> Results<Transaction> {
        let results: Results<Transaction> = database.objects(Transaction.self).filter("date >= %@ AND date < %@", beginningOfMonth, endOfMonth).sorted(byKeyPath: "date", ascending: false)
        return results
    }
    
    func updateObject(_ object: Transaction, _ newObject: Transaction) {
        try! database.write({
            object.category = newObject.category
            object.image = newObject.image
            object.name = newObject.name
            object.date = newObject.date
            object.amount = newObject.amount
            object.stt = newObject.stt
        })
    }
    
    func deleteAnObject(_ object: Transaction) {
        try! database.write({
            database.delete(object)
        })
    }
    
    func deleteAll() {
        try! database.write({
            database.deleteAll()
        })
    }
}
