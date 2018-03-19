//
//  SignInViewController.swift
//  incognito
//
//  Created by yang zhong on 3/10/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!

    @IBAction func LoginAction(_ sender: Any) {
        print(Auth.auth().currentUser)
    
        
        // Checking empty fields.
        if (EmailTextField.text! == "" || PasswordTextField.text! == "||"){
        let alert = UIAlertController(title: "Alert",
                                      message: "Please enter both email and password.",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style:
                        UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        
        Auth.auth().signIn(withEmail: EmailTextField.text!, password:PasswordTextField.text!) { (user, error) in
            //check that user is not nil.
            if let u = user {
                self.performSegue(withIdentifier: "do_signin", sender: self)
            }
            else{
                let alert = UIAlertController(title: "Alert",
                                              message: "User does not exist or wrong password",
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

        // Check the Username and Password.
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }    
}
