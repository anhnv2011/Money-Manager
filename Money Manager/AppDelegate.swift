//
//  AppDelegate.swift
//  Money Manager
//
//  Created by MAC on 10/25/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FBSDKCoreKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
//        // Check user login to HomeVC
//        if Auth.auth().currentUser != nil {
//            self.window?.rootViewController = UINavigationController.init(rootViewController: CustomTabBarController())
//        } else {
            self.window?.rootViewController = UINavigationController.init(rootViewController: LoginViewController())
//        }
        
        window?.makeKeyAndVisible()
       
        return true
    }

  
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        
        
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        
    }

}

