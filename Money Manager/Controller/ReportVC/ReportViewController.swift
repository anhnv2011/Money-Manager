//
//  ReportViewController.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import UIKit
import RealmSwift
import Charts
import MonthYearPicker

class ReportViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variable
    var transaction: Results<Transaction>?
    var categoryE: [String] = []
    var nameE: [String] = []
    var amountE: [Int] = []
    var nameI: [String] = []
    var amountI: [Int] = []
    var totalE = 0
    var totalI = 0
    var dictExpenseDetail: [String: Int] = [:]
    var dictIncomeDetail: [String: Int] = [:]
    var dictCategory: [String: Int] = [:]
    
    var categoryNameCell: [String] = []
    var categoryAmountCell: [Int] = []
    
    var expenseDetailName: [String] = []
    var expenseDetailAmount: [Int] = []
    
    var incomeDetailName: [String] = []
    var incomeDetailAmount: [Int] = []
    
    var month = "This month"
    // MARK: datePicker & toolBar
    var datePicker  = MonthYearPickerView(frame: .init(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300))
    var toolBar: UIToolbar = {
        let tool = UIToolbar(frame: CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.size.height - 300), size: CGSize(width: UIScreen.main.bounds.size.width, height: 44)))
        tool.barStyle = .default
        tool.sizeToFit()
        
        return tool
    }()
    
    var checkData:[Transaction]? = []
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        setupTableView()
        updateTransactionData(Date())
        setupNotificaton()
       
    }
    
    // MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getReportData()
    }
    
    private func setupTableView(){
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MonthTableViewCell", bundle: nil), forCellReuseIdentifier: MonthTableViewCell.identifier)
        tableView.register(UINib(nibName: "IncomeExpenseTableViewCell", bundle: nil), forCellReuseIdentifier: IncomeExpenseTableViewCell.identifier)
        tableView.register(UINib(nibName: "PieChartTableViewCell", bundle: nil), forCellReuseIdentifier: PieChartTableViewCell.identifier)
        tableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: ReportTableViewCell.identifier)
    }
    
    private func setupNotificaton(){
        // Load data now form AddTransactionVC
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "loadData"), object: nil)
    }
    @objc func refresh() {
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, DataSource
extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vSection = UIView()
        vSection.backgroundColor = .separatorColor()
        return vSection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 4, 6, 8:
            return 0
        default:
            return 5
        }
    }
    
    // MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return categoryNameCell.count
        } else if section == 6 {
            return expenseDetailName.count
        } else if section == 8 {
            return incomeDetailName.count
        } else {
            return 1
        }
    }
    
    // MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: MonthTableViewCell.identifier, for: indexPath) as! MonthTableViewCell
            cell.monthLabel.text = month
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: IncomeExpenseTableViewCell.identifier, for: indexPath) as! IncomeExpenseTableViewCell
            cell.contentStackView.layer.borderWidth = 0
            var expenseAmount = 0
            var incomeAmount = 0
            for i in 0..<(transaction?.count ?? 0) {
                if transaction?[i].stt == "-" {
                    expenseAmount += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    totalE = expenseAmount
                } else {
                    incomeAmount += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                    totalI = incomeAmount
                }
            }
            cell.expenseLabel.text = ConvertHelper.share.stringFromNumber(currency: totalE)
            cell.incomeLabel.text = ConvertHelper.share.stringFromNumber(currency: totalI)
            return cell
            
        case 2, 3, 5 ,7:
            if checkData == [] {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "No Pie Chart Data")
                cell.textLabel?.text = "No transaction data"
                cell.textLabel?.font = .italicSystemFont(ofSize: 12)
                cell.textLabel?.textAlignment = .center
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: PieChartTableViewCell.identifier, for: indexPath) as! PieChartTableViewCell
                switch indexPath.section {
                case 2:
                    cell.chartNameLabel.text = "Expense / Income"
                    cell.setPieChart(Double(totalE), Double(totalI), chartView: cell.chartBar)
                case 3:
                    cell.chartNameLabel.text = "Category"
                    dictCategory = ConvertHelper.share.convertToDict(name: categoryE, amount: amountE)
                    cell.setCategoryPieChart(dictCategory, chartView: cell.chartBar)
                case 5:
                    cell.chartNameLabel.text = "Expenses"
                    dictExpenseDetail = ConvertHelper.share.convertToDict(name: nameE, amount: amountE)
                    cell.setCategoryPieChart(dictExpenseDetail, chartView: cell.chartBar)
                default:
                    cell.chartNameLabel.text = "Incomes"
                    cell.setCategoryPieChart(dictIncomeDetail, chartView: cell.chartBar)
                }
                return cell
            }
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.identifier, for: indexPath) as! ReportTableViewCell
            cell.lblName.text = categoryNameCell[indexPath.row].prefix(1).uppercased() + categoryNameCell[indexPath.row].dropFirst()
            cell.lblAmount.text = "-" + ConvertHelper.share.stringFromNumber(currency: categoryAmountCell[indexPath.row])
            cell.lblAmount.textColor = .expenseColor()
            return cell
            
        case 6:
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 68
        default:
            return tableView.estimatedRowHeight
        }
    }
    
    // MARK: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            datePicker.backgroundColor = .white
            datePicker.addTarget(self, action: #selector(self.monthChanged(_:)), for: .valueChanged)
            
            toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
            
            view.addSubview(datePicker)
            view.addSubview(toolBar)
        }
    }
}

