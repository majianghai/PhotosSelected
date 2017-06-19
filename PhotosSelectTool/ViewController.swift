//
//  ViewController.swift
//  PhotosSelectTool
//
//  Created by majianghai on 2017/6/19.
//  Copyright © 2017年 maZhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    
    @IBOutlet weak var aview: UIView!
    
    var demoView: DemoView!
    
    
    override func viewDidLoad() {
        
        demoView = Bundle.main.loadNibNamed("DemoView", owner: nibName, options: nil)?.last as! DemoView
        demoView.frame = CGRect(x:10, y:20, width:UIScreen.main.bounds.width - 40, height:65)
        aview.addSubview(demoView)
    }
    


}

