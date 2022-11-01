//
//  ConvertHelper.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import Foundation
class ConvertHelper {
    static let share = ConvertHelper()      // singleton pattern
    
    // Convert number to currency string
    func stringFromNumber(currency: Int) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "vi_VN")
        let priceString = currencyFormatter.string(from: NSNumber(value: currency)) ?? "0"
        
        return priceString
    }
    
    // Convert date to string
    func stringFromDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let string = formatter.string(from: date)
        
        return string
    }
    
    // Convert currency string to NSNumber
    func numberFromCurrencyString(string: String) -> NSNumber {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "vi_VN")
        let number = formatter.number(from: string) ?? NSNumber()
        return number
    }
    
    // Convert string to date
    func dateFormString(string: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: string) ?? Date()
        return date
    }
    
    // Convert 2 arrays to dictionary
    func convertToDict(name: [String], amount: [Int]) -> [String: Int] {
        var result: [String: Int] = [:]
        for i in 0..<name.count {
//
            result[name[i]] = amount[i]

        }
        return result
    }
}

