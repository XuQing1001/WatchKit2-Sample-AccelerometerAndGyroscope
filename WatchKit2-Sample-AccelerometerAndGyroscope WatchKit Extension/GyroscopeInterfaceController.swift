//
//  InterfaceController.swift
//  WatchKit2-Sample-CoreMotion WatchKit Extension
//
//  Created by XuQing on 15/8/2.
//  Copyright © 2015年 XuQing1001. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class GyroscopeInterfaceController: WKInterfaceController {

    @IBOutlet var pointImg: WKInterfaceImage!
    @IBOutlet weak var labelX: WKInterfaceLabel!
    @IBOutlet weak var labelY: WKInterfaceLabel!
    @IBOutlet weak var labelZ: WKInterfaceLabel!

    // 新建CMMotionManager对象。 注意，创建多个CMMotionManager对象会影响性能
    let motionManager = CMMotionManager()
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // 设置数据更新时间间隔
        motionManager.gyroUpdateInterval = 0.2// 0.2秒
    }
    
    override func willActivate() {
        super.willActivate()
        
        // 判断陀螺仪是否可用
        if (motionManager.gyroAvailable == true) {
            // 数据处理代码块：用于把数据反映到界面上
            let handler:CMGyroHandler = {(data: CMGyroData?, error: NSError?) -> Void in
                let x = data!.rotationRate.x
                let y = data!.rotationRate.y
                let z = data!.rotationRate.z
                
                self.labelX.setText(String(format: "%.2f", x))
                self.labelY.setText(String(format: "%.2f", y))
                self.labelZ.setText(String(format: "%.2f", z))
                
                if (x < -0.3){
                    self.pointImg.setHorizontalAlignment(.Left)
                } else if (x > 0.3) {
                    self.pointImg.setHorizontalAlignment(.Right)
                } else {
                    self.pointImg.setHorizontalAlignment(.Center)
                }
                
                if (y < -0.3){
                    self.pointImg.setVerticalAlignment(.Bottom)
                } else if (y > 0.3) {
                    self.pointImg.setVerticalAlignment(.Top)
                } else {
                    self.pointImg.setVerticalAlignment(.Center)
                }
            }
            
            // 开始获取数据
            motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: handler)
        } else {
            self.labelX.setText("数据无法访问")
            self.labelY.setText("数据无法访问")
            self.labelZ.setText("数据无法访问")
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        // 停止获取数据
        motionManager.stopGyroUpdates()
    }

}
