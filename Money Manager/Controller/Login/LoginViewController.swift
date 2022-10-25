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
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var forgotPassButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: Setup UI
    func setupUI() {
        userView.layer.borderWidth = 1
        userView.layer.borderColor = UIColor.borderColor().cgColor
        userView.layer.cornerRadius = 10
        
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.borderColor().cgColor
        passwordView.layer.cornerRadius = 10
        
        passwordTextField.isSecureTextEntry = true
        showPasswordButton.isHidden = true
        passwordTextField.delegate = self
        
        loginButton.layer.cornerRadius = 10
    }
    
    //MARK:- Button Action
   
    @IBAction func ButtonAction(_ sender: UIButton) {
        switch sender {
        case loginButton:
            normalLogin()
        case signupButton:
            onSignup()
        case forgotPassButton:
            onForgotPassword()
        case showPasswordButton:
            onShowPassword()
        case googleLoginButton:
            loginWithGoogle()
        case facebookLoginButton:
            loginWithFB()
        case appleLoginButton:
            break
        default:
            break
        }
    }
    private func onSignup() {
        let vc = SignupViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    private func onForgotPassword() {
       
    }
    private func onShowPassword() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        passwordTextField.isSecureTextEntry ? showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal    ) : showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    private func loginWithGoogle(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let signInConfig = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if let error = error {
                print(error)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    let authError = error as NSError
                    if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                        // The user is a multi-factor user. Second factor challenge is required.
                        let resolver = authError
                            .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                        var displayNameString = ""
                        for tmpFactorInfo in resolver.hints {
                            displayNameString += tmpFactorInfo.displayName ?? ""
                            displayNameString += " "
                        }
                        
                    } else {
                        
                        return
                    }
                    // ...
                    return
                }
                // User is signed in
                let vc = CustomTabBarController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    // MARK: Login with FB
    private func loginWithFB() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self) { result, error in
            if let error = error {
                print("Encountered Erorr: \(error)")
            } else if let result = result, result.isCancelled {
                print("Cancelled")
            } else {
                print("Logged In")
                
                let credential = FacebookAuthProvider
                    .credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        let authError = error as NSError
                        if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                            // The user is a multi-factor user. Second factor challenge is required.
                            let resolver = authError
                                .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                            var displayNameString = ""
                            for tmpFactorInfo in resolver.hints {
                                displayNameString += tmpFactorInfo.displayName ?? ""
                                displayNameString += " "
                            }
                        } else {
                            return
                        }
                        // ...
                        return
                    }
                    // User is signed in
                    let vc = CustomTabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
        }
    }
       
    private func normalLogin(){
        let email = userTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let _ = authResult {
                let vc = CustomTabBarController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            } else {
                let alertController = UIAlertController(title: "Error", message: "\(error?.localizedDescription ?? "")", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(ok)
                self.present(alertController, animated: true)
            }
        }
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
        showPasswordButton.isHidden = textField.text == nil
    }
}
//com.googleusercontent.apps.576522880604-q8iup2bg23m1e07j54bsi10gbs2m1m6r
