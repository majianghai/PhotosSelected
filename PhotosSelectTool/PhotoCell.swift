//
//  PhotoCell.swift
//  多张相册
//
//  Created by 马江海 on 16/6/28.
//  Copyright © 2016年 马江海. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var selView: UIImageView!
    
    
    
    func changeStatus(_ status : Bool) {
        print("--------------")
        print(status)
        print("--------------")
        selView.isHidden = status
    }
    
    
    
}
