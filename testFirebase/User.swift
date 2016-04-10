//
//  User.swift
//  testFirebase
//
//  Created by Retika Kumar on 3/21/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation
import Firebase

class User: FirebaseType {
    
    private let kUsername = "username"

    var username = ""
    var identifier: String?
    var endpoint: String {
        return "users"
    }
    var jsonValue: [String: AnyObject] {
        let json: [String: AnyObject] = [kUsername: username]
        
        return json
    }
    
    required init?(json: [String: AnyObject], identifier: String) {
        
        guard let username = json[kUsername] as? String else { return nil }
        
        self.username = username
        self.identifier = identifier
    }
    
    init(username: String, uid: String) {
        
        self.username = username
        self.identifier = uid
    }
}

//func ==(lhs: User, rhs: User) -> Bool {
    
  //  return (lhs.username == rhs.username) && (lhs.identifier == rhs.identifier)
//}
