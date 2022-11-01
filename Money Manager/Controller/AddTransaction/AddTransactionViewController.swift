//
//  AddTransactionViewController.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import UIKit

class AddTransactionViewController: UIViewController {
    
    // MARK: IBOutlet & var
    @IBOutlet weak var safeView: UIView!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var expenseButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var dateView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
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
    var saveCompletion: ((_ transaction: Transaction?) -> Void)?
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configNavigationBar()
    }
    
    // MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let transaction = transaction else { return }
        if transaction.stt == "+" {
            addIncome()
        }
        iconWidthConstraint.constant = 24
        categoryLeadingConstraint.constant = 8
        imgStr = transaction.image ?? ""
        iconImageView.image = UIImage(systemName: transaction.image ?? "")
        category = transaction.category ?? ""
        categoryTextField.text = transaction.name
        amountTextField.text = transaction.amount
        dateTextField.text = ConvertHelper.share.stringFromDate(date: transaction.date ?? Date(), format: "dd MMM yyyy")
    }
    
    //MARK:- ButtonAction
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case dismissButton:
            dismiss()
        case expenseButton:
            addExpense()
        case incomeButton:
            addIncome()
        case categoryButton:
            enterCategory()
        case saveButton:
            saveNewTransaction()
        default:
            break
        
        }
        
    }
    private func dismiss() {
        
        dismiss(animated: true)
    }
    
    // MARK: Add Expense
    private func addExpense() {
        saveButton.tag = 0
        expenseButton.tintColor = .mainColor()
        expenseButton.titleLabel?.font = .semibold(ofSize: 16)
        incomeButton.tintColor = .black
        incomeButton.titleLabel?.font = .medium(ofSize: 16)
        
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: {
            self.lineView.transform = CGAffineTransform(translationX: self.lineView.bounds.width*CGFloat((self.saveButton.tag)), y: 0)
        }, completion: nil)
    }
    
    // MARK: Add Income
    private func addIncome() {
        saveButton.tag = 1
        expenseButton.titleLabel?.font = .medium(ofSize: 16)
        expenseButton.tintColor = .black
        incomeButton.tintColor = .mainColor()
        incomeButton.titleLabel?.font = .semibold(ofSize: 16)
        
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: {
            self.lineView.transform = CGAffineTransform(translationX: self.lineView.bounds.width*CGFloat((self.saveButton.tag)), y: 0)
        }, completion: nil)
    }
    
    // MARK: Add Category
    private func enterCategory() {
        let vc = CategoryViewController()
        vc.passData = { [weak self] category, name, image, imageWidth, leadingTextField in
            guard let strongSelf = self, let category = category, let name = name, let image = image else { return }
            strongSelf.category = category
            strongSelf.categoryTextField.text = name
            strongSelf.imgStr = image
            strongSelf.iconImageView.image = UIImage(systemName: image)
            strongSelf.iconWidthConstraint.constant = imageWidth
            strongSelf.categoryLeadingConstraint.constant = leadingTextField
        }
        present(vc, animated: true)
    }
    
    // MARK: Save
    private func saveNewTransaction() {
        let date = ConvertHelper.share.dateFormString(string: dateTextField.text ?? "", format: "dd MMM yyyy")
        if categoryTextField.text != "" && amountTextField.text != "" && dateTextField.text != "" {
            if saveButton.tag == 0 {
                transaction = Transaction(category: category, image: imgStr, name: categoryTextField.text, date: date, amount: amountTextField.text, stt: "-")
            } else if saveButton.tag == 1 {
                transaction = Transaction(category: category, image: imgStr, name: categoryTextField.text, date: date, amount: amountTextField.text, stt: "+")
            }
            
            // Load data now to another VC by NotificationCenter
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadData"), object: nil)
            saveCompletion?(transaction)
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
        dateTextField.text = ConvertHelper.share.stringFromDate(date: sender.date, format: "dd MMM yyyy")
    }
    
    @objc func datePickerDone() {
        dateTextField.resignFirstResponder()
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
    private func setupUI() {
        setupSubView()
        setupTextField()
        setupButton()
        
    }
    
    private func setupSubView(){
        lineView.backgroundColor = .mainColor()
        
        categoryView.layer.borderWidth = 1
        categoryView.layer.borderColor = UIColor.borderColor().cgColor
        categoryView.layer.cornerRadius = 10
        
        amountView.layer.borderWidth = 1
        amountView.layer.borderColor = UIColor.borderColor().cgColor
        amountView.layer.cornerRadius = 10
        
        dateView.layer.borderWidth = 1
        dateView.layer.borderColor = UIColor.borderColor().cgColor
        dateView.layer.cornerRadius = 10
    }
    
    private func setupTextField(){
        amountTextField.delegate = self

        amountTextField.keyboardType = .numberPad
        dateTextField.placeholder = ConvertHelper.share.stringFromDate(date: Date(), format: "EEE, dd MMM yyyy")
        dateTextField.text = ConvertHelper.share.stringFromDate(date: Date(), format: "dd MMM yyyy")
        // Setup Date Picker input Text Field
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        // Set doneButton in datePicker view
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        dateTextField.inputAccessoryView = toolBar
    }
    private func setupButton(){
        saveButton.layer.cornerRadius = 10
        saveButton.tintColor = .mainColor()
        saveButton.tag = 0
    }
    
    // MARK: Currenct Fomatter in TextField
    func formatCurrency(string: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale
        let numberFromField = NSString(string: currentString).doubleValue
        amountTextField.text = formatter.string(from: NSNumber(value: numberFromField))
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
