//
//  DataService.swift
//  dev-chat
//
//  Created by Ryan Huebert on 10/20/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

let FIR_CHILD_USERS = "users"

import Foundation
import FirebaseDatabase
import FirebaseStorage

// Remove
import FirebaseAuth


class DataService {
    
    // MARK: Singleton
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    // MARK: References
    var mainReference: FIRDatabaseReference { return FIRDatabase.database().reference() }
    var usersReference: FIRDatabaseReference { return mainReference.child(FIR_CHILD_USERS) }
    var mainStorageReference: FIRStorageReference { return FIRStorage.storage().reference(forURL: "gs://devchat-13f81.appspot.com") }
    var imagesStorageReference: FIRStorageReference { return mainStorageReference.child("images") }
    var videoStorageReference: FIRStorageReference { return mainStorageReference.child("videos") }
    
    // MARK: Functions
    func saveUser(uid: String) {
        let profile: Dictionary<String, Any> = ["firstName": "", "lastName": "", "age": 1] //<String, AnyObject>
        
        usersReference.child(uid).child("profile").setValue(profile) // There is a completiong block with error handling which should be used to try and persist the addition of a user.
    }
    
    func sendMediaPullRequest(senderUID: String, sendingTo: [String:User], metadata: FIRStorageMetadata, textSnippet: String? = nil) {
        var pullRequest: Dictionary<String, Any> = ["mediaURL": metadata.downloadURL()!.absoluteString, "sender":senderUID, "openCount":0, "recipients":trueKeys(dictionary: sendingTo)]
        mainReference.child("pullRequests").childByAutoId().setValue(pullRequest)
        print(" bucker: \(metadata.bucket)")
        
        // Test download of data
        if let path = metadata.path {
            let ref = mainStorageReference.child(path)
            
            print("path: \(ref)")
            
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if (error != nil) {
                    print("Error downloading data")
                    print(error.debugDescription)
                } else {
                    // Data for "images/island.jpg" is returned
                    // ... let islandImage: UIImage! = UIImage(data: data!)
                    print("Complete")
                    
                }
            })
            
        }
        
    }
    
    // MARK: Helper Methods
    // These methods could be turned into extensions. I could not get them working. 20161025
    private func trueKeys(dictionary: [String: Any]) -> [String:Bool] {
        var trueKeys = [String:Bool]()
        dictionary.enumerated().forEach({ trueKeys[$1.key] = true })
        return trueKeys
    }
    
    private func trueKeys(array: [String]) -> [String:Bool] {
        var trueKeys = [String:Bool]()
        array.enumerated().forEach({ trueKeys[$1] = true })
        return trueKeys
    }
}

// For reference later.
//extension Dictionary where Key: String, Value: Any {
//    func trueKeysDictionary() -> [String:Bool] {
//        
//    }
//}
//
//extension Dictionary {
//    func trueKeysDictionary() -> [String:Bool] {
//        var trueKeys = [Key:Bool]()
//        //        enumerated().forEach({ trueKeys[$1.key] = true })
//        
//        for key in keys {
//            trueKeys[key] = true
//            Key
//        }
//    }
//    
//    init(keys: [String]) {
//        self = Dictionary(
//    }
//}
//
//extension Array where Element:Any {
//    func test() {
//        
//    }
//}
//
//extension Array where Element:Int {
//    func test() {
//        enum
//    }
//}
//
//extension Array where Element:String {
//    func trueKeysDictionary() -> [String: Bool] {
//        var trueKeys = [String:Bool]()
//        
//        //keys.enumerated().forEach({ trueKeys[$0.element] = true })
//        return trueKeys
//    }
//}
