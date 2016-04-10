//
//  CuisineChatListTableViewController.swift
//  testFirebase
//
//  Created by Retika Kumar on 3/25/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import UIKit

    class CuisineChatListTableViewController: UITableViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var messages = [Message]()
    var recipes = [Recipe]()
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCuisineMessages()
        fetchAllRecipes()
    }
    
    func fetchAllRecipes() {
        RecipeController.searchRecipeByCuisine(group?.groupname ?? "") { (recipes) in
            self.recipes = recipes
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadCuisineMessages()
        
    }
    
    //TODO: list all messages for a particular cuisine
    
    func loadCuisineMessages() {
        MessageController.observeMessagesForCuisineGroup(self.group!) { (messages) in
            self.messages = messages
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return messages.count
        } else {
            return recipes.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            let message = messages[indexPath.row]
            cell.textLabel?.text = message.text
            if let imageEndpoint = message.imageEndpoint {
                ImageController.imageForIdentifier(imageEndpoint, completion: { (image) in
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.imageView?.image = image
                    })
                })
            }
            
            let imageName = "hamburger_filled"
            let image = UIImage(named: imageName)
            cell.imageView!.image = image
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath)
            
            let recipe = recipes[indexPath.row]
            cell.textLabel?.text = recipe.recipeName
            cell.detailTextLabel?.text = recipe.id
            return cell
        }
    }
    
    @IBAction func segmentedControlTapped(sender: UISegmentedControl) {
        tableView.reloadData()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let cell = sender as? UITableViewCell,
        indexPath = tableView.indexPathForCell(cell) where segue.identifier == "toMessageShowDetail" {
                    let message = messages[indexPath.row]
                    let destinationViewController = segue.destinationViewController as? CuisineChatDetailViewController
                    destinationViewController?.message = message
                    
        } else if  segue.identifier == "toMessageDetailView" {
                let destinationVeiewController = segue.destinationViewController as? CuisineChatDetailViewController
                destinationVeiewController?.group = group
            
        } else if segue.identifier == "toRecipeDetailView" {
                
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                    let recipe = recipes[indexPath.row]
                    
                    let destinationViewController = segue.destinationViewController as? RecipeDetailViewController
                    
                    destinationViewController?.recipe = recipe
                }
            }
            
            
        }
        
    }
    