// MARK: -
extension ReportViewController {
    // MARK: Picker action
    @objc func monthChanged(_ sender: MonthYearPickerView) {
        if Calendar.current.dateComponents([.month, .year], from: sender.date) != Calendar.current.dateComponents([.month, .year], from: Date()) {
            month = ConvertHelper.share.stringFromDate(date: sender.date, format: "MMM yyyy")
            updateTransactionData(sender.date)
        } else {
            month = "This month"
            updateTransactionData(Date())
        }
        UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
    }
    
    @objc func onDoneButtonClick() {
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
    
    // MARK: updateTransactionData
    func updateTransactionData(_ date: Date) {
        let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))
        let lastDayOfMonth = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date)+1))
        
        transaction = DataBaseManager.shared.getMonthData(firstDayOfMonth ?? Date(), lastDayOfMonth ?? Date())
        checkData = (transaction?.toArray(ofType: Transaction.self))
        getReportData()
    }
    
    // MARK: getReportData
    func getReportData() {
        resetData()
        
        for i in 0..<(transaction?.count ?? 0) {
            if transaction?[i].stt == "-" {
                nameE.append(transaction?[i].name ?? "")
                amountE.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
                categoryE.append(transaction?[i].category ?? "")
            } else {
                nameI.append(transaction?[i].name ?? "")
                amountI.append(ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount ?? "").intValue)
            }
        }
        dictIncomeDetail = ConvertHelper.share.convertToDict(name: nameI, amount: amountI)
        incomeDetailName = Array(dictIncomeDetail.keys)
        incomeDetailAmount = Array(dictIncomeDetail.values)
        dictExpenseDetail = ConvertHelper.share.convertToDict(name: nameE, amount: amountE)
        for (key, value) in dictExpenseDetail {
            expenseDetailName.append(key)
            expenseDetailAmount.append(value)
        }
        dictCategory = ConvertHelper.share.convertToDict(name: categoryE, amount: amountE)
        for (key, value) in dictCategory {
            categoryNameCell.append(key)
            categoryAmountCell.append(value)
        }
        tableView.reloadData()
    }
    
    private func resetData(){
        categoryE = []
        nameE = []
        amountE = []
        nameI = []
        amountI = []
        totalE = 0
        totalI = 0
        categoryNameCell = []
        categoryAmountCell = []
        
        expenseDetailName = []
        expenseDetailAmount = []
        
        incomeDetailName = []
        incomeDetailAmount = []
    }
}
extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
