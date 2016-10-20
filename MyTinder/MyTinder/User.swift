//
//  InstalkgramUser.swift
//  instalkgram
//
//  Created by khong fong tze on 12/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import Foundation
import FirebaseDatabase



open class User{
    
    var userUID: String
    var username: String
    var createdAt: Double
    
    var gender : String
    var email: String
    var profilePhotoURL: String?
    
    
    init() {
        username = ""
        userUID = ""
        createdAt = 0.0
        email = ""
        profilePhotoURL=""
        gender = ""
    }
    

    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String:AnyObject] else { return nil}
        
        userUID = snapshot.key
        

        print("Init User with dictionary \(dict)")

        if let dictUsername = dict["username"] as? String {
            self.username = dictUsername
        } else {
            self.username = ""
        }
        
        if let createdAt = dict["created_at"] as? Double {
            self.createdAt = createdAt
        } else {
            self.createdAt = 0.0
        }
        
        if let email = dict["email"] as? String{
            self.email = email
        }else {
            self.email = ""
        }
        
        if let profilePhotoURL = dict["profilePhotoURL"] as? String {
            self.profilePhotoURL = profilePhotoURL
        } else {
            self.profilePhotoURL = ""
        }
        
        if let gender = dict["Gender"] as? String {
            self.gender = gender
        } else {
            self.gender = "Female"
        }
    }
    
    }
