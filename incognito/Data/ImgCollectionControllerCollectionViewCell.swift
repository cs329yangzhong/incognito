//
//  ImgCollectionControllerCollectionViewCell.swift
//  incognito
//
//  Created by yang zhong on 3/24/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit

class ImgCollectionControllerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImgView: UIImageView!
    func displayContent(img: UIImage){
      ImgView.image = img
    }
}
