//
//  PostDetailViewController.swift
//  incognito
//
//  Created by yang zhong on 4/6/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class PostDetailViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

// Initialize a post obeject.
var CurrentPostIndex: Int?


@IBOutlet weak var textContent: UILabel!
@IBOutlet weak var scrollview: UIScrollView!
@IBOutlet weak var pageControl: UIPageControl!

var contentWidth:CGFloat = 0.0
var refresher: UIRefreshControl!
var CurrentPost: Post?
    
    
// View didload function.
override func viewDidLoad() {

    CurrentPost = DataStore.shared.getPost(index: CurrentPostIndex!)
    super.viewDidLoad()
    CommentsTable.delegate = self
    CommentsTable.dataSource = self
    CommentField.delegate = self
    
    // add refresher.
    refresher = UIRefreshControl()
    refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refresher.addTarget(self, action: #selector(PostDetailViewController.populate),
                        for: UIControlEvents.valueChanged)
    CommentsTable.addSubview(refresher)
    
    // Create a scrollview that could display all image.
    configurePageControl()
    scrollview.delegate = self
    scrollview.isPagingEnabled = false
    textContent.text = CurrentPost?.text
    scrollview.frame = CGRect(x: 0, y:144, width: view.frame.width, height: 198)
    pageControl.addTarget(self, action: #selector(self.scrollViewDidScroll(_:)), for: UIControlEvents.valueChanged)
    pageControl.addTarget(self, action: #selector (self.changePage(sender:)), for: .touchUpInside)
    
    if ((CurrentPost?.image)!.count == 1){
        scrollview.isHidden = true
    }else{
        
        // Show the pictures in a scrollview.
        for i in 0...(CurrentPost?.image)!.count-1 {
            if ((CurrentPost?.image)![i] == "none" ) {continue}
            let IMGVIEW = UIImageView()
            IMGVIEW.contentMode = .scaleAspectFill
            let url = URL(string: (CurrentPost?.image)![i])
            
            // Using KingsFisher library that can download the images and create local cache.
            IMGVIEW.kf.setImage(with: url)
            
            let xPosition = self.scrollview.frame.width * CGFloat(i-1)
            IMGVIEW.frame = CGRect(x: xPosition, y: (scrollview.frame.minY/2)-scrollview.frame.height/2, width: scrollview.frame.width, height: scrollview.frame.height)
            scrollview.contentSize.width += view.frame.width
            scrollview.addSubview(IMGVIEW)
        }
    }
}
    
@objc func populate(){
    CommentsTable.reloadData()
    refresher.endRefreshing()
}

// Configuring the page Control.
func configurePageControl() {
    self.pageControl.numberOfPages = (CurrentPost?.image)!.count-1
    self.pageControl.currentPage = 0
}
    
// Change page by clicking page point.
    @objc func changePage(sender: UIPageControl) -> Void {
    let x = CGFloat(self.pageControl.currentPage) * self.scrollview.frame.size.width
    self.scrollview.setContentOffset(CGPoint(x:x, y:0), animated: true)
}

func scrollViewDidScroll(_ scrollView: UIScrollView) {
    pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(self.view.frame.width))
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

// **************** Display Comments *****************
@IBOutlet weak var CommentsTable: UITableView!
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return CurrentPost!.comments.count - 1
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentsCell
    print(CurrentPost!.comments)
    
    DataStore.shared.GetComment(Avatar: cell.UserAvatar, Postid: (CurrentPost!.id), index: indexPath.item, CurrentPost: CurrentPost!, Content: cell.CommentContent, time: cell.CommentTime)
    
    return cell
}


//************************ Add comments. ********************************
@IBOutlet weak var CommentField: UITextField!

func addComment(alert: UIAlertAction!){
    let date = Date()
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    let dateString = formatter.string(from: date)
    
    let PostId = CurrentPost?.id
    let comment_maker = Auth.auth().currentUser?.uid
    let comment_content = CommentField.text
    let comment_time = dateString
    if (comment_content != ""){
        let newcomment = Comment(id: "random",
                                 post_id:  PostId!,
                                 text: comment_content!,
                                 comment_by: comment_maker!,
                                 time: comment_time)
        
        DataStore.shared.addComment(comment: newcomment)
        print("finish adding Comment")
    CommentField.text = ""
    } else {
        let alert = UIAlertController(title: "Alert",
                                      message: "You did not comment any words",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style:
            UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    }

@IBAction func AddComment(_ sender: Any) {
    let alert = UIAlertController(title: "Alert",
                                  message: "Are you sure to send comment? ",
                                  preferredStyle: UIAlertControllerStyle.alert)
    
    alert.addAction(UIAlertAction(title: "Yes", style:
        UIAlertActionStyle.default, handler: addComment))
    
    alert.addAction(UIAlertAction(title: "Cancel", style:
        UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
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

    
// Try to hide keyboard.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == CommentField {
            animateViewMoving(up: true, moveValue: 216)
            print("GOOD")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == CommentField {
            animateViewMoving(up: false, moveValue: 216)
            print("bad")
        }
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration: TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        self.view.frame = self.view.frame.offsetBy(dx:0, dy:movement)
        UIView.commitAnimations()
    }
}

extension String
{
    func toDateTime() -> NSDate
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        //Parse into NSDate
        let dateFromString : NSDate = dateFormatter.date(from: self)! as NSDate
        
        //Return Parsed Date
        return dateFromString
    }
}

//Move the keyboard while adding comments.


