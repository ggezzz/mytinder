//
//  MatchedListViewController.swift
//  MyTinder
//
//  Created by khong fong tze on 20/10/2016.
//  Copyright © 2016 ggezzz. All rights reserved.
//

import UIKit

class MatchedListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var matchedUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Matched List"
        self.tableView.dataSource=self
        loadMatchedUsers()
    }

    func loadMatchedUsers() {
        
        DataService.userRef.child(Session.currentUserUid).child("friends").observe(.childAdded, with: { (snapshot) in
            //if let user1 = User.init(snapshot: snapshot){
                DataService.userRef.child(snapshot.key).observeSingleEvent(of: .value, with: { (snap1) in
                    if let user = User.init(snapshot: snap1){
                        self.matchedUsers.append(user)
                        self.tableView.reloadData()
                    }
                })
            //}
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //loadMatchedUsers()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchedCell") as? MatchingViewCell
        
        let afren = self.matchedUsers[indexPath.row]
        
        if let imageURL = NSURL(string:afren.profilePhotoURL!) {
            //print("\(imageURL) printing IMAGEREF casterView")
            cell?.profilePhoto.sd_setImage(with: imageURL as URL!)
            
        } else {
            cell?.profilePhoto.image = UIImage(named: "avatar-2")
        }
        
        cell?.profilePhoto.tag = indexPath.row
        
        cell?.profilePhoto.clipsToBounds = true
        cell?.profilePhoto.layer.cornerRadius = 20.0
        
        cell?.profilePhoto.isUserInteractionEnabled = true;
//        let tapRec = UITapGestureRecognizer()
//        tapRec.addTarget(self, action: #selector(self.imageTapped(_:)))
//        cell?.profilePhoto.addGestureRecognizer(tapRec)
        
        //cell?.usernameTxt.text = "eeee"//notify.sender.username
        cell?.messageTxt.text = "You are now friend with \(afren.username) "
    
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchedUsers.count
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let afren = self.matchedUsers[indexPath.row]
            DataService.userRef.child(Session.currentUserUid).child("friends").child(afren.userUID).removeValue()
            self.matchedUsers.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    

}
