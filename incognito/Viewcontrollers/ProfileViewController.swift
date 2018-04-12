//
//  ProfileViewController.swift
//  incognito
//
//  Created by yang zhong on 3/18/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController,     UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UINavigationControllerDelegate {
    
    let userID = Auth.auth().currentUser!.uid
    
    //Joy- for gender picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    let storageref = DataStore.storage.reference()
    
    //Joy
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var classField: UITextField!
    var genderPicker = UIPickerView()
    var classPicker = UIPickerView()
    //Joy
    
    // ViewDidload function.
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        CurrentImg.isUserInteractionEnabled = true
        ShowProfile()
        
        //Joy

        genderPicker.delegate = self
        genderPicker.tag = 1
        genderField.inputView = genderPicker
        
        
        classPicker.delegate = self
        classPicker.tag = 2
        classField.inputView = classPicker
        //Joy
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Fetch User avator from firebase.
    func ShowProfile() {
    let usersRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
    
    // observe the current user once and store all the basic information.
    usersRef.observeSingleEvent(of: .value, with: {
        snapshot in
    if !snapshot.exists() { return}
    let userInfo = snapshot.value as! NSDictionary
    let profileUrl = userInfo["avatar"] as! String
        
    // If the user has not setup avatar, use the default avatar.
    if (profileUrl == "None"){
        self.CurrentImg.image = UIImage(named: "icon2")
    }else{
        let storageRef = Storage.storage().reference(forURL: profileUrl)
        storageRef.downloadURL(completion: { (url, error) in
        if let error = error{
            print(error.localizedDescription)
            return
        }else{
            let data = NSData(contentsOf: url!)
            let image = UIImage(data: data! as Data)
            self.CurrentImg.image = image
            }
        })
        }
    })
    }

    // ############################ Modify User avatar.###################################
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
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .camera
                self.present()
            }else{
                self.present(self.showAlert(Title: "Error", Message: "Camera is not available on this Device or accesibility has been revoked!"), animated: true, completion: nil)
            }
        })
        
        let libraryAction : UIAlertAction = UIAlertAction(title: "Photo Library", style: .default, handler: {(libraryAction) in
            print("Photo library selected....")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) == true {
                self.imagePicker.delegate = self
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
    
    @objc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("info of the pic reached :\(info) ")
        if let choosenImg = info[UIImagePickerControllerOriginalImage]as? UIImage{
            CurrentImg.image = choosenImg
            print("Update Avatar")
        }
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
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["avatar": downloadURL])
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
    // ######################### function for Avatar change. ###############################################
    
    
    // TODO : create labels for grade, username, gender features.
    
    //Joy
    let genders = ["Male", "Female", "N/A"]
    let grades = ["N/A","Freshman", "Sophomore","Junior","Senior", "Graduate", "PHD"]
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == genderPicker) {
            return genders.count
        } else {
            return grades.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == genderPicker) {
            return genders[row]
        } else {
            return grades[row]
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == genderPicker) {
            genderField.text = genders[row]
            self.view.endEditing(true)
        } else {
            classField.text = grades[row]
            self.view.endEditing(true)
        }
    }
    
    
    
    @IBAction func updateGenderClass(_ sender: Any) {
        DataStore.shared.updateGenderClass(gender: genderField.text!, classYear: classField.text!)
    }
    //Joy
     
    // ############ Sign out function.##########################################
    @IBAction func Logout(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            print(Auth.auth().currentUser!)
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
    
    
    

}
