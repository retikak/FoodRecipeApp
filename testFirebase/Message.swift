//
//  Message.swift
//  testFirebase
//
//  Created by Retika Kumar on 3/21/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation

struct Message: FirebaseType {
    private let kSender = "sender"
    private let kText = "text"
    private let kGroupIdentifier = "group"
    private let kImageEndpoint = "image"
    
    let sender: String
    let text: String
    let groupIdentifier: String
    let imageEndpoint: String?
    
    var identifier: String?
    var endpoint: String {
        return "messages"
    }
    var jsonValue: [String: AnyObject] {
        var json: [String: AnyObject] = [kSender:sender, kText:text, kGroupIdentifier : groupIdentifier]
        if let imageEndpoint = imageEndpoint {
            json[kImageEndpoint] = imageEndpoint
        }
        return json
    }
    
    init(groupIdentifier: String, sender: String, text: String, imageEndpoint: String) {
        self.groupIdentifier = groupIdentifier
        self.sender = sender
        self.text =  text
        self.imageEndpoint = imageEndpoint
    }
    
    init?(json: [String: AnyObject], identifier: String) {
        guard let groupIdentifier = json[kGroupIdentifier] as? String, sender = json[kSender] as? String,
            text = json[kText] as? String, imageEndpoint = json[kImageEndpoint] as? String else {return nil}
        
        self.groupIdentifier = groupIdentifier
        self.sender = sender
        self.text = text
        self.identifier = identifier
        self.imageEndpoint = imageEndpoint
    }
}