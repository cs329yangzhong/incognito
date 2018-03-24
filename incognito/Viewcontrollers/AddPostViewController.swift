//
//  AddPostViewController.swift
//  incognito
//
//  Created by yang zhong on 3/10/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

class AddPostViewController: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    // Declare the Imgpicker.
    var imagePicker: UIImagePickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // initialize Google map.
    
    // Do any additional setup after loading the view.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Adding img.
    var CurrentImg: UIImage?
    @IBAction func AddImg(_ sender: Any) {
        let alertController : UIAlertController = UIAlertController(
            title: "Select Camera or camera Library",
            message: nil, preferredStyle: .actionSheet)
        let cameraAction : UIAlertAction = UIAlertAction(title: "Camera", style: .default,handler:
            {(cameraAction) in
                print("camera Selected...")
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == true {
                    self.imagePicker.sourceType = .camera
                    self.present()
                }else{
                    self.present(self.showAlert(Title: "Error", Message: "Camera is not available on this Device or accesibility has been revoked!"), animated: true, completion: nil)
                }
        })
        
        let libraryAction : UIAlertAction = UIAlertAction(title: "Photo Library", style: .default, handler: {(libraryAction) in
            print("Photo library selected....")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) == true {
                self.imagePicker.sourceType = .photoLibrary
                self.present()
            }else{
                self.present(self.showAlert(Title: "Error", Message: "Photo Library is not available on this Device or accesibility has been revoked!"), animated: true, completion: nil)
            }
        })
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel , handler: {(cancelActn) in
            print("Cancel action was pressed")
        })
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = view.frame
        self.present(alertController, animated: true, completion: nil)
    }
    
    func present(){
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage ,didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("info of the pic reached :\(info) ")
        CurrentImg = image
        self.imagePicker.dismiss(animated: true, completion: nil)
        var data = NSData()
        data = UIImageJPEGRepresentation(CurrentImg!, 0.8)! as NSData
        
    }
    
    //Show Alert
    func showAlert(Title : String!, Message : String!)  -> UIAlertController {
        
        let alertController : UIAlertController = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let okAction : UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            print("User pressed ok function")
        }
        alertController.addAction(okAction)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = view.frame
        return alertController
    }
    
    @IBOutlet weak var textfield: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBAction func decide_location(_ sender: UIButton) {
        
    }
    
    @IBAction func DidAddPost(_ sender: Any) {
        let id = Auth.auth().currentUser?.uid
        let post = Post(uid: id!,
                        text: textfield.text!,
                        image: "none",
                        location: nameLabel.text!,
                        time: "none",
                        like: ["none"],
                        comments: ["none"])
        DataStore.shared.addPost(post: post)
        print("Successfully saved post")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // dismiss keyboard
    
}
