//
//  LoginViewController.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn
//import FBSDKLoginKit
import FBSDKLoginKit
class LoginViewController: UIViewController {

    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: Setup UI
    func setupUI() {
        userView.layer.borderWidth = 1
        userView.layer.borderColor = UIColor.borderColor().cgColor
        userView.layer.cornerRadius = 10
        
        vPassword.layer.borderWidth = 1
        vPassword.layer.borderColor = UIColor.borderColor().cgColor
        vPassword.layer.cornerRadius = 10
        
        tfPassword.isSecureTextEntry = true
        btnShowPassword.isHidden = true
        tfPassword.delegate = self
        
        btnLogin.layer.cornerRadius = 10
    }
    
   
    
}
// MARK: - Extention TextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        if textField.text != nil {
        //            btnShowPassword.isHidden = false
        //        } else {
        //            btnShowPassword.isHidden = true
        //        }
        btnShowPassword.isHidden = textField.text == nil
    }
}
