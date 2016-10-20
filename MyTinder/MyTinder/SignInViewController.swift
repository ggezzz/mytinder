//
//  ViewController.swift
//  MyTinder
//
//  Created by khong fong tze on 20/10/2016.
//  Copyright © 2016 ggezzz. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func signInBtnPressed(_ sender: UIButton) {
        
        if let email = emailTxt.text, let password = passwordTxt.text {
            if emailTxt.text != "" && passwordTxt.text != "" && !isValidEmail(testStr: email) {
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                        Session.getSingleton.storeUserSession()
                        self.performSegue(withIdentifier: "WelcomeSegue", sender: self)
                    }
                })
            }
            else {
                let alertVC = UIAlertController(title: "Error", message: "Invalid Password/Email Address.", preferredStyle: .alert)
                let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
                
                alertVC.addAction(alertActionOkay)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
}

