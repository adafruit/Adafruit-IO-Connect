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
        
        self.gyroTagX.text = "--"
        self.gyroTagY.text = "--"
        self.gyroTagZ.text = "--"
        
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
                
                self.gyroTagX.text = String(format: "%.2f", gyroscopeX!)
                self.gyroTagY.text = String(format: "%.2f", gyroscopeY!)
                self.gyroTagZ.text = String(format: "%.2f", gyroscopeZ!)
                
                
                print("Gyroscope X:\(gyroscopeX!)")
                print("Gyroscope Y:\(gyroscopeY!)")
                print("Gyroscope Z:\(gyroscopeZ!)")
                self.postGyroData()
            }
        })
        
    }
    
    
    func postGyroData() {
        
        // adafruit post syntax:
        //http://io.adafruit.com/api/feeds/your-feed-key/data.json?X-AIO-Key=ed0dcb344edf621e39678f08533a674a197c5b75
        
        
        let parameters = ["value": "\(String(format: "%.2f", (motionManager.gyroData?.rotationRate.x)!))"]
        
        //Create new Data //POST	/{username}/feeds/{feed_key}/data
        //My AIO Key: c04d002a910e4eff85e6b83203d4e287
        
        guard let url = URL(string: "https://io.adafruit.com/api/feeds/text-feed/data.json?X-AIO-Key=c04d002a910e4eff85e6b83203d4e287") else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    
    
    func stopGyro() {
        self.motionManager.stopGyroUpdates()
        self.gyroTagX.text = "--"
        self.gyroTagY.text = "--"
        self.gyroTagZ.text = "--"
        print("Gyroscope Stopped Updating...")
        
        
    }
    
}
