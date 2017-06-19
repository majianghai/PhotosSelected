//
//  PhotoViewController.swift
//  多相册选择
//
//  Created by 马江海 on 16/6/20.
//  Copyright © 2016年 马江海. All rights reserved.
//

import UIKit
import AssetsLibrary

class PhotoViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout , UICollectionViewDataSource , UIGestureRecognizerDelegate{

    
    var dataArray : [ALAsset]!
    var imgViews : [UIImageView]? // 传进来的5个imageView
    var enlargeGestureArray : [UITapGestureRecognizer]?

    
    
    var numLabel : UILabel?
    var statusArray = [Bool]()
    var selImgViewsArray = [ALAsset]()
    var addGestureArray : [UITapGestureRecognizer]?
    var needPicImageViewArray = [UIImageView]() // 记录需要设置图片的imageView


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "相机胶卷"
        
        
        // 导航条取消按钮
        let cancleBtn = UIButton(type: .custom)
        cancleBtn.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        cancleBtn.setTitle("取消", for: UIControlState())
        cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        cancleBtn.setTitleColor(UIColor.black, for: UIControlState())
        cancleBtn.addTarget(self, action: #selector(PhotoViewController.canclebtnEvent), for: UIControlEvents.touchUpInside)
        let cancleItem = UIBarButtonItem(customView:cancleBtn)
        navigationItem.rightBarButtonItem = cancleItem;
        
        
        let screenSize = UIScreen.main.bounds.size
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - 44), collectionViewLayout:layout)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        
        
        collectionView.register(UINib.init(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        
        
        let bottomView = UIView(frame : CGRect(x: 0, y: screenSize.height - 44, width: screenSize.width, height: 44))
        bottomView.backgroundColor = UIColor.white
        view.addSubview(bottomView)
        
        let finishBtn = UIButton(type: .custom)
        finishBtn.frame = CGRect(x: screenSize.width - 15 - 30, y: 0, width: 30, height: 44)
        finishBtn.setTitle("完成", for: UIControlState())
        finishBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        finishBtn.setTitleColor(UIColor.black, for: UIControlState())
        finishBtn.addTarget(self, action: #selector(PhotoViewController.finishBtnEvent), for: UIControlEvents.touchUpInside)
        bottomView.addSubview(finishBtn)
        
        numLabel = UILabel(frame: CGRect(x: finishBtn.frame.minX - 24 - 10, y: 10, width: 24, height: 24))
        numLabel?.textAlignment = NSTextAlignment.center
        numLabel?.backgroundColor = UIColor.red
        numLabel?.text = "0"
        numLabel?.textColor = UIColor.white
        numLabel?.layer.cornerRadius = 12
        numLabel?.clipsToBounds = true
        bottomView.addSubview(numLabel!)
        
        
        for _ in 0 ..< dataArray.count {
            statusArray.append(true)
        }
        
        
        /// 手势数组
        needPicImageViewArray.removeAll()
        for imageView in imgViews! {
            
            if imageView.image == nil || (imageView.image?.isEqual(UIImage(named: "add")))! == true || (imageView.image?.isEqual(UIImage(named: "photo")))! == true {
                needPicImageViewArray.append(imageView)
            }
            
        }
        
        
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let result = dataArray[(indexPath as NSIndexPath).row]
        let status = statusArray[(indexPath as NSIndexPath).row]

        let image = UIImage(cgImage: result.thumbnail().takeUnretainedValue())
        
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        photoCell.imgView.image = image
        photoCell.changeStatus(status)
        return photoCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenW = UIScreen.main.bounds.size.width
        return CGSize(width: (screenW-20)/3, height: (screenW-20)/3)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let result = dataArray[(indexPath as NSIndexPath).row]
        
        if selImgViewsArray.count == needPicImageViewArray.count && statusArray[(indexPath as NSIndexPath).row] == true {
            UJPProgressHUD.share().showMessage("最多只能选" +  String(needPicImageViewArray.count) + "张")
            return
        }
        
        if statusArray[(indexPath as NSIndexPath).row] == true {
            selImgViewsArray.append(result)
            statusArray[(indexPath as NSIndexPath).row] = false
        } else {
            selImgViewsArray.remove(at: selImgViewsArray.index(of: result)!)
            statusArray[(indexPath as NSIndexPath).row] = true
        }
        
        numLabel?.text = String(selImgViewsArray.count)
        collectionView.reloadData()
        
    }
    
    
    
    /// 点击完成按钮
    func finishBtnEvent() {
        
        if selImgViewsArray.count == 0 { // 如果用户没有选择图片，那么直接返回
            dataArray.removeAll()
            navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        
        
        for index in 0 ..< selImgViewsArray.count {
            
            let result = selImgViewsArray[index]
            let image = UIImage(cgImage: result.defaultRepresentation().fullScreenImage().takeUnretainedValue())
            let imageView = needPicImageViewArray[index]
            imageView.image = image
            
            if selImgViewsArray.count < needPicImageViewArray.count {
                let imageView = needPicImageViewArray[selImgViewsArray.count]
                imageView.image = UIImage(named: "add")
            }
            
        }
        
        
        /// 给所有的view设置手势
        for imageView in imgViews! {
            
            // 有图，并且不是加号按钮
            if imageView.image != nil && (imageView.image?.isEqual(UIImage(named: "add")))! == false {
                
                // 替换放大图片的手势
                let index = imgViews?.index(of: imageView)
                let enlargeGesture = enlargeGestureArray![index!]
                imageView.addGestureRecognizer(enlargeGesture)
            }
            
            if imageView.image != nil && (imageView.image?.isEqual(UIImage(named: "add")))! == true {
                let index = imgViews?.index(of: imageView)
                imageView.addGestureRecognizer(addGestureArray![index!])

            }
            

            
            // 当有图的时候就可以点击，没图的时候就不能点击
            if imageView.image == nil {
                imageView.isUserInteractionEnabled = false
            } else {
                imageView.isUserInteractionEnabled = true
            }
            
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    

    
    
    func canclebtnEvent() {
        
        // 当有图的时候就可以点击，没图的时候就不能点击
        for imageView in imgViews! {
            
            if imageView.image == nil {
                imageView.isUserInteractionEnabled = false
            } else {
                imageView.isUserInteractionEnabled = true
            }
            
        }
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    deinit {
        print("------")
    }
}
