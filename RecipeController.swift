//
//  RecipeController.swift
//  RecipeExtensionAPIWork
//
//  Created by Retika Kumar on 4/1/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation


class RecipeController {
    
    static let baseURLKey = "https://api.yummly.com/v1"
    static let apiKey = "db906b1bb9aa10be45ffb3d4676d45e8"
    static let appId = "edd3f7af"
    static let baseURL = "https://api.yummly.com/v1"

    static func searchRecipeByCuisine(cuisineType: String, completion: (recipes: [Recipe]) -> Void) {
        
        let cuisineSearchURL = "\(baseURLKey)" + "/api/recipes?_app_id=\(appId)&_app_key=\(apiKey)&allowedCuisine[]=cuisine^cuisine-\(cuisineType.lowercaseString)&maxResult=15&start=0"
        
        
            NetworkController.dataAtURL(cuisineSearchURL, completion: { (data) -> Void in
                if let data = data,
                    let jsonAnyObject = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
                    let jsonDictionary = jsonAnyObject as?  [String: AnyObject],
                    let resultsArray = jsonDictionary["matches"] as? [[String: AnyObject]] {
                    
                    var recipes = [Recipe]()
                    for resultDictionary in resultsArray {
                        if let recipe = Recipe(jsonDictionary: resultDictionary) {
                            recipes.append(recipe)
                        }
                    }
                    completion(recipes: recipes)
                } else {
                    completion(recipes: [])
                }
            })
        }
    
    static func searchRecipeByID(ID: String, completion: (directionsURL: String?) -> Void) {
        
        let cuisineSearchByID = "\(baseURLKey)" + "/api/recipe/\(ID)?_app_id=\(appId)&_app_key=\(apiKey)"
        
        
        NetworkController.dataAtURL(cuisineSearchByID, completion: { (data) -> Void in
            if let data = data,
                let jsonAnyObject = try? NSJSONSerialization.JSONObjectWithData(data, options: []),
                let jsonDictionary = jsonAnyObject as?  [String: AnyObject],
                let sourceDictionary = jsonDictionary["source"] as? [String: AnyObject],
                let sourceURl = sourceDictionary["sourceRecipeUrl"] as? String {
                print(sourceURl)
                    
                completion(directionsURL: sourceURl)
            } else {
                completion(directionsURL: nil)
            }
        })
    }
    
}
        
