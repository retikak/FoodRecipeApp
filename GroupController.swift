//
//  GroupController.swift
//  testFirebase
//
//  Created by Retika Kumar on 3/23/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation
class GroupController {
    private let kGroup = "groupKey"
    
    static func fetchAllGroups(completion: (groups: [Group]) -> Void){
        FirebaseController.dataAtEndpoint("groups") { (data) in
            if let data = data as? [String: Bool] {
                let groups = data.flatMap({ (name, _ ) -> Group in
                    return Group(groupname: name)
                })
                completion(groups: groups)
            } else {
                completion(groups: [])
            }
        }
    }

}

