//
//  AddPostViewController.swift
//  incognito
//
//  Created by yang zhong on 3/10/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Firebase
class AddPostViewController: UIViewController,UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var textfield: UITextView!
    @IBAction func DidAddPost(_ sender: Any) {
        let id = Auth.auth().currentUser?.uid
        let post = Post(uid: id!,
                        text: textfield.text!,
                        image: "none",
                        location: "none",
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
