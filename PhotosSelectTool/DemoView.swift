//
//  DemoView.swift
//  PhotosSelectTool
//
//  Created by majianghai on 2017/6/19.
//  Copyright © 2017年 maZhan. All rights reserved.
//

import UIKit

class DemoView: UIView , UIActionSheetDelegate, UIGestureRecognizerDelegate {

    var myActionSheet: UIActionSheet?

    var addGestureArray = [UITapGestureRecognizer]()
    var photosServer    : PhotosServer?
    
    
    override func awakeFromNib() {
        
        for imageView in self.subviews {
            
            let aSelector : Selector = #selector(DemoView.addImage)
            let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
            tapGesture.delegate = self
            tapGesture.numberOfTapsRequired = 1
            addGestureArray.append(tapGesture)
            
            imageView.layer.masksToBounds = true
        }
        self.subviews.first?.addGestureRecognizer(addGestureArray.first!)
    }
    
    
    
    

    
    func addImage() {
        
        myActionSheet = UIActionSheet(title:nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "拍照", otherButtonTitles: "相册")
        myActionSheet!.show(in: self)
    }
    
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        switch (buttonIndex) {
        case 0:
            //拍照
            photosServer = PhotosServer()
            photosServer?.takePhotosWithImageViews(self.subviews as! [UIImageView], addGestureArray: addGestureArray , callBackBlock: { (picker : UIViewController) in
                self.getCurrentVC().present(picker, animated: true, completion: nil)
            })
            break;
        case 2:
            //从相册选择
            photosServer = PhotosServer()
            photosServer?.pickPhotosWithImageViews(self.subviews as! [UIImageView], addGestureArray: addGestureArray, callBackBlock: { (nav : UIViewController) in
                
                self.getCurrentVC().present(nav, animated: true, completion: nil)
                
            })
            break;
        default:
            break;
        }
    }
    
    
    func getCurrentVC() -> UIViewController {
        
        var result: UIViewController;
        
        var window = UIApplication.shared.keyWindow
        
        if window?.windowLevel != UIWindowLevelNormal {
            
            let windows = UIApplication.shared.windows
            
            for tmpWin in windows {
                
                if tmpWin.windowLevel == UIWindowLevelNormal {
                    window = tmpWin
                    break
                }
            }
        }
        
        let frontView = window?.subviews[0]
        let nextResponder = frontView?.next
        
        if nextResponder!.isKind(of: UIViewController.self) {
            result = nextResponder as! UIViewController
            
        } else {
            result = (window?.rootViewController)!;
        }
        
        return result;
        
    }
    

}





