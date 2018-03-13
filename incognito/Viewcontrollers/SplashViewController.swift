//
//  SplashViewController.swift
//  incognito
//
//  Created by yang zhong on 3/12/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Intialize the Datastore.
        DataStore.shared.loadUser()
        DataStore.shared.loadPost()
        DataStore.shared.loadComment()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
