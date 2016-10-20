//
//  SignUpViewController.swift
//  MyTinder
//
//  Created by khong fong tze on 20/10/2016.
//  Copyright © 2016 ggezzz. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    var appDelegate : AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        
        guard
            let username = usernameTxt.text,
            let password = passwordTxt.text,
            let email = emailTxt.text
            else {
                return
        }
        
        if !isValidEmail(testStr: email) {
            
            let alertVC = UIAlertController(title: "Error", message: "Invalid Email Address.", preferredStyle: .alert)
            let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
            
            alertVC.addAction(alertActionOkay)
            self.present(alertVC, animated: true, completion: nil)
        } else {
            
            //calling Firebase to create the user
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                //completed executing createUserWithEmail
                if let user = user {
                    
                    //                if !user.isEmailVerified{
                    //                    let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \(email).", preferredStyle: .alert)
                    //                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                    //                        (_) in
                    //                        user.sendEmailVerification(completion: nil)
                    //                    }
                    //                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    //
                    //                    alertVC.addAction(alertActionOkay)
                    //                    alertVC.addAction(alertActionCancel)
                    //                    self.present(alertVC, animated: true, completion: nil)
                    //                } else {
                    
                    
                    Session.getSingleton.storeUserSession()
                    self.performSegue(withIdentifier: "WelcomeSegue", sender: sender)
                    
                    let currentUserRef = DataService.rootRef.child("users").child(user.uid)
                    let userDict = ["email":email, "username":username]
                    currentUserRef.setValue(userDict)
                    
                    
//                    let storyboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
//                    
//                    // load view controller with the storyboardID of ChatListViewController
//                    let profilevc = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
//                    
//                    self.appDelegate.window?.rootViewController = profilevc
                    //}
                    
                    
                } else {
                    //failed
                    let alert = UIAlertController(title: "Failed to sign up", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                    alert.addAction(dismissAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            })
            
        }
        
    }
    
    
}
