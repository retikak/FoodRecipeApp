//
//  GroupsViewController.swift
//  testFirebase
//
//  Created by Retika Kumar on 3/23/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    private let kMargin = CGFloat(5.0)
    
    var groups: [Group] = []
    
    
    
    @IBOutlet weak var collectionFlow: UICollectionViewFlowLayout!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GroupController.fetchAllGroups { (groups) in
            self.groups = groups
            self.collectionView.reloadData()
            self.tabBarItem = UITabBarItem(title: "Cuisine Chat", image: UIImage(named: "users_three"), selectedImage: UIImage(named: "users_three"))
            
        }
    }
    
    //TODO: CHECK TO SEE IF VIEW WILL APPEAR IS CORRECT
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let currentUser = UserController.sharedController.currentUser {
            
        } else {
            
            tabBarController?.performSegueWithIdentifier("noCurrentUserSegue", sender: nil)
        }
    }
    
    //MARK:- CollectionView Delegate FLowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let viewWidth = view.frame.width
        let viewWidthMinusMargin = viewWidth - 2 * kMargin
        let itemDimension = viewWidthMinusMargin / 2.0
        return CGSize(width: view.frame.width / 2 - 1, height: view.frame.height / 4 - 1)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func icon8(sender: AnyObject) {
        let alert = UIAlertController(title: "icons created by:", message: "https://icons8.com/", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Take me to their website", style: .Default, handler: { (iconsLink) -> Void in
            let icons8 = NSURL(string: "https://icons8.com")
            UIApplication.sharedApplication().openURL(icons8!)
            
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
    

        UserController.sharedController.currentUser = nil
        performSegueWithIdentifier("noCurrentUser", sender: self)
        
        
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageCollectionViewCell
        let group = groups[indexPath.row]
        let image = UIImage(named: group.imageName)
        imageCell.foodNameLabel.text = group.groupname
        imageCell.imageView.image = image
        return imageCell
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toListView" {
            if let cell = sender as? ImageCollectionViewCell, let indexPath = collectionView.indexPathForCell(cell) {
                let group = groups[indexPath.row]
                
                let destinationViewController = segue.destinationViewController as? CuisineChatListTableViewController
                destinationViewController?.group = group
            }
            
            
        }
        
    }
}

