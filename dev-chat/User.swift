//
//  User.swift
//  dev-chat
//
//  Created by Ryan Huebert on 10/20/16.
//  Copyright © 2016 Ryan Huebert. All rights reserved.
//

import Foundation

struct User {
    private var _firstName: String
    private var _uid: String
    
    var uid: String {
        return _uid
    }
    
    var firstName: String {
        return _firstName
    }
    
    init(uid: String, firstName: String) {
        _uid = uid
        _firstName = firstName
    }
}
