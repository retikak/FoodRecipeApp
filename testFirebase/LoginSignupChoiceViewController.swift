//
//  LoginSignupChoiceViewController.swift
//  testFirebase
//
//  Created by Retika Kumar on 3/23/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import UIKit

class LoginSignupChoiceViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func assignbackground(){
        let background = UIImage(named: "food2")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSignin" {
            let destinationViewController = segue.destinationViewController as! LoginSignupViewController
            destinationViewController.viewMode = LoginSignupViewController.ViewMode.Signup
            
        } else  if  segue.identifier == "toLogin" {
            let  destinationViewController = segue.destinationViewController as! LoginSignupViewController
            destinationViewController.viewMode = LoginSignupViewController.ViewMode.Login
        }
        
    }
    


}
