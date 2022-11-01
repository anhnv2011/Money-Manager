//
//  WalletViewController.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import UIKit
import RealmSwift
import Charts


class WalletViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var yearPicker = UIPickerView(frame: .init(x: 0, y: UIScreen.main.bounds.size.height-300, width: UIScreen.main
        .bounds.size.width, height: 300))
    var toolBar = UIToolbar(frame: .init(x: 0, y: UIScreen.main.bounds.size.height-300, width: UIScreen.main.bounds.size.width, height: 44))
    var yearArr: [Int] = {
        var year: [Int] = []
        for i in (2000...2030).reversed() {
            year.append(i)
        }
        return year
    }()
    var monthArr = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var expenseMonthArr: [Int] = []
    var incomeMonthArr: [Int] = []
    
    var transaction: Results<Transaction>?
    var transactionMonth: [Results<Transaction>] = []
    var beginningOfYear: Date?
    var endOfYear: Date?
    var beginningOfMonth: Date?
    var endOfMonth: Date?
    var year = "This year"
    
    var categoryE: [String] = []
    var nameE: [String] = []
    var amountE: [Int] = []
    var nameI: [String] = []
    var amountI: [Int] = []
    
    var categoryNameCell: [String] = []
    var categoryAmountCell: [Int] = []
    
    var expenseDetailName: [String] = []
    var expenseDetailAmount: [Int] = []
    
    var incomeDetailName: [String] = []
    var incomeDetailAmount: [Int] = []
    
    var dictExpenseDetail: [String: Int] = [:]
    var dictIncomeDetail: [String: Int] = [:]
    var dictCategory: [String: Int] = [:]
    
    var checkData: [Transaction]? = []
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
        updateTransactionData(Date())
        setupNoti()
    }
    
    // MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    @objc func refresh() {
        self.tableView.reloadData()
    }
    
    private func setupUI(){
        navigationController?.isNavigationBarHidden = true
        yearPicker.backgroundColor = .white
        yearPicker.delegate = self
        yearPicker.dataSource = self
        setupTableView()
    }
    
    private func setupTableView(){
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MonthTableViewCell", bundle: nil), forCellReuseIdentifier: MonthTableViewCell.identifier)
        tableView.register(UINib(nibName: "IncomeExpenseTableViewCell", bundle: nil), forCellReuseIdentifier: IncomeExpenseTableViewCell.identifier)
        tableView.register(UINib(nibName: "PieChartTableViewCell", bundle: nil), forCellReuseIdentifier: PieChartTableViewCell.identifier)
        tableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: ReportTableViewCell.identifier)
        tableView.register(UINib(nibName: "CombinedChartTableViewCell", bundle: nil), forCellReuseIdentifier: CombinedChartTableViewCell.identifier)
      
    }
    private func fetchData(){
        getDataMonth()
        addDataToArray()
    }
    private func setupNoti(){
        
        // Load data now form AddTransactionVC
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "loadData"), object: nil)
    }
}

