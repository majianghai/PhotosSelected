//
//  ViewController.swift
//  多相册选择
//
//  Created by 马江海 on 16/6/20.
//  Copyright © 2016年 马江海. All rights reserved.
//

import UIKit
import AssetsLibrary


class PhotosServer: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UIGestureRecognizerDelegate{

    
    typealias CallBackBlock = (UIViewController) -> ()
    var callBackBlock : CallBackBlock?
    

    var resultArray = [ALAsset]()
    var library : ALAssetsLibrary?
    var enlargeGestureArray = [UITapGestureRecognizer]()
    var addGestureArray = [UITapGestureRecognizer]()
    var imgViews : [UIImageView]?


    /// 照相机
    func takePhotosWithImageViews(_ imgViews: [UIImageView], addGestureArray: [UITapGestureRecognizer], callBackBlock : @escaping CallBackBlock) {
        
        self.imgViews = imgViews

        self.callBackBlock = callBackBlock
        self.addGestureArray = addGestureArray
        
        enlargeGestureArray.removeAll()
        for _ in imgViews {
            
            let aSelector : Selector = #selector(enlargeImage)
            let enlargeGesture = UITapGestureRecognizer(target: self, action: aSelector)
            enlargeGesture.delegate = self
            enlargeGesture.numberOfTapsRequired = 1
            enlargeGestureArray.append(enlargeGesture)
        }


        var picker = UIImagePickerController()
        
        let sourceType = UIImagePickerControllerSourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            callBackBlock(picker)
            
        } else {
            NSLog("该设备无摄像头");
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        // 重新设置图片
        var imageArray = [UIImage]()
        
        for imageView in self.imgViews! {
            
            if imageView.image != nil && (imageView.image?.isEqual(UIImage(named: "添加按钮")))! == false && (imageView.image?.isEqual(UIImage(named: "照相机按钮")))! == false {
                imageArray.append(imageView.image!)
            }
            imageView.image = nil
        }
        imageArray.append(image)
        
        
        for index in 0 ..< imageArray.count {
            
            let imageView = self.imgViews![index]
            let image = imageArray[index]
            imageView.image = image
            
        }
        
        for imageView in self.imgViews! {
            
            if imageView.image == nil {
                imageView.image = UIImage(named: "添加按钮")
                break;
            }
        }
        
        setupGesture()
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    /// 相册选择
    func pickPhotosWithImageViews(_ imgViews: [UIImageView], addGestureArray: [UITapGestureRecognizer], callBackBlock : @escaping CallBackBlock) {
        
        self.callBackBlock = callBackBlock
        self.addGestureArray = addGestureArray

        
        let photoVc = PhotoViewController()
        photoVc.imgViews = imgViews
        self.imgViews = imgViews
        
        
        enlargeGestureArray.removeAll()
        for _ in imgViews {
            
            let aSelector : Selector = #selector(enlargeImage)
            let enlargeGesture = UITapGestureRecognizer(target: self, action: aSelector)
            enlargeGesture.delegate = self
            enlargeGesture.numberOfTapsRequired = 1
            enlargeGestureArray.append(enlargeGesture)
        }
        photoVc.addGestureArray = addGestureArray
        photoVc.enlargeGestureArray = enlargeGestureArray

        
        
        weak var weakSelf = self;
        library = ALAssetsLibrary()
        
        library!.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group, stop) in
            
            if group != nil {
                
                let assetBlock: ALAssetsGroupEnumerationResultsBlock = { (result, index, stop) in
                    if result != nil
                    {
                        weakSelf!.resultArray.append(result!)
                        print(result)
                        
                        if group?.numberOfAssets() == weakSelf!.resultArray.count {
                            photoVc.dataArray = weakSelf!.resultArray.reversed()
                            let nav = UINavigationController(rootViewController:photoVc)
                            callBackBlock(nav)
                        }
                    }
                }
                group!.enumerateAssets(assetBlock)
            }
            
            
            }) { (error) in
                print(error)
        }
    }
 
    
    
    /// 放大图片的手势
    func enlargeImage() {
        
        let keyWindow = UIApplication.shared.keyWindow
        
        let enlargeServer = EnlargeServer()
        enlargeServer.frame = (keyWindow?.bounds)!
        keyWindow?.addSubview(enlargeServer)

        
        enlargeServer.enlargeGestureArray = enlargeGestureArray
        enlargeServer.addGestureArray = addGestureArray
        enlargeServer.enlargeImageView(self.imgViews!)
    }
    
    deinit {
        print("PhotosServer ------ 释放了")
    }
    
    
    func setupGesture() {
        
        weak var weakSelf = self
        
        /// 设置手势
        for imageView in weakSelf!.imgViews! {
            
            imageView.gestureRecognizers?.removeAll()
            
            let index = weakSelf!.imgViews?.index(of: imageView)
            
            // 是相册图片，就设置成放大手势
            if imageView.image != nil && (imageView.image?.isEqual(UIImage(named: "添加按钮")))! == false {
                
                imageView.addGestureRecognizer(weakSelf!.enlargeGestureArray[index!])
            }
            
            // 是添加图片就设置成添加手势
            if imageView.image != nil && (imageView.image?.isEqual(UIImage(named: "添加按钮")))! == true {
                
                imageView.addGestureRecognizer(weakSelf!.addGestureArray[index!])
            }
            
            // 是照相机图片就设置成放大手势
            if imageView.image != nil && (imageView.image?.isEqual(UIImage(named: "照相机按钮")))! == true {
                
                imageView.addGestureRecognizer(weakSelf!.addGestureArray[index!])
            }
            
            
            
            if imageView.image == nil {
                imageView.isUserInteractionEnabled = false
            } else {
                imageView.isUserInteractionEnabled = true
            }
            
        }
    }
}

