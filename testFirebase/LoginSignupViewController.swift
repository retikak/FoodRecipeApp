//
//  LoginSignupViewController.swift
//  testFirebase
//
//  Created by Retika Kumar on 3/23/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import UIKit

class LoginSignupViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var  image = UIImage()
    
    enum ViewMode {
        
        case Login
        case Signup
        case Edit
        
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var AddProfileButton: UIButton!
    
    var viewMode = ViewMode.Signup
    var fieldsAreValid: Bool {
        get {
            switch viewMode {
            case .Login:
                return !(emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty)
            case .Signup:
                return !(emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty || usernameTextField.text!.isEmpty)
            case .Edit:
                return !(usernameTextField.text!.isEmpty)
                
            }
        }
    }
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViewBasedOnMode()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateViewBasedOnMode () {
        switch viewMode {
        case .Login:
            usernameTextField.hidden = true
            profileImage.hidden = true
            AddProfileButton.hidden = true
            actionButton.setTitle("Login", forState: .Normal)
        case .Signup:
            actionButton.setTitle("Signup", forState: .Normal)
        case .Edit:
            actionButton.setTitle("Edit", forState: .Normal)
            
            emailTextField.hidden = true
            passwordTextField.hidden = true
            
            if let user = self.user {
                usernameTextField.text = user.username
                
            }
        }
    }
    
    func updatWithUser(user:User) {
        self.user = user
        viewMode = .Edit
    }
    
    @IBAction func actionButtonTapped(sender: AnyObject) {
        if fieldsAreValid {
            switch viewMode {
            case .Login:
                UserController.authenticateUser(emailTextField.text!, password: passwordTextField.text!, completion: { (success, user) -> Void in
                    if success, let _ = user {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.presentValidationAlertWithTitle("Unable to Log In", message: "Please check your information and try again.")
                    }
                })
                
                
            case .Signup:
                UserController.createUser(emailTextField.text!, username: usernameTextField.text!, password: passwordTextField.text!, completion: { (success, user) -> Void in
                    if success, let _ = user {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.presentValidationAlertWithTitle("Unable to Signup", message: "Email address already taken.  Please try another one.")
                    }
                })
            case .Edit:
                UserController.updateUser(self.user!, username: self.usernameTextField.text!, completion: { (success, user) -> Void in
                    
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.presentValidationAlertWithTitle("Unable to Update User", message: "Please check your information and try again.")
                    }
                })
            }
            
        } else {
            presentValidationAlertWithTitle("Missing Information", message: "Please check your information and try again.")
        }
        
    }
    
    func presentValidationAlertWithTitle(title: String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
        
        self.clearAllTextfields()
    }
    
    
    // Profile Image
    
    
    @IBAction func AddProfileImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "select Photo Location", message: nil, preferredStyle: .ActionSheet)
        
        
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            alert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            alert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (_) -> Void in
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.image = image!
        
        profileImage.image = image
        
    }
    func clearAllTextfields() {
        emailTextField.text = ""
        usernameTextField.text = ""
        passwordTextField.text = ""
        profileImage.image = nil
    }
    
    
}
extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        //self.image = prepareImage(anyImage)
    }
}






