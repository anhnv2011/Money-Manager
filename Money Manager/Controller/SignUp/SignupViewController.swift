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
    @IBOutlet weak var vUser: UIView!
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    
    var isCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Setup UI
    func setupUI() {
        vUser.layer.borderWidth = 1
        vUser.layer.borderColor = UIColor.borderColor().cgColor
        vUser.layer.cornerRadius = 10
        
        vPassword.layer.borderWidth = 1
        vPassword.layer.borderColor = UIColor.borderColor().cgColor
        vPassword.layer.cornerRadius = 10
        
        tfPassword.isSecureTextEntry = true
        btnShowPassword.isHidden = true
        tfPassword.delegate = self
        
        btnSignup.layer.cornerRadius = 10
        btnSignup.layer.opacity = 0.5
    }
    
    // MARK: Show Password
    @IBAction func onShowPassword(_ sender: Any) {
        tfPassword.isSecureTextEntry = !tfPassword.isSecureTextEntry
        tfPassword.isSecureTextEntry ? btnShowPassword.setImage(UIImage(systemName: "eye"), for: .normal    ) : btnShowPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    
    // MARK: Sign Up
    @IBAction func signUp(_ sender: Any) {
        let user = tfUser.text ?? ""
        let password = tfPassword.text ?? ""
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
    
    @IBAction func onLogin(_ sender: Any) {
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func onCheck(_ sender: Any) {
        if !isCheck {
            btnCheck.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            btnSignup.layer.opacity = 1
            isCheck = true
        } else {
            btnCheck.setImage(UIImage(systemName: "square"), for: .normal)
            btnSignup.layer.opacity = 0.5
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
        btnShowPassword.isHidden = textField.text == nil
    }
}
