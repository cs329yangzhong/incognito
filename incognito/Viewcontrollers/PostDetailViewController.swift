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
var CurrrentPost: Post?

@IBOutlet weak var textContent: UILabel!
@IBOutlet weak var scrollview: UIScrollView!
@IBOutlet weak var pageControl: UIPageControl!

var contentWidth:CGFloat = 0.0
var refresher: UIRefreshControl!

// View didload function.
override func viewDidLoad() {
    super.viewDidLoad()
    CommentsTable.delegate = self
    CommentsTable.dataSource = self
    CommentField.delegate = self
    
    // Create a scrollview that could display all image.
    configurePageControl()
    scrollview.delegate = self
    scrollview.isPagingEnabled = false
    textContent.text = CurrrentPost?.text
    scrollview.frame = CGRect(x: 0, y:144, width: view.frame.width, height: 198)
    pageControl.addTarget(self, action: #selector(self.scrollViewDidScroll(_:)), for: UIControlEvents.valueChanged)
    
    if ((CurrrentPost?.image)!.count == 1){
        scrollview.isHidden = true
    }else{
        
        // Show the pictures in a scrollview.
        for i in 0...(CurrrentPost?.image)!.count-1 {
            if ((CurrrentPost?.image)![i] == "none" ) {continue}
            var IMGVIEW = UIImageView()
            IMGVIEW.contentMode = .scaleAspectFill
            let url = URL(string: (CurrrentPost?.image)![i])
            
            // Using KingsFisher library that can download the images and create local cache.
            IMGVIEW.kf.setImage(with: url)
            
            let xPosition = self.scrollview.frame.width * CGFloat(i-1)
            IMGVIEW.frame = CGRect(x: xPosition, y: (scrollview.frame.minY/2)-scrollview.frame.height/2, width: scrollview.frame.width, height: scrollview.frame.height)
            scrollview.contentSize.width += view.frame.width
            scrollview.addSubview(IMGVIEW)
        }
    }
}

// Configuring the page Control.
func configurePageControl() {
    self.pageControl.numberOfPages = (CurrrentPost?.image)!.count-1
    self.pageControl.currentPage = 0
}

func scrollViewDidScroll(_ scrollView: UIScrollView) {
    print(scrollView.contentOffset.x)
    pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(337))
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}

// **************** Display Comments *****************
@IBOutlet weak var CommentsTable: UITableView!
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return CurrrentPost!.comments.count - 1
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "comment", for: indexPath) as! CommentsCell
    print(CurrrentPost!.comments)
    
    DataStore.shared.GetComment(Avatar: cell.UserAvatar, Postid: (CurrrentPost!.id), index: indexPath.item, CurrentPost: CurrrentPost!, Content: cell.CommentContent, time: cell.CommentTime)
    
    return cell
}


//************************ Add comments. ********************************
@IBOutlet weak var CommentField: UITextField!

@IBAction func AddComment(_ sender: Any) {
    let PostId = CurrrentPost?.id
    let comment_maker = Auth.auth().currentUser?.uid
    let comment_content = CommentField.text
    let comment_time = "None"
    
    let newcomment = Comment(id: "random",
                             post_id:  PostId!,
                             text: comment_content!,
                             comment_by: comment_maker!,
                             time: comment_time)
    
    DataStore.shared.addComment(comment: newcomment)
    print("finish adding Comment")
}

//********* Todo: write the the get current time function. ***************



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
