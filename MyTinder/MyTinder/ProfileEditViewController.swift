//
//  ProfileEditViewController.swift
//  Cast
//
//  Created by Raphael Lim on 6/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    let profileSections : [String] = ["username", "gender"]
    var selectedUser : User!
    
    //    let profileImages: [UIImage] = [UIImage(named: "users")!, UIImage(named:"gender")!, UIImage(named: "crown2")!, UIImage(named:"informationbutton")!, UIImage(named:"globe")!, UIImage(named:"location-pin-512")!]
    //    let profileImages: [String] = ["users", "gender", "crown2", "informationbutton", "globe", "mail"]
    
    var selectedCategory : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        retrieveProfileImage()
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        profileImageView.isUserInteractionEnabled = true
        
    }
    
    func selectProfileImage () {
        let picker = UIImagePickerController ()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            // set the profile image
            profileImageView.image = selectedImage
            let storageRef = FIRStorage.storage().reference()
            let userRef = storageRef.child("profilePhotoURL").child(Session.currentUserUid)
            
            if let uploadData = UIImageJPEGRepresentation(selectedImage, 0.7) {
                
                userRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil{
                        print(error)
                        return
                    } else {
                        if let imageURL = metadata?.downloadURLs?.first {
                            DataService.userRef.child(Session.currentUserUid).child("profilePhotoURL").setValue(imageURL.absoluteString)
                            
                        }
                    }
                })
                
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileEditCell
        _ = self.profileSections[(indexPath as NSIndexPath).row]
        if self.selectedUser != nil {
            cell.usernameLabel.text = self.selectedUser.username
            cell.genderLabel.text = self.selectedUser.gender
        }
        cell.cellImageView.image = UIImage(named: "users")
        return cell
    }
    
    
    func retrieveProfileImage (){
        
        if self.selectedUser == nil {
            DataService.userRef.child(Session.currentUserUid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let user = User(snapshot: snapshot) {
                    self.selectedUser = user
                    
                    if let profileImageLink = self.selectedUser.profilePhotoURL {
                        let profileImageUrl = NSURL(string: profileImageLink)
                        self.profileImageView.sd_setImage(with: profileImageUrl as URL!)
                    } else {
                        self.profileImageView.image = UIImage(named: "users")
                    }
                }
            })
            
        }
        
        
    }
    
    
    @IBAction func backButton(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCategory = profileSections[{indexPath as NSIndexPath}().row]
        performSegue(withIdentifier: "editSectionSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pass the user UID
        // pass which cell was clicked
        
        //        let destination = segue.destination as! EditDetailViewController
        //        destination.userUID = Session.currentUserUid
        //        destination.category = self.selectedCategory
    }
    
}
