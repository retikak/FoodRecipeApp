//
//  Recipes.swift
//  RecipeExtensionAPIWork
//
//  Created by Retika Kumar on 4/1/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import Foundation
struct Recipe {
    
    private let kRecipeName = "recipeName"
    private let kCuisineName = "cuisine"
    private let kImages = "smallImageUrls"
    private let kIngredients = "ingredients"
    private let krecipeID = "id"
    private let kRating = "rating"
    private let kSourceDisplayName = "sourceDisplayName"
    
    var recipeName: String
    var imageUrls: [String]
    var ingredients: [String]
    var id: String
    var rating : Int
    var sourceDisplayName: String
    
    init?(jsonDictionary: [String : AnyObject]) {
        guard let recipeName = jsonDictionary[kRecipeName] as? String else { return nil }
        
        self.recipeName = recipeName
        self.imageUrls = jsonDictionary[kImages] as? [String] ?? []
        self.ingredients = jsonDictionary[kIngredients] as? [String] ?? []
        self.id = jsonDictionary[krecipeID] as? String ?? ""
        self.rating = jsonDictionary[kRating] as? Int ?? 0
        self.sourceDisplayName = jsonDictionary[kSourceDisplayName] as? String ?? ""

    }
    
    

}
    