//
//  PostDetailViewController.swift
//  incognito
//
//  Created by yang zhong on 4/6/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Kingfisher

class PostDetailViewController: UIViewController, UIScrollViewDelegate {
    
    // Initialize a post obeject.
    var CurrrentPost: Post?
    
    @IBOutlet weak var textContent: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var contentWidth:CGFloat = 0.0
    var refresher: UIRefreshControl!
    var Imgs = [UIImage]()
    
    // View didload function.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollview.delegate = self
        textContent.text = CurrrentPost?.text
        scrollview.frame = CGRect(x: 17, y:144, width: 340, height: 198)
        
        if ((CurrrentPost?.image)!.count == 1){
            scrollview.isHidden = true
        }
        else{
            for i in 0...(CurrrentPost?.image)!.count-1 {
                
                if ((CurrrentPost?.image)![i] == "none" ) {continue}
                var IMGVIEW = UIImageView()
                IMGVIEW.contentMode = .scaleAspectFit
                let url = URL(string: (CurrrentPost?.image)![i])
                IMGVIEW.kf.setImage(with: url)
                print("got")
            
                let xPosition = self.view.frame.width * CGFloat(i-1)
                IMGVIEW.frame = CGRect(x: xPosition, y: (scrollview.frame.minY/2)-scrollview.frame.height/2, width: scrollview.frame.width, height: scrollview.frame.height)
                scrollview.contentSize.width = scrollview.frame.width * CGFloat(i)
                scrollview.addSubview(IMGVIEW)
                
            }
        }
        
        

        // Do any additional setup after loading the view.
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset)
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(view.frame.width))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    

}
