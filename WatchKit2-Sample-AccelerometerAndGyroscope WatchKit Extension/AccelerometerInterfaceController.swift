//
//  AccelerometerInterfaceController.swift
//  WatchKit2-Sample-CoreMotion
//
//  Created by XuQing on 15/8/2.
//  Copyright © 2015年 XuQing1001. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class AccelerometerInterfaceController: WKInterfaceController {

    @IBOutlet var pointImg: WKInterfaceImage!
    @IBOutlet weak var labelX: WKInterfaceLabel!
    @IBOutlet weak var labelY: WKInterfaceLabel!
    @IBOutlet weak var labelZ: WKInterfaceLabel!
    
    // 新建CMMotionManager对象。 注意，创建多个CMMotionManager对象会影响性能
    let motionManager = CMMotionManager()
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // 设置数据更新时间间隔
        motionManager.accelerometerUpdateInterval = 0.2// 0.2秒
    }
    
    override func willActivate() {
        super.willActivate()

        // 判断陀螺仪是否可用
        if (motionManager.accelerometerAvailable == true) {
            
            // 数据处理代码块： 用于把数据反映到界面上
            let handler:CMAccelerometerHandler = {(data: CMAccelerometerData?, error: NSError?) -> Void in
                let x = data!.acceleration.x
                let y = data!.acceleration.y
                let z = data!.acceleration.z
                
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
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: handler)
        } else {
            self.labelX.setText("数据不可访问")
            self.labelY.setText("数据不可访问")
            self.labelZ.setText("数据不可访问")
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        // 停止获取数据
        motionManager.stopAccelerometerUpdates()
    }
}
