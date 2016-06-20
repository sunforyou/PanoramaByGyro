//
//  JKPanoramaView.swift
//  PanoramaByGyro
//
//  Created by 宋旭 on 16/4/11.
//  Copyright © 2016年 sky. All rights reserved.
//

import UIKit
import CoreMotion

class JKPanoramaView: UIView {
    
    @IBOutlet weak var panoramaScrollView: UIScrollView!
    
    @IBOutlet weak var panoramaImageView: UIImageView!
    
    let cmm = CMMotionManager()
    
    var timer: NSTimer?
    var contentOffSet: CGPoint = CGPointZero
    
    class func createJKPanoramaView() -> (AnyObject) {
        
        let objc = NSBundle.mainBundle().loadNibNamed("JKPanoramaView",
                                                      owner: nil,
                                                      options: nil).last
        return objc!
    }
    
    func scrollWillStart() {
        cmm.deviceMotionUpdateInterval = 0.1
        if cmm.deviceMotionAvailable {
            
            let panoramaQueue = NSOperationQueue.currentQueue()
            cmm.startDeviceMotionUpdatesToQueue(panoramaQueue!,
                                                withHandler:
                { [weak self] (data: CMDeviceMotion?, error: NSError?) in
                    
                    if (nil != error ) {
                        self!.cmm.stopDeviceMotionUpdates()
                        print("\(error)")
                    }
                    //通过陀螺仪获取设备绕y轴旋转角度
                    let magnitude = (self!.cmm.deviceMotion?.attitude.pitch)!
                    
                    if fabs(magnitude) > 0.2 {
                        
                        let dict = NSMutableDictionary.init(object: magnitude, forKey: "direction")
                        
                        self!.timer =  NSTimer.init(timeInterval: 0.1,
                            target: self!,
                            selector: #selector(self!.scrollToDirection),
                            userInfo: dict,
                            repeats: true)
                        
                        self!.timer?.fire()
                    }
                })
        }
    }
    
    func scrollToDirection() {
        
        let direction = timer?.userInfo?.objectForKey("direction")?.doubleValue
        
        let roteOfScrolled = 0.2
        
        let distanceX = panoramaImageView.frame.width - UIScreen.mainScreen().bounds.width
        
        if direction >= 0 {
            if contentOffSet.x < distanceX {
                contentOffSet.x += distanceX * CGFloat(roteOfScrolled)
            }
        } else {
            if panoramaScrollView.contentOffset.x > 0 {
                contentOffSet.x -= distanceX * CGFloat(roteOfScrolled)
            }
        }
        
        var offSet = CGPointZero
        offSet.x = contentOffSet.x
        
        if offSet.x < distanceX && offSet.x >= 0 {
            panoramaScrollView.setContentOffset(offSet, animated: true)
        } else {
            print("图片展示完毕")
        }
    }
    
    func scrollWillStop() {
        timer?.invalidate()
        
        if cmm.deviceMotionActive {
            cmm.stopDeviceMotionUpdates()
        }
        
    }
    
}
