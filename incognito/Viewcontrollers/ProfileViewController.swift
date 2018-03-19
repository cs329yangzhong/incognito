//
//  ProfileViewController.swift
//  incognito
//
//  Created by yang zhong on 3/18/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

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
