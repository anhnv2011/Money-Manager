//
//  CustomTabBarController.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//


import UIKit

class CustomTabBarController: UITabBarController {
    
    let vTopLineTabbar = UIView()
    
    let controller1 = HomeViewController()
    let controller2 = ReportViewController()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        
        tabBar.tintColor = .mainColor()
        tabBar.unselectedItemTintColor = .iconTabBarColor()
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)
        
        controller1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill", withConfiguration: iconConfig), tag: 1)
        let nav1 = UINavigationController(rootViewController: controller1)
        
        controller2.tabBarItem = UITabBarItem(title: "Report", image: UIImage(systemName: "chart.pie.fill", withConfiguration: iconConfig), tag: 2)
        let nav2 = UINavigationController(rootViewController: controller2)
        
        let controller3 = AddTransactionViewController()
        let nav3 = UINavigationController(rootViewController: controller3)
        nav3.title = ""
        
        let controller4 = WalletViewController()
        controller4.tabBarItem = UITabBarItem(title: "Analytics", image: UIImage(systemName: "chart.bar.fill", withConfiguration: iconConfig), tag: 4)
        let nav4 = UINavigationController(rootViewController: controller4)
        
        let controller5 = AccountViewController()
        controller5.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.fill", withConfiguration: iconConfig), tag: 5)
        let nav5 = UINavigationController(rootViewController: controller5)
        
        viewControllers = [nav1, nav2, nav3, nav4, nav5]
        
        // Set title propeties by event
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12),
             NSAttributedString.Key.foregroundColor: UIColor.borderColor()], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12),
             NSAttributedString.Key.foregroundColor: UIColor.mainColor()], for: .selected)
        
        configTabBar()
        tabBar.items![2].isEnabled = false  // Disable tabbar at index 2
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: configTabbar
    func configTabBar() {
        tabBar.addSubview(vTopLineTabbar)
        vTopLineTabbar.frame = .init(x: tabBar.frame.width/20, y: 0, width: tabBar.frame.width/10, height: 2)
        vTopLineTabbar.backgroundColor = .mainColor()
        
        let vShadow = UIView(frame: .init(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        let shadowLayer = CAShapeLayer()
        let shadowPath = UIBezierPath(rect: vShadow.bounds)
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.opacity = 0.05
        shadowLayer.shadowOffset = .zero
        shadowLayer.path = shadowPath.cgPath
        
        tabBar.layer.insertSublayer(shadowLayer, at: 0)
        
        let vBigCircle = UIView()
        tabBar.addSubview(vBigCircle)
        vBigCircle.frame = .init(x: 0, y: tabBar.bounds.minY-35, width: 70, height: 70)
        vBigCircle.center.x = tabBar.center.x
        vBigCircle.layer.cornerRadius = 35
        vBigCircle.backgroundColor = .white
        
        let vSmallCircle = UIView()
        vBigCircle.addSubview(vSmallCircle)
        vSmallCircle.frame = .init(x: 5, y: 5, width: 60, height: 60)
        vSmallCircle.layer.cornerRadius = 30
        vSmallCircle.backgroundColor = .mainColor()
        vSmallCircle.layer.masksToBounds = false
        vSmallCircle.layer.shadowColor = UIColor.black.cgColor
        vSmallCircle.layer.shadowOffset = .init(width: 0, height: 2)
        vSmallCircle.layer.shadowOpacity = 0.3
        
        // Middle Button
        let btnAdd = UIButton()
        vBigCircle.addSubview(btnAdd)
        btnAdd.setImage(UIImage(systemName: "plus"), for: .normal)
        btnAdd.tintColor = .white
        btnAdd.frame = .init(x: 0, y: 0, width: 70, height: 70)
        btnAdd.layer.cornerRadius = 35
        btnAdd.addTarget(self, action: #selector(onAdd(_:)), for: .touchUpInside)
    }
    
    // MARK: Middle button action
    @objc func onAdd(_ sender: UIButton) {
        let vc = AddTransactionViewController()
        let firstDayOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))
        let lastDayOfMonth = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date())+1))
        
        vc.passData = {[weak self] transaction in
            guard let strongSelf = self, let transaction = transaction else { return }
            //            strongSelf.controller1.transaction.insert(transaction, at: 0)
            //            strongSelf.controller1.transaction.sort(by: { $1.date ?? Date() < $0.date ?? Date() })
            DataBaseManager.shared.addData(transaction)
            strongSelf.controller1.transaction = DataBaseManager.shared.getMonthData(firstDayOfMonth ?? Date(), lastDayOfMonth ?? Date())
            strongSelf.controller1.tableView.reloadData()
        }
        present(vc, animated: true)
        //        navigationController?.pushViewController(vc, animated: false)
    }
}

// MARK: Animation didSelect
extension CustomTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        guard let indexOfTab = tabBar.items?.firstIndex(of: item) else { return }
        
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: {
            self.vTopLineTabbar.transform = CGAffineTransform(translationX: self.tabBar.frame.width/5*CGFloat(indexOfTab), y: 0)
        }, completion: nil)
    }
}
