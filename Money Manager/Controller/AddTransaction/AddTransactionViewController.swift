//
//  AddTransactionViewController.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import UIKit

class AddTransactionViewController: UIViewController {

    // MARK: IBOutlet & var
    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var vLine: UIView!
    
    @IBOutlet weak var btnExpense: UIButton!
    @IBOutlet weak var btnIncome: UIButton!
    
    @IBOutlet weak var vCategory: UIView!
    @IBOutlet weak var vAmount: UIView!
    @IBOutlet weak var vDate: UIView!
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var iconWithConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfDate: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    var currentString = ""
    
    // MARK: datePicker
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.current
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        return datePicker
    }()
    
    var category = ""
    var imgStr = ""
    var transaction: Transaction?
    var passData: ((_ transaction: Transaction?) -> Void)?
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tfAmount.delegate = self
        setupUI()
        configNavigationBar()
    }
    
    // MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let transaction = transaction else { return }
        if transaction.stt == "+" {
            addIncome(self)
        }
        iconWithConstraint.constant = 24
        categoryLeadingConstraint.constant = 8
        imgStr = transaction.image ?? ""
        imgIcon.image = UIImage(systemName: transaction.image ?? "")
        category = transaction.category ?? ""
        tfCategory.text = transaction.name
        tfAmount.text = transaction.amount
        tfDate.text = ConvertHelper.share.stringFromDate(date: transaction.date ?? Date(), format: "dd MMM yyyy")
    }
    
    @IBAction func onBack(_ sender: Any) {
        //        let vc = CustomTabBarController()
        //        navigationController?.pushViewController(vc, animated: true)
        dismiss(animated: true)
    }
    
    // MARK: Add Expense
    @IBAction func addExpense(_ sender: Any) {
        btnSave.tag = 0
        btnExpense.tintColor = .mainColor()
        btnExpense.titleLabel?.font = .semibold(ofSize: 16)
        btnIncome.tintColor = .black
        btnIncome.titleLabel?.font = .medium(ofSize: 16)
        
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: {
            self.vLine.transform = CGAffineTransform(translationX: self.vLine.bounds.width*CGFloat((self.btnSave.tag)), y: 0)
        }, completion: nil)
    }
    
    // MARK: Add Income
    @IBAction func addIncome(_ sender: Any) {
        btnSave.tag = 1
        btnExpense.titleLabel?.font = .medium(ofSize: 16)
        btnExpense.tintColor = .black
        btnIncome.tintColor = .mainColor()
        btnIncome.titleLabel?.font = .semibold(ofSize: 16)
        
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: {
            self.vLine.transform = CGAffineTransform(translationX: self.vLine.bounds.width*CGFloat((self.btnSave.tag)), y: 0)
        }, completion: nil)
    }
    
    // MARK: Add Category
    @IBAction func enterCategory(_ sender: Any) {
        let vc = CategoryViewController()
        vc.passData = { [weak self] category, name, image, imageWidth, leadingTextField in
            guard let strongSelf = self, let category = category, let name = name, let image = image else { return }
            strongSelf.category = category
            strongSelf.tfCategory.text = name
            strongSelf.imgStr = image
            strongSelf.imgIcon.image = UIImage(systemName: image)
            strongSelf.iconWithConstraint.constant = imageWidth
            strongSelf.categoryLeadingConstraint.constant = leadingTextField
        }
        present(vc, animated: true)
    }
    
    // MARK: Save
    @IBAction func onSave(_ sender: Any) {
        let date = ConvertHelper.share.dateFormString(string: tfDate.text ?? "", format: "dd MMM yyyy")
        if tfCategory.text != "" && tfAmount.text != "" && tfDate.text != "" {
            if btnSave.tag == 0 {
                transaction = Transaction(category: category, image: imgStr, name: tfCategory.text, date: date, amount: tfAmount.text, stt: "-")
            } else if btnSave.tag == 1 {
                transaction = Transaction(category: category, image: imgStr, name: tfCategory.text, date: date, amount: tfAmount.text, stt: "+")
            }
            
            // Load data now to another VC by NotificationCenter
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadData"), object: nil)
            passData?(transaction)
            dismiss(animated: true)
            //        navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "Can't save", message: "Please! Enter full information", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel)
            alertController.addAction(ok)
            present(alertController, animated: true)
        }
    }
    
    // MARK: Picker action
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        tfDate.text = ConvertHelper.share.stringFromDate(date: sender.date, format: "dd MMM yyyy")
    }
    
    @objc func datePickerDone() {
        tfDate.resignFirstResponder()
    }
    
    // MARK: Set NavigationBar
    func configNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .mainColor()
        navigationItem.title = "Add transaction"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bold(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backItem?.title = ""
    }
    
    // MARK: Setup UI
    func setupUI() {
        vLine.backgroundColor = .mainColor()
        
        vCategory.layer.borderWidth = 1
        vCategory.layer.borderColor = UIColor.borderColor().cgColor
        vCategory.layer.cornerRadius = 10
        
        vAmount.layer.borderWidth = 1
        vAmount.layer.borderColor = UIColor.borderColor().cgColor
        vAmount.layer.cornerRadius = 10
        
        vDate.layer.borderWidth = 1
        vDate.layer.borderColor = UIColor.borderColor().cgColor
        vDate.layer.cornerRadius = 10
        
        btnSave.layer.cornerRadius = 10
        btnSave.tintColor = .mainColor()
        btnSave.tag = 0
        
        tfAmount.keyboardType = .numberPad
        tfDate.placeholder = ConvertHelper.share.stringFromDate(date: Date(), format: "EEE, dd MMM yyyy")
        tfDate.text = ConvertHelper.share.stringFromDate(date: Date(), format: "dd MMM yyyy")
        // Setup Date Picker input Text Field
        tfDate.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        // Set btnDone in datePicker view
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        tfDate.inputAccessoryView = toolBar
    }
    
    // MARK: Currenct Fomatter in TextField
    func formatCurrency(string: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale
        let numberFromField = NSString(string: currentString).doubleValue
        tfAmount.text = formatter.string(from: NSNumber(value: numberFromField))
    }
}

// Extension Currenct Fomatter in TextField
extension AddTransactionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            currentString += string
            formatCurrency(string: currentString)
        default:
            if string.count == 0 && currentString.count != 0 {
                currentString = String(currentString.dropLast())
                formatCurrency(string: currentString)
            }
        }
        return false
    }
}
