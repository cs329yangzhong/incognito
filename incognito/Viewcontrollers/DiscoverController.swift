//
//  DiscoverController.swift
//  incognito
//
//  Created by yang zhong on 3/30/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class DiscoverController: UITableViewController {
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        super.title = "Discover"
        
        // add refresher.
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(DiscoverController.populate),
                                  for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
    }
    var total_post = DataStore.shared.countPost()
    @objc func populate(){
        tableView.reloadData()
        refresher.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source.
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataStore.shared.countPost()
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 365.0;//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostDetailViewCell
        let post = DataStore.shared.getPost(index: indexPath.item)
        
        cell.location.text = post.location
        cell.textcontent.text = post.text
        
        // observe the current user once and store all the basic information.
        // load the poster's avatar.
        DataStore.shared.ShowAvatarName(uid: post.uid, Avatar: cell.Avatar, Name: cell.Username)
        print(post.image)
        // Download imgs and store them in cache.
    
        
        return cell
    }
    
    @IBAction func addCommentbtn(_ sender: Any) {
        
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showpost"){
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        
            let seg = segue.destination as! PostDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
            
                let post = DataStore.shared.getPost(index: indexPath.item)
                seg.CurrrentPost = post
            
                let PostImgs = DataStore.shared.loadphoto(Urllist: post.image)
                if (PostImgs != nil) {
                    seg.Imgs = PostImgs!
                }
            }
        }
    }


}
