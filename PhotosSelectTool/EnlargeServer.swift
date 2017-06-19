//
//  EnlargeServer.swift
//  多张相册
//
//  Created by 马江海 on 16/6/30.
//  Copyright © 2016年 马江海. All rights reserved.
//

import UIKit

class EnlargeServer: UIView {
    
    var imageViewArray : [UIImageView]?
    var enlargeGestureArray : [UITapGestureRecognizer]?
    var addGestureArray : [UITapGestureRecognizer]?
    
    
    var scrollView : UIScrollView?
    var toolBar : UIView?
    var deleteBtn : UIButton?
    
    
    func enlargeImageView(_ imageViewArray: [UIImageView]) {
        
        self.imageViewArray = imageViewArray
        
        let screenSize = UIScreen.main.bounds.size
        
        
        
        scrollView = UIScrollView(frame: CGRect(x: screenSize.width * 0.5, y: screenSize.height * 0.5, width: 0, height: 0))
        scrollView?.isPagingEnabled = true
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.backgroundColor = UIColor.black
        addSubview(scrollView!)
        
        var count = 0
        for index in 0 ..< imageViewArray.count {
            
            let plusImageView = imageViewArray[index]
            if (plusImageView.image?.isEqual(UIImage(named: "add")))! == true {break}
            
            let imageView = UIImageView(frame: CGRect(x: screenSize.width * CGFloat(index), y: 0, width: screenSize.width, height: screenSize.height))
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.image = imageViewArray[index].image
            scrollView?.addSubview(imageView)
            count = index + 1
        }
        
        scrollView?.contentSize = CGSize(width: CGFloat(count) * screenSize.width, height: 0)
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            weakSelf!.scrollView!.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height);
        })
        
        
        toolBar = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 64))
        toolBar?.backgroundColor = UIColor.clear
        self.addSubview(toolBar!)
        
        
        let cancleBtn = UIButton(type:.custom)
        cancleBtn.frame = CGRect(x: 4, y: 22, width: 40, height: 40)
        cancleBtn.addTarget(self, action: #selector(cancleBtnEvent), for: UIControlEvents.touchUpInside)
        cancleBtn.setImage(UIImage(named: "back_white"), for: UIControlState())
        toolBar?.addSubview(cancleBtn)
        
        
        deleteBtn = UIButton(type:.custom)
        deleteBtn!.frame = CGRect(x: screenSize.width - 60, y: 22, width: 40, height: 40);
        deleteBtn!.addTarget(self, action: #selector(deleteBtnEvent), for: UIControlEvents.touchUpInside)
        deleteBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        deleteBtn!.setTitle("删除", for: UIControlState())
        deleteBtn!.setTitleColor(UIColor.white, for: UIControlState())
        toolBar?.addSubview(deleteBtn!)
        
    }
    
    
    /// 点击了取消按钮
    func cancleBtnEvent() {
        
        let screenSize = UIScreen.main.bounds
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            
            weakSelf!.scrollView!.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height);
            
        }, completion: { (finished) in
            
            weakSelf!.removeFromSuperview()
            
        })
        
    }
    
    
    
    /// 点击了删除按钮
    func deleteBtnEvent() {
        
        
        let screenSize = UIScreen.main.bounds.size
        
        let page = (scrollView?.contentOffset.x)! / screenSize.width
        let bigImageView = scrollView?.subviews[Int(page)] as! UIImageView
        
        bigImageView.removeFromSuperview()
        
        // 设置scrollView的滚动位置
        var index = 0
        for imageView in (scrollView?.subviews)! {
            imageView.frame = CGRect(x: CGFloat(index) * screenSize.width, y: 0, width: screenSize.width, height: screenSize.height)
            index = index + 1
        }
        scrollView?.contentSize = CGSize(width: CGFloat((scrollView?.subviews.count)!) * screenSize.width, height: 0)
        
        
        // 给所有的imageView清空图片
        for imageView in imageViewArray! {
            imageView.image = nil
        }
        
        // 把scrollView剩下的图片赋值给smallImageView
        for bigImageView in (scrollView?.subviews)! as! [UIImageView] {
            
            let index = scrollView?.subviews.index(of: bigImageView)
            let smallImageView = imageViewArray![index!]
            smallImageView.image = bigImageView.image
            
            // 最后一张设置成添加按钮
            let lastImageView = imageViewArray![index! + 1]
            lastImageView.image = UIImage(named: "add")
        }
        
        
        
        if scrollView?.subviews.count == 0 {
            let firstImageView = imageViewArray?.first
            firstImageView?.image = UIImage(named: "photo")
            self.cancleBtnEvent()
        }
        
        setupGesture()
        
    }
    
    
    
    
    func setupGesture() {
        
        weak var weakSelf = self
        
        /// 设置手势
        for imageView in weakSelf!.imageViewArray! {
            
            imageView.gestureRecognizers?.removeAll()
            
            let index = weakSelf!.imageViewArray?.index(of: imageView)
            
            // 是相册图片，就设置成放大手势
            if imageView.image != nil && (imageView.image?.isEqual(UIImage(named: "add")))! == false {
                
                imageView.addGestureRecognizer(weakSelf!.enlargeGestureArray![index!])
            }
            
            // 是添加图片就设置成添加手势
            if imageView.image != nil && (imageView.image?.isEqual(UIImage(named: "add")))! == true {
                
                imageView.addGestureRecognizer(weakSelf!.addGestureArray![index!])
            }
            
            // 是照相机图片就设置成放大手势
            if imageView.image != nil && (imageView.image?.isEqual(UIImage(named: "photo")))! == true {
                
                imageView.addGestureRecognizer(weakSelf!.addGestureArray![index!])
            }
            
            
            
            if imageView.image == nil {
                imageView.isUserInteractionEnabled = false
            } else {
                imageView.isUserInteractionEnabled = true
            }
            
        }
    }
    
    
    
    deinit {
        print("EnlargeServer ------ 释放了吗")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
