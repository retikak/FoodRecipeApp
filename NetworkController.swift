//
//  NetworkController.swift
//  RecipeExtensionAPIWork
//
//  Created by Retika Kumar on 4/1/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation
class NetworkController {
    static func dataAtURL(url: String, completion: (data: NSData?) -> Void) {
        let urlEscaped = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        if let url = NSURL(string: urlEscaped!) {
            let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) in
                if let error = error {
                    print("Error fetching data at \(url). \(error.localizedDescription)")
                    completion(data: nil)
                } else if let data = data {
                    completion(data: data)
                } else {
                    completion(data: nil)
                    print("No data")
                }
            })
            dataTask.resume()
        } else {
            completion(data: nil)
            print("The given url is not a valid url")
        }
    }
    
}
