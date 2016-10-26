//
//  AuthService.swift
//  dev-chat
//
//  Created by Ryan Huebert on 10/18/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias Completion = (_ errorMessage: String?, _ data: AnyObject?) -> Void

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    var currentUserUID: String? {
        get {
            return FIRAuth.auth()?.currentUser?.uid
        }
    }
    
    func login(withEmail email: String, password: String, onCompletion: Completion?) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if let e = (error as? NSError)?.code, let errorCode = FIRAuthErrorCode(rawValue: e) {
                
                print("Firebase error code found: \(errorCode) raw value:\(errorCode.rawValue)")
                switch errorCode {
                case .errorCodeUserNotFound:
                    // 17011 Create user. Might not be the best user experience. This will lead to a lot of bogus mistake accounts.
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            // Show error to user.
                            self.handleFirebaseError(error: error, onComplete: onCompletion)
                        } else {
                            if let uid = user?.uid {
                                // Add user to database.
                                DataService.instance.saveUser(uid: uid)
                                // Sign in.
                                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                                    if let error = error {
                                        // Unsuccessful Login
                                        self.handleFirebaseError(error: error, onComplete: onCompletion)
                                        
                                        
                                        
                                    } else {
                                        // Successful Login
                                        onCompletion?(nil, user)
                                    }
                                })
                            }
                        }
                    })
                    // Handle all other errors
                default: self.handleFirebaseError(error: error!, onComplete: onCompletion)
                }
                
            } else {
                print("Succesfully signed in")
                onCompletion?(nil, user)
            }
        })
    }
    
    func signOut() {
    }
    
    private func errorNotHandled() {
        print("Error not handled")
    }
    
    func handleFirebaseError(error: Error?, onComplete: Completion?) {
        
        if let e = (error as? NSError)?.code, let errorCode = FIRAuthErrorCode(rawValue: e){
            print ("handleFirebaseError errorCode:\(errorCode.rawValue)")
            switch errorCode {
            case .errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil)
                
                
            case .errorCodeWrongPassword:
                onComplete?("Invalid password", nil)
               
            case .errorCodeEmailAlreadyInUse:
                onComplete?("Could not create account. Email already in use", nil)
                
            case .errrorCodeAccountExistsWithDifferentCredential:
                onComplete?("Could not create account. Wrong credentials.", nil)
                
            default:
                onComplete?("There was a problem authenticating. Try again.", nil)
                
            }
        }
    
    }
}
