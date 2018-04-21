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
    let currentUserId = Auth.auth().currentUser?.uid
    
    // Initializing the like button's status.
    if post.like.contains(currentUserId!) {
        
        // The user has liked the post.
        cell.LikeButton.setImage(UIImage.init(named: "like"),
                                  for: .normal)
        cell.LikeButton.isSelected = true
    } else {
        cell.LikeButton.setImage(UIImage.init(named: "like_icon"),for: .normal)
        cell.LikeButton.isSelected = false
    }
    cell.postid = post.id
    cell.postperson = currentUserId
    cell.location.text = post.location
    cell.textcontent.text = post.text
    cell.post1 = post
//    cell.downloadImges()
    if post.image.count >= 2 {
        let url = URL(string: (post.image)[1])
        cell.AnimateImg.kf.setImage(with: url)
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    dateFormatter.timeZone = TimeZone.current
    let lastUpdate = dateFormatter.date(from: post.time)
    //    let lastUpate = post.time as? Date
    if lastUpdate != nil{
        cell.postTime.text = timeAgoSinceDate(lastUpdate!)
        //        print(timeAgoSinceDate(lastUpdate!))
    }
    else{
        cell.postTime.text = post.time
    }
    
    // observe the current user once and store all the basic information.
    // load the poster's avatar.
    DataStore.shared.ShowAvatarName(uid: post.uid, Avatar: cell.Avatar, Name: cell.Username)
    print(post.image)
    
    return cell
}
func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
    let calendar = Calendar.current
    let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
    let now = Date()
    let earliest = now < date ? now : date
    let latest = (earliest == now) ? date : now
    let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
    
    if (components.year! >= 2) {
        return "\(components.year!) years ago"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hours ago"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hour ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) minutes ago"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 minute ago"
        } else {
            return "A minute ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!) seconds ago"
    } else {
        return "Just now"
    }
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
            }
        }
    }
}



