//
//  UsersViewController.swift
//  dev-chat
//
//  Created by Ryan Huebert on 10/20/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    private var users = [User]()
    private var selectedUsers = [String:User]() {
        didSet {
            // updateRightBarButtonItem()
        }
    }
    
    var photoData: Data?
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsMultipleSelection = true
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        DataService.instance.usersReference.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            
            
            //print("Snap: \(snapshot.debugDescription)")
            
            if let users = snapshot.value as? Dictionary<String, Any> {
                for (key, value) in users {
                    if let dict = value as? Dictionary<String, Any> {
                        if let profile = dict ["profile"] as? Dictionary<String, Any> {
                            if let firstName = profile["firstName"] as? String {
                                let uid = key
                                let user = User(uid: uid, firstName: firstName)
                                self.users.append(user)
                            }
                        }
                    }
                }
            }
            
            self.tableView.reloadData()
            print("users: \(self.users)")
        }
    }
    
    func updateRighBarButtonItem() {
        if selectedUsers.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! UserTableViewCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
        
        updateRighBarButtonItem() // navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserTableViewCell
        cell.setCheckmark(selected: false)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = nil

        updateRighBarButtonItem()
//        if selectedUsers.isEmpty {
//            navigationItem.rightBarButtonItem?.isEnabled = false
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendPullRequestButtonPressed() {
        guard let senderUID = AuthService.instance.currentUserUID else {
            // Current user does not exist. Re-authenticate.
            return
        }
        
        if let url = videoURL {
            let videoName = "\(UUID().uuidString)\(url)"
            let ref = DataService.instance.videoStorageReference.child(videoName)
            
            ref.putFile(url, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    print("Error uploading video: \(error.localizedDescription)")
                } else if let downloadURL = metadata?.downloadURL() {print("Are these the same? ref: \(ref.fullPath) downloadURL: \(downloadURL.absoluteString))")

                    DataService.instance.sendMediaPullRequest(senderUID: senderUID, sendingTo: self.selectedUsers, metadata: metadata!, textSnippet: "This is a test snippet.")
                    
                    
                    // save somewhere? cache?
                }
                
            })
            
            self.dismiss(animated: true, completion: nil)
            
        } else if let photoData = photoData {
            let ref = DataService.instance.imagesStorageReference.child("\(UUID().uuidString).jpg")
            
            ref.put(photoData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    print("Error uploading images: \(error.localizedDescription)")
                } else if let metadata = metadata {
                    
                    DataService.instance.sendMediaPullRequest(senderUID: senderUID, sendingTo: self.selectedUsers, metadata: metadata, textSnippet: "This is a test snippet.")
                    
                }
            })
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}


