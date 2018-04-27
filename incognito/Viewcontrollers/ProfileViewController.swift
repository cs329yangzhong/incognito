//
//  ProfileViewController.swift
//  incognito
//
//  Created by yang zhong on 3/18/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController,     UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UINavigationControllerDelegate,UITextFieldDelegate {

let userID = Auth.auth().currentUser!.uid

//Joy- for gender picker
func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}

let storageref = DataStore.storage.reference()
var OldiconClick: Bool!
var NewiconClick: Bool!

//Joy
@IBOutlet weak var genderField: UITextField!
@IBOutlet weak var classField: UITextField!
@IBOutlet weak var emailField: UILabel!
@IBOutlet weak var nameField: UITextField!
@IBOutlet weak var oldPwdField: UITextField!
@IBOutlet weak var newPwdField: UITextField!
var UserPassword: String?

var genderPicker = UIPickerView()
var classPicker = UIPickerView()
//Joy

// ViewDidload function.
override func viewDidLoad() {
    super.viewDidLoad()
    OldiconClick = true
    NewiconClick = true
    
    // make keboard dismiss
    oldPwdField.delegate = self
    newPwdField.delegate = self
    
    // set up label's corner.
    self.emailField.layer.masksToBounds = true
    self.emailField.layer.cornerRadius = 5
    
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

// display user name in text field
let userName = userInfo["username"] as! String
self.nameField.text = userName

// display user gender in text field
let userGender = userInfo["gender"] as! String
self.genderField.text = userGender

// display user email in text field
let userEmail = userInfo["email"] as! String
self.emailField.text = userEmail

// display user class in text field
let userClass = userInfo["class_year"] as! String
self.classField.text = userClass
    
// get user's password.
let currentPwd = userInfo["password"] as! String
self.UserPassword = currentPwd

    
// If the user has not setup avatar, use the default avatar.
if (profileUrl == "None"){
    self.CurrentImg.image = UIImage(named: "icon2")
}else{
    
    // Use KF to downlaod user avatar.
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



@IBAction func updateGenderClassName(_ sender: Any) {
    DataStore.shared.updateGenderClassName(gender: genderField.text!,
                                           classYear: classField.text!,
                                           userName: nameField.text!)
}

@IBAction func updatePwd(_ sender: Any) {
    
    // Check whether the old Password is correct.
    let user = Auth.auth().currentUser
    
    // If correct.
    if (oldPwdField.text! == UserPassword!
        && (newPwdField.text)!.count >= 8 ) {
    Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).updateChildValues(["password": newPwdField.text!])
        user?.updatePassword(to: newPwdField.text!, completion: { (error) in
            print(error?.localizedDescription)
        })
        
        
        // Confirmation for changing password.
        let alert = UIAlertController(title: "Alert",
                                      message: " You have successfully changed your password! ",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Got it", style:
            UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // If False, Alert the user to retry.
    let alert = UIAlertController(title: "Alert",
                                  message: "Incorrect old password, You also need to enter a new password at least 8 characters ",
                                  preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(UIAlertAction(title: "OK", style:
        UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    
}

@IBAction func ShowOldPwd(_ sender: Any) {
    if(OldiconClick == true) {
    oldPwdField.isSecureTextEntry = false
    OldiconClick = false
} else {
    oldPwdField.isSecureTextEntry = true
    OldiconClick = true
    }
}

@IBAction func ShowNewPwd(_ sender: Any) {
    if(NewiconClick == true) {
    newPwdField.isSecureTextEntry = false
    NewiconClick = false
} else {
    newPwdField.isSecureTextEntry = true
    NewiconClick = true
    }
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

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
}

// if the user touched anywhere outside of the keyboard, the keyboard will hide.
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
}
