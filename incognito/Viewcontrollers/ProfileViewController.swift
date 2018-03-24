//
//  ProfileViewController.swift
//  incognito
//
//  Created by yang zhong on 3/18/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    let storageref = DataStore.storage.reference()
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    
    @IBOutlet weak var CurrentImg: UIImageView!
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
    
    @objc internal func imagePickerController(_picker: UIImagePickerController, didFinishPickingImage image: UIImage ,editingInfo info: [String : AnyObject]?) {
        print("info of the pic reached :\(info) ")
        CurrentImg.image = image
        print("1")
        self.imagePicker.dismiss(animated: true, completion: nil)
        var data = NSData()
        data = UIImageJPEGRepresentation(CurrentImg.image!, 0.8)! as NSData
        let filePath = "\(Auth.auth().currentUser!.uid)/\("avatar")"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        self.storageref.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                //store downloadURL at database
                Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
            }
        }
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
    
    
    
    // Log out function.
    @IBAction func Logout(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            print(Auth.auth().currentUser)
           // there is user signed in.
            do {
                try? Auth.auth().signOut()
            }catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            if Auth.auth().currentUser == nil {
                let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Signin") as! SignInViewController
                self.present(loginVC, animated: true, completion: nil)
            }
            
        }
    }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
