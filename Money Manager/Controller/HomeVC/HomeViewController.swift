//
//  HomeViewController.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import UIKit
import FirebaseAuth
import RealmSwift

class HomeViewController: UIViewController {
    // MARK: IBOutlet & variable
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    
    // Header height constraint
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    // subview height constraint
    @IBOutlet weak var subHeaderConstraint: NSLayoutConstraint!
    
    // Balance view height constraint
    @IBOutlet weak var balanceHeightConstraint: NSLayoutConstraint!
    
    //Notibutton Top constraint
    @IBOutlet weak var notiButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    // Header height trước và sau khi scroll
    let maxHeaderHeight: CGFloat = 169
    let minHeaderHeight: CGFloat = 44
    
    //Sub view height trước và sau khi scroll
    let maxSubHeight: CGFloat = 128
    let minSubHeight: CGFloat = 44
    
    // Balance view height trước và sau khi scroll
    let maxBalanceHeight: CGFloat = 82
    let minBalanceHeight: CGFloat = 0
    // OffSet trước khi scroll
    var previousScrollOffSet: CGFloat = 0
    
    var transaction: Results<Transaction>?
    var firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))
    var lastDayOfMonth = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date())+1))
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupUI()
        fetchData()
        
       
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerHeightConstraint.constant = maxHeaderHeight
        balanceHeightConstraint.constant = maxBalanceHeight
        subHeaderConstraint.constant = maxSubHeight
        notiButtonTopConstraint.constant = 18
        updateHeader()
        tableView.reloadData()
    }
    
    //MARK:- Data
    private func fetchData(){
        transaction = DataBaseManager.shared.getMonthData(firstDayOfMonth ?? Date(), lastDayOfMonth ?? Date())
    }
    
    // MARK: Setup UI
    private func setupUI() {
        welcomeUser()
        setupTableView()
        setupBalanceView()
        
       
    }
    
    private func setupTableView(){
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "IncomeExpenseTableViewCell", bundle: nil), forCellReuseIdentifier: IncomeExpenseTableViewCell.identifier)
        tableView.register(UINib(nibName: "AdsTableViewCell", bundle: nil), forCellReuseIdentifier: AdsTableViewCell.identifier)
        tableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: TransactionTableViewCell.identifier)
    }
    
    
    private func setupBalanceView(){
        balanceView.layer.cornerRadius = 10
        balanceView.layer.masksToBounds = false
        balanceView.layer.shadowColor = UIColor.black.cgColor
        balanceView.layer.shadowOpacity = 0.1
        balanceView.layer.shadowOffset = .init(width: 0, height: 2)
        
    }
    
    func welcomeUser() {
        let hourStr = ConvertHelper.share.stringFromDate(date: Date(), format: "HH")
        guard let hourInt = Int(hourStr) else { return }
        
        switch hourInt {
        case 0..<6:
            helloLabel.text = "Good night,"
        case 6..<12:
            helloLabel.text = "Good morning,"
        case 12..<18:
            helloLabel.text = "Good afternoon,"
        case 18..<24:
            helloLabel.text = "Good evening,"
        default:
            helloLabel.text = "Welcome,"
        }
        
        guard let user = Auth.auth().currentUser else { return }
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    userNameLabel.text = user.displayName
                default:
                    userNameLabel.text = user.email
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // MARK: Custom view in header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = HeaderView(frame: .init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        
        if section == 2 {

            
            headerView.configureHeader(title: "History", buttonTitle: "See all")
            headerView.completion = { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.onHistory()
                
            }
            return headerView
        } else if section == 0 {
    
            headerView.configureHeader(title: "This month", buttonTitle: "View report")
            headerView.completion = {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.onReport()
            }
            return headerView
        } else {
            return nil
        }
        
    }
    
    private func onReport() {
        let vc = ReportViewController()
        present(vc, animated: true)
    }
    
    private func onHistory() {
        let vc = HistoryViewController()
//        vc.transaction = transaction
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return transaction?.count ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IncomeExpenseTableViewCell.identifier, for: indexPath) as? IncomeExpenseTableViewCell else { return UITableViewCell() }

            var totalE: Int = 0
            var totalI: Int = 0

            for i in 0..<(transaction?.count ?? 0) {
                switch transaction?[i].stt {
                case "-":
                    totalE += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount! ?? "").intValue)
                default:
                    totalI += (ConvertHelper.share.numberFromCurrencyString(string: transaction?[i].amount! ?? "").intValue)
                }
            }

            cell.expenseLabel.text = ConvertHelper.share.stringFromNumber(currency: totalE)

            cell.incomeLabel.text = ConvertHelper.share.stringFromNumber(currency: totalI)

            totalBalanceLabel.text = ConvertHelper.share.stringFromNumber(currency: totalI - totalE)

            return cell

        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AdsTableViewCell.identifier, for: indexPath) as? AdsTableViewCell else { return UITableViewCell() }

            return cell

        } else {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier, for: indexPath) as? TransactionTableViewCell else { return UITableViewCell() }
            cell.imageIcon.image = UIImage(systemName: transaction?[indexPath.row].image ?? "")
            cell.nameLabel.text = transaction?[indexPath.row].name
            cell.dateLabel.text = ConvertHelper.share.stringFromDate(date: transaction?[indexPath.row].date ?? Date(), format: "dd/MM/yyyy")

            let stt = transaction?[indexPath.row].stt ?? ""
            let amount = transaction?[indexPath.row].amount ?? ""
            let a = stt.appending(amount)

            cell.amountLabel.text = a

            switch transaction?[indexPath.row].stt {
            case "-":
                cell.amountLabel.textColor = .expenseColor()
            default:
                cell.amountLabel.textColor = .incomeColor()
            }

            return cell
        }
           
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 68
        } else if indexPath.section == 1 {
            return 139
        } else {
            return UITableView.automaticDimension
        }
    }
    
    // MARK: Swipe action cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 2 {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
                DataBaseManager.shared.deleteAnObject(self.transaction?[indexPath.row] ?? Transaction())
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadData()
            }
            
            let edit = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
                let editVC = AddTransactionViewController()
                editVC.transaction = self.transaction?[indexPath.row]
                editVC.saveCompletion = { [weak self] transaction in
                    guard let strongSelf = self, let transaction = transaction else { return }
                    //                    strongSelf.transaction[indexPath.row] = transaction
                    //                    strongSelf.transaction.sort(by: { $1.date ?? Date() < $0.date ?? Date() })
                    DataBaseManager.shared.updateObject(strongSelf.transaction?[indexPath.row] ?? Transaction(), transaction)
                    strongSelf.tableView.reloadData()
                }
                self.present(editVC, animated: true)
            }
            
            let configure = UISwipeActionsConfiguration(actions: [delete, edit])
            return configure
        } else {
            return UISwipeActionsConfiguration()
        }
    }
    
    // MARK: Animate header when scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffSet
        
        print("scrollView.contentOffset.y", scrollView.contentOffset.y)
        print("previousScrollOffSet", previousScrollOffSet)
        print("scrollDiff", scrollDiff)
        let absoluteTop: CGFloat = 0.0
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
//        guard canAnimateHeader(scrollView) else { return }
//        print("canAnimateHeader", canAnimateHeader)
        print("isScrollingDown", isScrollingDown)
        print("isScrollingUp", isScrollingUp)
        print("----------------------------")
        var newHeaderHeight = headerHeightConstraint.constant
        var newSubHeaderHeight = subHeaderConstraint.constant
        var newBalanceHeight = balanceHeightConstraint.constant
        var newBtnNotiTopConstraint = notiButtonTopConstraint.constant
        
        if isScrollingDown {
            print("down")
            newHeaderHeight = max(minHeaderHeight, headerHeightConstraint.constant - abs(scrollDiff))
            newSubHeaderHeight = max(minSubHeight, subHeaderConstraint.constant - abs(scrollDiff))
            newBalanceHeight = max(minBalanceHeight, balanceHeightConstraint.constant - abs(scrollDiff))
            newBtnNotiTopConstraint = max(6, notiButtonTopConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            print("up")

            newHeaderHeight = min(maxHeaderHeight, headerHeightConstraint.constant + abs(scrollDiff))
            newSubHeaderHeight = min(maxSubHeight, subHeaderConstraint.constant + abs(scrollDiff))
            newBalanceHeight = min(maxBalanceHeight, balanceHeightConstraint.constant + abs(scrollDiff))
            newBtnNotiTopConstraint = min(18, notiButtonTopConstraint.constant + abs(scrollDiff))
        }
        
        // Tính theo view có height contraint thay đổi lớn nhất trong 2 view
        if newHeaderHeight != headerHeightConstraint.constant
        {
            headerHeightConstraint.constant = newHeaderHeight
            subHeaderConstraint.constant = newSubHeaderHeight
            balanceHeightConstraint.constant = newBalanceHeight
            notiButtonTopConstraint.constant = newBtnNotiTopConstraint
            updateHeader()
            setScrollPosition(previousScrollOffSet)
        }
        previousScrollOffSet = scrollView.contentOffset.y
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidStopScrolling()
        }
    }
}

