//
//  ModelCategory.swift
//  Money Manager
//
//  Created by MAC on 10/26/22.
//

import Foundation
import UIKit

struct Category {
    let essentials: [Essential]
    let entertaiments: [Entertaiment]
    let educations: [Education]
    let investments: [Investment]
    let incomes: [Income]
    
    init(essentials: [Essential], entertaiments: [Entertaiment], educations: [Education], investments: [Investment], incomes: [Income]) {
        self.essentials = essentials
        self.entertaiments = entertaiments
        self.educations = educations
        self.investments = investments
        self.incomes = incomes
    }
}



func dataCategory() -> Category {
    var category: Category
    var dataEssential: [Essential] = []
    let dataEssential1 = Essential(image: UIImage(systemName: "house.fill"), name: "House Rent")
    let dataEssential2 = Essential(image: UIImage(systemName: "bolt.fill"), name: "Electricity/Water")
    let dataEssential3 = Essential(image: UIImage(systemName: "fork.knife"), name: "Foods")
    let dataEssential4 = Essential(image: UIImage(systemName: "fuelpump.fill"), name: "Petroleum")
    let dataEssential5 = Essential(image: UIImage(systemName: "flame.fill"), name: "Gas")
    let dataEssential6 = Essential(image: UIImage(systemName: "wifi"), name: "Internet")
    let dataEssential7 = Essential(image: UIImage(systemName: "phone.fill"), name: "Telephone")
    dataEssential.append(contentsOf: [dataEssential1, dataEssential2, dataEssential3, dataEssential4, dataEssential5, dataEssential6, dataEssential7])
    
    var dataEntertaiment: [Entertaiment] = []
    let dataEntertaiment1 = Entertaiment(image: UIImage(systemName: "cart.fill"), name: "Shopping")
    let dataEntertaiment2 = Entertaiment(image: UIImage(systemName: "ticket.fill"), name: "Cinema")
    let dataEntertaiment3 = Entertaiment(image: UIImage(systemName: "gamecontroller.fill"), name: "Game")
    let dataEntertaiment4 = Entertaiment(image: UIImage(systemName: "sportscourt.fill"), name: "Sport")
    let dataEntertaiment5 = Entertaiment(image: UIImage(systemName: "leaf.fill"), name: "Spa")
    dataEntertaiment.append(contentsOf: [dataEntertaiment1, dataEntertaiment2, dataEntertaiment3, dataEntertaiment4, dataEntertaiment5])
    
    var dataEdu: [Education] = []
    let dateEdu1 = Education(image: UIImage(systemName: "book.fill")!, name: "Book")
    let dateEdu2 = Education(image: UIImage(systemName: "bag.fill"), name: "Education")
    dataEdu.append(contentsOf: [dateEdu1, dateEdu2])
    
    var dataInvest: [Investment] = []
    let dataInvest1 = Investment(image: UIImage(systemName: "bitcoinsign.circle.fill"), name: "Coin")
    let dataInvest2 = Investment(image: UIImage(systemName: "chart.xyaxis.line"), name: "Securities")
    let dataInvest3 = Investment(image: UIImage(systemName: "globe.asia.australia.fill"), name: "Real Estate")
    dataInvest.append(contentsOf: [dataInvest1, dataInvest2, dataInvest3])
    
    var dataIncome: [Income] = []
    let dataIncome1 = Income(image: UIImage(systemName: "dollarsign.circle.fill") , name: "Salary")
    let dataIncome2 = Income(image: UIImage(systemName: "network"), name: "Freelancer")
    let dataIncome3 = Income(image: UIImage(systemName: "chart.xyaxis.line"), name: "Investment")
    dataIncome.append(contentsOf: [dataIncome1, dataIncome2, dataIncome3])
    
    category = Category(essentials: dataEssential, entertaiments: dataEntertaiment, educations: dataEdu, investments: dataInvest, incomes: dataIncome)
    
    return category
}
