//
//  GyroViewController.swift
//  Adafruit IO Connect
//
//  Created by Trevor Beaton on 6/23/17.
//  Copyright © 2017 Vanguard Logic LLC. All rights reserved.
//

import UIKit
import CoreMotion

class GyroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        startGyro()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var gyroTagZ: UILabel!
    @IBOutlet weak var gyroTagY: UILabel!
    @IBOutlet weak var gyroTagX: UILabel!
    
    @IBAction func stateChange(_ sender: Any) {
        if ((sender as AnyObject).isOn == true){
            self.startGyro()
        }else {
            self.stopGyro()
        }

    }

    //Data
    var motionManager = CMMotionManager()
    
    
    override func viewWillDisappear(_ animated: Bool) {
        stopGyro()
    }
    
    
    func startGyro() {
       print("Start Gyroscope Updates")
        motionManager.gyroUpdateInterval = 2.2
        motionManager.startGyroUpdates(to: OperationQueue.main, withHandler: {
            (gyroData:CMGyroData?, error: Error?) in
            if (error != nil ) {
                let alertView = UIAlertView(title: "Error", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                
            } else {
                
                let gyroscopeX = gyroData?.rotationRate.x
                let gyroscopeY = gyroData?.rotationRate.y
                let gyroscopeZ = gyroData?.rotationRate.z
                
                self.gyroTagX.text = String(format: "%.02f", gyroscopeX!)
                self.gyroTagY.text = String(format: "%.02f", gyroscopeY!)
                self.gyroTagZ.text = String(format: "%.02f", gyroscopeZ!)
                
                
                print("Gyroscope X:\(gyroscopeX!)")
                print("Gyroscope Y:\(gyroscopeY!)")
                print("Gyroscope Z:\(gyroscopeZ!)")
                
            }
        })
        
    }

    
    
    
    func stopGyro() {
        self.motionManager.stopGyroUpdates()
        self.gyroTagX.text = "--"
        self.gyroTagY.text = "--"
        self.gyroTagZ.text = "--"
        print("Gyroscope Stopped Updating...")
        
        
    }
    
}
