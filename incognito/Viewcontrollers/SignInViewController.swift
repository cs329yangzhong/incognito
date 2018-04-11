//
//  SignInViewController.swift
//  incognito
//
//  Created by yang zhong on 3/10/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBAction func LoginAction(_ sender: Any) {

        // Checking empty fields.
        if (EmailTextField.text! == "" || PasswordTextField.text! == ""){
        let alert = UIAlertController(title: "Alert",
                                      message: "Invalid Email adress or wrong password",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style:
                        UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        
        Auth.auth().signIn(withEmail: EmailTextField.text!,
                           password:PasswordTextField.text!){ (user, error) in
            
            //check that user is not nil.
            if let error = error {
                print(error.localizedDescription)
                print()
                let alert = UIAlertController(title: "Alert",
                                              message: "User does not exist or wrong password",
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                                UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            else if let user = user {
                print("Successly Logged in")
                self.performSegue(withIdentifier: "do_signin", sender: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.EmailTextField.delegate = self;
        self.PasswordTextField.delegate = self;
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