// MARK: - UITableViewDelegate, DataSource
extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    // MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5 {
            return categoryNameCell.count
        } else if section == 7 {
            return expenseDetailName.count
        } else if section == 9 {
            return incomeDetailName.count
        } else {
            return 1
        }
    }
    
    // MARK: CellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MonthTableViewCell.identifier, for: indexPath) as! MonthTableViewCell
            cell.monthLabel.text = year
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: IncomeExpenseTableViewCell.identifier, for: indexPath) as! IncomeExpenseTableViewCell
            cell.contentStackView.layer.borderWidth = 0
            var expenseAmount = 0
            var incomeAmount = 0
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "-" {
                    expenseAmount += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                } else {
                    incomeAmount += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                }
            }
            cell.expenseLabel.text = ConvertHelper.share.stringFromNumber(currency: expenseAmount)
            cell.incomeLabel.text = ConvertHelper.share.stringFromNumber(currency: incomeAmount)
            return cell
            
        case 2:
            if checkData == [] {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "No Combined Chart Data")
                cell.textLabel?.text = "No transaction data"
                cell.textLabel?.font = .italicSystemFont(ofSize: 12)
                cell.textLabel?.textAlignment = .center
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: CombinedChartTableViewCell.identifier, for: indexPath) as! CombinedChartTableViewCell
                cell.chartNameLabel.text = "Monthly Expense/Income In Year"
                cell.setCombinedChart(monthArr, expenseMonthArr, incomeMonthArr, cell.chartBar)
                return cell
            }
            
        case 3, 4, 6, 8:
            if checkData == [] {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "No Pie Chart Data")
                cell.textLabel?.text = "No transaction data"
                cell.textLabel?.font = .italicSystemFont(ofSize: 12)
                cell.textLabel?.textAlignment = .center
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.identifier, for: indexPath) as! PieChartTableViewCell
                switch indexPath.section {
                case 3:
                    var expenseAmount = 0
                    var incomeAmount = 0
                    for i in 0..<(transaction?.count ?? 0) {
                        if transaction?[i].stt == "-" {
                            expenseAmount += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                        } else {
                            incomeAmount += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                        }
                    }
                    cell.chartNameLabel.text = "Expense/Income"
                    cell.setPieChart(Double(expenseAmount), Double(incomeAmount), chartView: cell.chartBar)
                case 4:
                    cell.chartNameLabel.text = "Category"
                    var categoryE: [String] = []
                    var amountE: [Int] = []
                    for i in 0..<(transaction?.count ?? 0) {
                        if transaction?[i].stt == "-" {
                            amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                            categoryE.append(transaction?[i].category ?? "")
                        }
                    }
                    let dictCategory = ConvertHelper.share.convertToDict(name: categoryE, amount: amountE)
                    cell.setCategoryPieChart(dictCategory, chartView: cell.chartBar)
                case 6:
                    cell.chartNameLabel.text = "Expense"
                    var categoryE: [String] = []
                    var amountE: [Int] = []
                    for i in 0..<(transaction?.count ?? 0) {
                        if transaction?[i].stt == "-" {
                            amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                            categoryE.append(transaction?[i].name ?? "")
                        }
                    }
                    let dictCategory = ConvertHelper.share.convertToDict(name: categoryE, amount: amountE)
                    cell.setCategoryPieChart(dictCategory, chartView: cell.chartBar)
                default:
                    cell.chartNameLabel.text = "Income"
                    var categoryE: [String] = []
                    var amountE: [Int] = []
                    for i in 0..<(transaction?.count ?? 0) {
                        if transaction?[i].stt == "+" {
                            amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                            categoryE.append(transaction?[i].name ?? "")
                        }
                    }
                    let dictCategory = ConvertHelper.share.convertToDict(name: categoryE, amount: amountE)
                    cell.setCategoryPieChart(dictCategory, chartView: cell.chartBar)
                }
                return cell
            }
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as! ReportTableViewCell
            cell.lblName.text = categoryNameCell[indexPath.row].prefix(1).uppercased() + categoryNameCell[indexPath.row].dropFirst()
            cell.lblAmount.text = "-" + ConvertHelper.share.stringFromNumber(currency: categoryAmountCell[indexPath.row])
            cell.lblAmount.textColor = .expenseColor()
            return cell
            
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as! ReportTableViewCell
            cell.lblName.text = expenseDetailName[indexPath.row]
            cell.lblAmount.text = "-" + ConvertHelper.share.stringFromNumber(currency: expenseDetailAmount[indexPath.row])
            cell.lblAmount.textColor = .expenseColor()
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as! ReportTableViewCell
            cell.lblName.text = incomeDetailName[indexPath.row]
            cell.lblAmount.text = "+" + ConvertHelper.share.stringFromNumber(currency: incomeDetailAmount[indexPath.row])
            cell.lblAmount.textColor = .incomeColor()
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vSection = UIView()
        vSection.backgroundColor = .separatorColor()
        return vSection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 5, 7, 9:
            return 0
        default:
            return 5
        }
    }
    
    // MARK: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            toolBar.barStyle = .default
            toolBar.sizeToFit()
            toolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))], animated: true)
            let yearDisplay = Calendar.current.component(.year, from: Date())
            if year == "This year" {
                yearPicker.selectRow(yearArr.firstIndex(of: yearDisplay) ?? 0, inComponent: 0, animated: true)
            } else {
                yearPicker.selectRow(yearArr.firstIndex(of: Int(year) ?? yearDisplay) ?? 0, inComponent: 0, animated: true)
            }
            view.addSubview(yearPicker)
            view.addSubview(toolBar)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 68
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: -
extension WalletViewController {
    @objc func onDoneButtonClick() {
        yearPicker.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    
    // MARK: updateTransationData
    func updateTransactionData(_ date: Date) {
        beginningOfYear = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: 1, day: 1))
        endOfYear = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date)+1, month: 1, day: 1))
        
        transaction = DataBaseManager.shared.getMonthData(beginningOfYear ?? Date(), endOfYear ?? Date())
        
        transactionMonth = []
        for i in 1...12 {
            beginningOfMonth = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: i, day: 1))
            endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: beginningOfMonth ?? Date())
            transactionMonth.append(DataBaseManager.shared.getMonthData(beginningOfMonth ?? Date(), endOfMonth ?? Date()))
        }
        checkData = transaction?.toArray(ofType: Transaction.self)
        getDataMonth()
        addDataToArray()
    }
    
    // MARK: getDataMonth
    func getDataMonth() {
        var expenseAmount = 0
        var incomeAmount = 0
        expenseMonthArr = []
        incomeMonthArr = []
        for i in 0..<transactionMonth.count {
            expenseAmount = 0
            incomeAmount = 0
            for j in 0..<transactionMonth[i].count {
                if transactionMonth[i][j].stt == "-" {
                    expenseAmount += ConvertHelper.share.numberFromCurrencyString(string: transactionMonth[i][j].amount ?? "").intValue
                } else {
                    incomeAmount += ConvertHelper.share.numberFromCurrencyString(string: transactionMonth[i][j].amount ?? "").intValue
                }
            }
            expenseMonthArr.append(expenseAmount)
            incomeMonthArr.append(incomeAmount)
        }
        tableView.reloadData()
    }
    
    // MARK: addDataToArray
    func addDataToArray() {
        resetData()
        for i in 0..<(transaction?.count ?? 0) {
            if transaction?[i].stt == "-" {
                categoryE.append(transaction?[i].category ?? "")
                nameE.append(transaction?[i].name ?? "")
                amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
            } else {
                nameI.append(transaction?[i].name ?? "")
                amountI.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
            }
        }
        dictCategory = ConvertHelper.share.convertToDict(name: categoryE, amount: amountE)
        categoryNameCell = Array(dictCategory.keys)
        categoryAmountCell = Array(dictCategory.values)
        dictExpenseDetail = ConvertHelper.share.convertToDict(name: nameE, amount: amountE)
        expenseDetailName = Array(dictExpenseDetail.keys)
        expenseDetailAmount = Array(dictExpenseDetail.values)
        dictIncomeDetail = ConvertHelper.share.convertToDict(name: nameI, amount: amountI)
        incomeDetailName = Array(dictIncomeDetail.keys)
        incomeDetailAmount = Array(dictIncomeDetail.values)
        
        tableView.reloadData()
    }
    
    private func resetData(){
        categoryE = []
        nameE = []
        amountE = []
        nameI = []
        amountI = []
        categoryNameCell = []
        categoryAmountCell = []
        expenseDetailName = []
        expenseDetailAmount = []
        incomeDetailName = []
        incomeDetailAmount = []
        
    }
}

// MARK: - UIPickerDelegate, DataSource
extension WalletViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(yearArr[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    // MARK: didSelectRowAt
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var date: Date = Date()
        if yearArr[row] != Calendar.current.component(.year, from: Date()) {
            year = String(yearArr[row])
            date = Calendar.current.date(from: DateComponents(year: yearArr[row])) ?? Date()
            updateTransactionData(date)
        } else {
            year = "This year"
            updateTransactionData(Date())
        }
        beginningOfYear = Calendar.current.date(from: DateComponents(year: yearArr[row], month: 1, day: 1))
        endOfYear = Calendar.current.date(from: DateComponents(year:yearArr[row]+1, month: 1, day: 1))
        transaction = DataBaseManager.shared.getMonthData(beginningOfYear ?? Date(), endOfYear ?? Date())
        
        for i in 1...12 {
            beginningOfMonth = Calendar.current.date(from: DateComponents(year: yearArr[row], month: i, day: 1))
            endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: beginningOfMonth ?? Date())
            transactionMonth.append(DataBaseManager.shared.getMonthData(beginningOfMonth ?? Date(), endOfMonth ?? Date()))
        }
        
        UIView.transition(with: tableView, duration: 0.5, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
    }
}

