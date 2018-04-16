//
//  SignUpViewController.swift
//  incognito
//
//  Created by yang zhong on 3/10/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController,UITextFieldDelegate {

// Create variables.
@IBOutlet weak var UsernameTextField: UITextField!
@IBOutlet weak var EmailTextField: UITextField!
@IBOutlet weak var PasswordTextField: UITextField!
@IBOutlet weak var CheckPasswordTextField:UITextField!

@IBAction func ConfirmSignUp(_ sender: Any) {
    
    // Test password matching.
    if (PasswordTextField.text! != CheckPasswordTextField.text!
        || (PasswordTextField.text?.count)! < 8){
        let alert = UIAlertController(title: "Alert",
                                      message: "You must enter the same passwords with at least 8 digits",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style:
            UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }else{
    Auth.auth().createUser(withEmail: EmailTextField.text!, password: PasswordTextField.text!)
                    { (user, error) in
                    print(Auth.auth().currentUser!)
                    let User1 = User(username: self.UsernameTextField.text!,
                                     password: self.PasswordTextField.text!,
                                     email: self.EmailTextField.text!,
                                     class_year: "Fresh",
                                     posts: ["None"],
                                     gender: "male",
                                     avatar: "None")
                    DataStore.shared.addUser(id: (user?.uid)!,user: User1)
    if Auth.auth().currentUser == nil {
        self.performSegue(withIdentifier: "Signup_to_Signin", sender: self)
    }
    print("save")
    }
}
}

override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.UsernameTextField.delegate = self;
    self.PasswordTextField.delegate = self;
    self.CheckPasswordTextField.delegate = self;
    self.EmailTextField.delegate = self;
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




// dismiss keyboard
// when click the return, the keyboard will hide automatically.
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
}

// if the user touched anywhere outside of the keyboard, the keyboard will hide.
override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
}
}
