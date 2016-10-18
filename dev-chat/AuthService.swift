//
//  AuthService.swift
//  dev-chat
//
//  Created by Ryan Huebert on 10/18/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func login(withEmail email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let errorCode = error as? FIRAuthErrorCode{
                print("Error code found: \(errorCode.rawValue)")
                switch errorCode {
                case .errorCodeOperationNotAllowed: break
                case .errorCodeUserNotFound:
                    // Create user. Might not be the best user experience. This will lead to a lot of bogus mistake accounts.
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error as? FIRAuthErrorCode {
                            // Show error to user.
                        } else {
                            if let uid = user?.uid {
                                // Sign in.
                                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                                    if let error = error as? FIRAuthErrorCode {
                                        // Show Error
                                    } else {
                                        // successful login
                                    }
                                })
                            }
                        }
                    })
                default: self.errorNotHandled()
                }
                
            }
        })
    }
    
    private func errorNotHandled() {
        print("Error not handled")
    }
}
