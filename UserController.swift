//
//  UserController.swift
//  testFirebase
//
//  Created by Retika Kumar on 3/23/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation
class UserController {
    private let kUser = "userKey"
    static let sharedController = UserController()
    
    var currentUser: User! {
        get {
            guard let uid = FirebaseController.base.authData?.uid, let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(kUser) as? [String: AnyObject] else{
                return nil
            }
            return User(json: userDictionary, identifier: uid)
        }
        set {
            if let newValue = newValue {
                NSUserDefaults.standardUserDefaults().setValue(newValue.jsonValue, forKey: kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(kUser)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    static func userForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        
        FirebaseController.dataAtEndpoint("users/\(identifier)") { (data) -> Void in
            if let json = data as? [String: AnyObject] {
                let  user  = User(json: json, identifier: identifier)
                completion(user: user)
            }else {
                completion(user: nil)
                
            }
        }
    }
    static func createUser(email:String, username:String, password:String, completion:(success:Bool, user:User?) -> Void) {
        FirebaseController.base.createUser(email, password: password) { (error, response) -> Void in
            if let response = response,
                let uid = response["uid"] as? String {
                var user  = User(username: username, uid: uid)
                user.save()
                authenticateUser(email, password: password, completion: { (success, user) -> Void in
                    completion(success: true, user: user)
                })
            }else {
                completion(success: false, user: nil)
            }
        }
    }
    
    static func authenticateUser(email:String, password:String, completion:(success:Bool, user:User?) -> Void) {
        FirebaseController.base.authUser(email, password: password) { (error, response) -> Void in
            if error != nil {
                print("Unsucessful login attempt")
                completion(success: false, user: nil)
                
            } else {
                print("User ID:\(response.uid) authenticated successfully.")
                UserController.userForIdentifier(response.uid, completion: { (user) -> Void in
                    if let user = user {
                        sharedController.currentUser = user
                    }
                    completion(success: true, user: user)
                })
            }
        }
    }
    
    static func updateUser(user: User, username: String, completion: (success:Bool, user:User?) -> Void) {
        var updateUser = User(username: username, uid: user.identifier!)
        updateUser.save()
        
        UserController.userForIdentifier(user.identifier!) { (user) -> Void in
            if let user = user {
                sharedController.currentUser = user
                completion(success: true, user: user)
            } else {
                completion(success: false, user: nil)
            }
        }
    }
    
    
    static func logoutCurrentUser() {
        FirebaseController.base.unauth()
        UserController.sharedController.currentUser = nil
    }
}












 
 
 
 
 
 