// MARK: - Extension HomeVC
// Animate header when scroll
extension HomeViewController {
//    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
//        // Tính theo height constraint của view nhỏ nhât trong 2 view thay đổi height constraint
//        let scrollMaxViewHeight = scrollView.frame.height + balanceHeightConstraint.constant - minBalanceHeight
//        print("scrollMaxViewHeight", scrollMaxViewHeight)
//        return scrollView.contentSize.height > scrollMaxViewHeight
//    }
    
    func setScrollPosition(_ position: CGFloat) {
        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: position)
    }
    
    func scrollViewDidStopScrolling() {
        // Tính theo height constraint của view nhỏ nhất trong 2 view thay đổi height constraint
        let range = maxBalanceHeight - minBalanceHeight
        let midPoint = minBalanceHeight + range/2
        
        if balanceHeightConstraint.constant > midPoint {
            expandHeader()
        } else {
            collapseHeader()
        }
    }
    
    // Thu vào
    func collapseHeader() {
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.subHeaderConstraint.constant = self.minSubHeight
            self.balanceHeightConstraint.constant = self.minBalanceHeight
            self.notiButtonTopConstraint.constant = 6
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    // Kéo ra
    func expandHeader() {
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.subHeaderConstraint.constant = self.maxSubHeight
            self.balanceHeightConstraint.constant = self.maxBalanceHeight
            self.notiButtonTopConstraint.constant = 18
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func updateHeader() {
        // Tính theo height constraint của view nhỏ nhất trong 2 view thay đổi height constraint
        let range = maxBalanceHeight - minBalanceHeight
        let openAmount = balanceHeightConstraint.constant - minBalanceHeight
        let percentage = openAmount/range
        balanceView.alpha = percentage
        helloLabel.alpha = percentage
        userNameLabel.alpha = percentage
    }
}
