//
//  ProfileViewController.swift
//  Cast
//
//  Created by Raphael Lim on 30/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage


class ProfileViewController: UIViewController {
    @IBOutlet weak var genderTextField: UILabel!
    @IBOutlet weak var usernameTextField: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var descriptionTextField: UILabel!
    var selectedUser : User!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        
        retrieveUserData()

    }
    
    func retrieveUserData () {
        DataService.userRef.child(Session.currentUserUid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let user = User(snapshot: snapshot) {
                self.selectedUser = user
                self.usernameTextField.text = user.username
                self.genderTextField.text = user.gender
                if let profileImageLink = user.profilePhotoURL {
                    let profileImageUrl = NSURL(string: profileImageLink)
                    self.profileImageView.sd_setImage(with: profileImageUrl as URL!)
                } else {
                    self.profileImageView.image = UIImage(named: "users")
                }
            }
        })
    }
    

    
    @IBAction func logoutButton(_ sender: AnyObject) {
        
        try! FIRAuth.auth()!.signOut()
        UserDefaults.standard.removeObject(forKey: Session.sessionKey)
        
        let storyboard = UIStoryboard(name: "Main", bundle:  Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    @IBAction func editButton(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "editProfileSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="editProfileSegue" {
            let editVC = segue.destination as! ProfileEditViewController
            editVC.selectedUser = self.selectedUser
        }
    }
    
}



