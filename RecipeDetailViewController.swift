//
//  RecipeDetailViewController.swift
//  RecipeExtensionAPIWork
//
//  Created by Retika Kumar on 4/2/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import UIKit
import SafariServices

class RecipeDetailViewController: UIViewController, UITextFieldDelegate, SFSafariViewControllerDelegate{
    
    var directionsURL: NSURL?
    var recipe: Recipe?
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var sourceDisplayNameLabel: UILabel!
    @IBOutlet weak var directions: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDetailView()
        
    }
    
    func fetchImage() {
        
        if let recipe = self.recipe,
            let url = recipe.imageUrls.first {
            NetworkController.dataAtURL(url, completion: { (data) in
                
                if let data = data {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let image = UIImage(data: data)
                        self.iconImageView.image = image
                    })
                }
                RecipeController.searchRecipeByID(recipe.id, completion: { (directionsStringURL) in
                    
                    if let directionsStringURL = directionsStringURL  {
                        self.directionsURL = NSURL(string: directionsStringURL)
                        
                    }
                })
            })
        }
    }
    func fetchRating() {
        self.ratingLabel.text = String(recipe?.rating ?? 0)
    }
    
    
    func fetchIngredients() {
        if let ingredients = recipe?.ingredients {
            self.ingredientsLabel.text = ingredients.joinWithSeparator(", \n")
            
        }
    }
    
    func sourceDisplayName() {
        sourceDisplayNameLabel.text = recipe?.sourceDisplayName
    }
    
    func updateDetailView() {
        
        if let recipe = self.recipe {
            fetchImage()
            recipeNameLabel.text = recipe.recipeName
            fetchRating()
            fetchIngredients()
            sourceDisplayName()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func directionsTapped(sender: AnyObject) {
        showRecipeWebSite()
    }
    
    
    func showRecipeWebSite() {
        if let directionsURL = directionsURL{
            let webVC = SFSafariViewController(URL: directionsURL)
            webVC.delegate = self
            self.presentViewController(webVC, animated: true, completion: nil)
            
        }
    }
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}