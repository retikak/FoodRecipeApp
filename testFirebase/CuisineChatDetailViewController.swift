//
//  CuisineChatDetailViewController.swift
//  testFirebase
//
//  Created by Retika Kumar on 3/23/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import UIKit

class CuisineChatDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var message: Message?
    var group: Group?
    var image: UIImage?
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addImage: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.layer.cornerRadius = 10
        addImage.layer.cornerRadius = 10
        self.title = group?.groupname ?? ""
        if let message = message {
            messageTextView.text = message.text
            saveButton.hidden = true
            if let imageEndpoint = message.imageEndpoint {
                ImageController.imageForIdentifier(imageEndpoint, completion: { (image) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if let image = image {
                            self.imageView.image = image
                        }
                    })
                })
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        self.view.window?.endEditing(true)
        
        guard let group = group,
            let sender = UserController.sharedController.currentUser.identifier,
            let text = messageTextView.text
            
            else {
                return
        }
        
        MessageController.createMessage(sender, text: text, group: group, image: image, completion: { (success, message) -> Void in
            if message != nil {
                self.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popViewControllerAnimated(true)
                
            } else {
                let failedAlert = UIAlertController(title: "Failed", message: "please try again", preferredStyle: .Alert)
                failedAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(failedAlert, animated: true, completion: nil)
            }
            
        })
    }
    

    @IBAction func addPhotoButtonTapped(sender: AnyObject){
        
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
        self.image = image
        imageView.image = image
        addImage.setTitle("", forState: .Normal)
        addImage.setBackgroundImage(self.image, forState: .Normal)
    }
   
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}

