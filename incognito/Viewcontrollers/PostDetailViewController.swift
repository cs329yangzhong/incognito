//
//  PostDetailViewController.swift
//  incognito
//
//  Created by yang zhong on 4/6/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController, UIScrollViewDelegate {
    
    // Initialize a post obeject.
    var CurrrentPost: Post?
    
    @IBOutlet weak var textContent: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var contentWidth:CGFloat = CGFloat(bitPattern: 12)
    var refresher: UIRefreshControl!
    var Imgs = [UIImage]()
    // View didload function.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollview.delegate = self
        textContent.text = CurrrentPost?.text
        scrollview.isHidden = false
        
        for Image in Imgs {
            let imageView = UIImageView(image: Image)
            scrollview.addSubview(imageView)
            contentWidth += view.frame.width
        }
        scrollview.contentSize = CGSize(width: contentWidth, height: view.frame.height)

        // Do any additional setup after loading the view.
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(414))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

}
