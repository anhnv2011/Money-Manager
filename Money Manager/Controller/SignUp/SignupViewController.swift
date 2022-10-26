//
//  SignupViewController.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {

    
    // MARK: IBOutlet
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var isCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Setup UI
    func setupUI() {
        setupSubView()
        setupTextField()
        setupButton()
    }
    private func setupSubView(){
        userView.layer.borderWidth = 1
        userView.layer.borderColor = UIColor.borderColor().cgColor
        userView.layer.cornerRadius = 10
        
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.borderColor().cgColor
        passwordView.layer.cornerRadius = 10
    }
    
    private func setupTextField(){
        passwordTextfield.isSecureTextEntry = true
        passwordTextfield.delegate = self
    }
    
    private func setupButton(){
        signupButton.layer.cornerRadius = 10
        signupButton.layer.opacity = 0.5
        showPasswordButton.isHidden = true
    }
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender {
        case loginButton:
            onLogin()
        case signupButton:
            signUp()
        case showPasswordButton:
            onShowPassword()
        case checkButton:
            onCheck()
        default :
            break
        
        }
    
    }
    // MARK: Show Password
    private func onShowPassword() {
        passwordTextfield.isSecureTextEntry = !passwordTextfield.isSecureTextEntry
        passwordTextfield.isSecureTextEntry ? showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal    ) : showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    
    // MARK: Sign Up
    private func signUp() {
        let user = userTextField.text ?? ""
        let password = passwordTextfield.text ?? ""
        var errorMessage = ""
        var alertController = UIAlertController()
        let ok = UIAlertAction(title: "OK", style: .cancel)
        
        if isCheck {
            Auth.auth().createUser(withEmail: user, password: password) { authResult, error in
                if let _ = authResult?.user {
                    let vc = CustomTabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                } else {
                    errorMessage = error?.localizedDescription ?? ""
                    alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true)
                }
            }
        } else {
            errorMessage = "Please! Agree with our Policy"
            alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alertController.addAction(ok)
            self.present(alertController, animated: true)
        }
    }
    
    private func onLogin() {
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func onCheck() {
        if !isCheck {
            checkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            signupButton.layer.opacity = 1
            isCheck = true
        } else {
            checkButton.setImage(UIImage(systemName: "square"), for: .normal)
            signupButton.layer.opacity = 0.5
            isCheck = false
        }
    }
}

// MARK: - Extension TextFieldDelegate
extension SignupViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        if textField.text == nil {
        //            btnShowPassword.isHidden = true
        //        } else {
        //            btnShowPassword.isHidden = false
        //        }
        showPasswordButton.isHidden = textField.text == nil
    }
}
