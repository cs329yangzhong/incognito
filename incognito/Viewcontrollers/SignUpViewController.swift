//
//  SignUpViewController.swift
//  incognito
//
//  Created by yang zhong on 3/10/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    // Create variables.
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var CheckPasswordTextField:UITextField!
    
    @IBAction func ConfirmSignUp(_ sender: Any) {
        
        // Test password matching.
        if (PasswordTextField.text! != CheckPasswordTextField.text!){
            let alert = UIAlertController(title: "Alert",
                                          message: "You must enter the same passwords",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        Auth.auth().createUser(withEmail: EmailTextField.text!, password: PasswordTextField.text!)
                        { (user, error) in
                        print(Auth.auth().currentUser)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    
    
    // dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
