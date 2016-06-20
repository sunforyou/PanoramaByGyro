//
//  ViewController.swift
//  PanoramaByGyro
//
//  Created by 宋旭 on 16/4/8.
//  Copyright © 2016年 sky. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var myPanoramaView: JKPanoramaView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPanoramaView = JKPanoramaView.createJKPanoramaView() as? JKPanoramaView

        self.view.addSubview(myPanoramaView!)
    }
    
    override func viewWillAppear(animated: Bool) {
        myPanoramaView?.scrollWillStart()
    }
    
    override func viewWillDisappear(animated: Bool) {
        myPanoramaView?.scrollWillStop()
    }

}
