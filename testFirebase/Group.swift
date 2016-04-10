//
//  Group.swift
//  testFirebase
//
//  Created by Retika Kumar on 3/21/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation
class Group {
    
    private let kGroupname = "groupname"

    var groupname: String
    var messages: [Message] = []
    var imageName: String {
        return groupname.lowercaseString
    }

    init(groupname: String) {
        self.groupname = groupname
    }
}

