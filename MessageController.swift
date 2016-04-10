//
// MessageController.swift
//  test
//
//  Created by Retika Kumar on 3/23/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation
import UIKit

class MessageController {
    
    static let sharedController = MessageController()
    var message: [Message] = []
    
    
    
    static func observeMessagesForCuisineGroup(group: Group, completion: (messages: [Message]) -> Void) {
        FirebaseController.base.childByAppendingPath("messages").queryOrderedByChild("group").queryEqualToValue(group.groupname).observeEventType(.Value, withBlock: { (data) in
            if let messageDictionaries = data.value as? [String: [String:AnyObject]] {
                
                let messages = messageDictionaries.flatMap({Message (json: $0.1 , identifier: $0.0)})
                
                let orderedMessages = orderMessages(messages)
                
                completion(messages: orderedMessages)
            }
            
        })
        
    }
    
    
    static func createMessage(sender: String, text: String, group: Group, image: UIImage?, completion: (success:Bool, message: Message?) -> Void){
        if let image = image {
            ImageController.uploadImage(image) { (identifier) -> Void in
                if let identifier = identifier {
                    var message = Message(groupIdentifier: group.groupname, sender: UserController.sharedController.currentUser.identifier!, text: text, imageEndpoint: identifier)
                    message.save()
                    
                    completion(success: true, message: message)
                    
                    
                } else {
                    completion(success: false, message: nil)
                }
            }
        }
        
    }
    
    
    static func orderMessages(message: [Message]) -> [Message] {
        
        return message.sort({$0.0.identifier > $0.1.identifier})
    }
    
}

