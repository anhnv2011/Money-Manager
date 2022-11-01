//
//  CustomTabBarController.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//


import UIKit
struct TabBarMenuItem {
    let title: String
    let icon: String
    let type: UIViewController.Type
}

class CustomTabBarController: UITabBarController {
    let topLineTabbarView = UIView()

    static var menu: [TabBarMenuItem] {
        [
            TabBarMenuItem(title: "Home", icon: "house.fill", type: HomeViewController.self),
            TabBarMenuItem(title: "Report", icon: "chart.pie.fill", type: ReportViewController.self),
            TabBarMenuItem(title: "", icon: "", type: AddTransactionViewController.self),
            TabBarMenuItem(title: "Analytics", icon: "chart.bar.fill", type: WalletViewController.self),
            TabBarMenuItem(title: "Account", icon: "person.fill", type: AccountViewController.self)
        ]
        
    }
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        setupIcon()
        setupTitle()
    }
    
    // MARK: configTabbar

    func setupIcon() {
        for (index, item) in (self.tabBar.items ?? []).enumerated() {
            item.image = UIImage(systemName: CustomTabBarController.menu[index].icon)
                
        }
    }
    
    func setupTitle() {
        for (index, item) in (self.tabBar.items ?? []).enumerated() {
            item.title = CustomTabBarController.menu[index].title
        }
    }
    
    private func setupViewControllers() {
        var viewControllers: [UIViewController] = []
        CustomTabBarController.menu.forEach { item in
            viewControllers.append(UINavigationController(rootViewController: item.type.init()))
        }
        setViewControllers(viewControllers, animated: false)
    }
    func setupTabbar(){
        tabBar.backgroundColor = .white
        
        tabBar.tintColor = .mainColor()
        tabBar.unselectedItemTintColor = .iconTabBarColor()
        setupViewControllers()

        
        // Set title propeties by event
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12),
             NSAttributedString.Key.foregroundColor: UIColor.borderColor()], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12),
             NSAttributedString.Key.foregroundColor: UIColor.mainColor()], for: .selected)
        
        configMidButton()
        tabBar.items![2].isEnabled = false  // Disable tabbar at index 2
    }
    
    func configMidButton() {
        tabBar.addSubview(topLineTabbarView)
        topLineTabbarView.frame = .init(x: tabBar.frame.width/20, y: 0, width: tabBar.frame.width/10, height: 2)
        topLineTabbarView.backgroundColor = .mainColor()
        
        let shadowView = UIView(frame: .init(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        let shadowLayer = CAShapeLayer()
        let shadowPath = UIBezierPath(rect: shadowView.bounds)
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.opacity = 0.05
        shadowLayer.shadowOffset = .zero
        shadowLayer.path = shadowPath.cgPath
        
        tabBar.layer.insertSublayer(shadowLayer, at: 0)
        
        let bigCircleView = UIView()
        tabBar.addSubview(bigCircleView)
        bigCircleView.frame = .init(x: 0, y: tabBar.bounds.minY-35, width: 70, height: 70)
        bigCircleView.center.x = tabBar.center.x
        bigCircleView.layer.cornerRadius = 35
        bigCircleView.backgroundColor = .white
        
        let smallCircleView = UIView()
        bigCircleView.addSubview(smallCircleView)
        smallCircleView.frame = .init(x: 5, y: 5, width: 60, height: 60)
        smallCircleView.layer.cornerRadius = 30
        smallCircleView.backgroundColor = .mainColor()
        smallCircleView.layer.masksToBounds = false
        smallCircleView.layer.shadowColor = UIColor.black.cgColor
        smallCircleView.layer.shadowOffset = .init(width: 0, height: 2)
        smallCircleView.layer.shadowOpacity = 0.3
        
        // Middle Button
        let btnAdd = UIButton()
        bigCircleView.addSubview(btnAdd)
        btnAdd.setImage(UIImage(systemName: "plus"), for: .normal)
        btnAdd.tintColor = .white
        btnAdd.frame = .init(x: 0, y: 0, width: 70, height: 70)
        btnAdd.layer.cornerRadius = 35
        btnAdd.addTarget(self, action: #selector(onAdd(_:)), for: .touchUpInside)
    }
    
    // MARK: Middle button action
    @objc func onAdd(_ sender: UIButton) {
        let vc = AddTransactionViewController()
      
        vc.saveCompletion = {[weak self] transaction in
            guard let strongSelf = self, let transaction = transaction else { return }
            
            DataBaseManager.shared.addData(transaction)
            
            NotificationCenter.default.post(name: NSNotification.Name("Add"), object: nil)
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
            self.topLineTabbarView.transform = CGAffineTransform(translationX: self.tabBar.frame.width/5*CGFloat(indexOfTab), y: 0)
        }, completion: nil)
    }
}
