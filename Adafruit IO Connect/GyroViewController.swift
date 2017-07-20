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
    
    //Data
    var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.gyroTagX.text = "--"
        self.gyroTagY.text = "--"
        self.gyroTagZ.text = "--"
        
        // Do any additional setup after loading the view.
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        stopGyroX()
        stopGyroY()
        stopGyroZ()
        print("All Gyroscope Updates Ended")
    }
    
    
    //UI
    @IBOutlet weak var gyroTagZ: UILabel!
    @IBOutlet weak var gyroTagY: UILabel!
    @IBOutlet weak var gyroTagX: UILabel!
    @IBOutlet weak var gSwitchZ: UISwitch!
    @IBOutlet weak var gSwitchY: UISwitch!
    @IBOutlet weak var gSwitchX: UISwitch!

    
//-------------------------------------------------------------------------------------------------------
    //Gyroscope Switches
    //For Gyrosc. X
    @IBAction func stateChange(_ sender: UISwitch) {
        if (sender.isOn == true){
            self.gSwitchY.setOn(false, animated: true)
            self.gSwitchZ.setOn(false, animated: true)
            self.startGyroX()
       
        }else {
            self.stopGyroX()
        }
    }
    
    
    @IBAction func gyroYSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            self.gSwitchX.setOn(false, animated: true)
            self.gSwitchZ.setOn(false, animated: true)
            self.startGyroY()
       
        }else {
            self.stopGyroY()
        }
    }
    
     @IBAction func gyroZSwitch(_ sender: UISwitch) {
       if (sender.isOn == true){
            self.gSwitchX.setOn(false, animated: true)
            self.gSwitchY.setOn(false, animated: true)
            self.startGyroZ()
       
       }else {
            self.stopGyroZ()
        }
    }
  
//------------------------------------------------------------------------------------------------------------------------------------------
    //Gyroscope Updates
    func startGyroX() {
        print("Start Gyroscope Updates")
        motionManager.gyroUpdateInterval = 2.2
        motionManager.startGyroUpdates(to: OperationQueue.main, withHandler: {
            (gyroData:CMGyroData?, error: Error?) in
            if (error != nil ) {
                 print("Error")                
            } else {
                
                let gyroscopeX = gyroData?.rotationRate.x
                self.gyroTagX.text = String(format: "%.2f", gyroscopeX!)
                print("Gyroscope X:\(gyroscopeX!)")
                self.postGyroDataX()
            }
        })
        
    }
    
    func startGyroY() {
        print("Start Gyroscope Updates")
        motionManager.gyroUpdateInterval = 2.2
        motionManager.startGyroUpdates(to: OperationQueue.main, withHandler: {
            (gyroData:CMGyroData?, error: Error?) in
            if (error != nil ) {
                  print("Error")                
            } else {
                
                let gyroscopeY = gyroData?.rotationRate.y
                self.gyroTagY.text = String(format: "%.2f", gyroscopeY!)
                print("Gyroscope Y:\(gyroscopeY!)")
                self.postGyroDataY()
            }
        })
        
    }

    func startGyroZ() {
        print("Start Gyroscope Updates")
        motionManager.gyroUpdateInterval = 2.2
        motionManager.startGyroUpdates(to: OperationQueue.main, withHandler: {
            (gyroData:CMGyroData?, error: Error?) in
            if (error != nil ) {
                 print("Error")
            } else {
                
                let gyroscopeZ = gyroData?.rotationRate.z
                self.gyroTagZ.text = String(format: "%.2f", gyroscopeZ!)
                print("Gyroscope Z:\(gyroscopeZ!)")
                self.postGyroDataZ()
            }
        })
        
    }

    
//-----------------------------------------------------------------------------------------------------------------------------------
    //Gyroscope POST
    func postGyroDataX() {
        
        let parameters = ["value": "\(String(format: "%.2f", (motionManager.gyroData?.rotationRate.x)!))"]
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
    
    
    func postGyroDataY() {
        
        let parameters = ["value": "\(String(format: "%.2f", (motionManager.gyroData?.rotationRate.y)!))"]
        guard let url = URL(string: "https://io.adafruit.com/api/feeds/text-feed/data.json?X-AIO-Key=c04d002a910e4eff85e6b83203d4e287") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if response != nil {
                print(parameters)
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
    
    

    func postGyroDataZ() {
        
        let parameters = ["value": "\(String(format: "%.2f", (motionManager.gyroData?.rotationRate.z)!))"]
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
    
//-------------------------------------------------------------------------------------------------------------------------------------------
    //Stop Gyroscope Updates
    
    func stopGyroX() {
        self.motionManager.stopGyroUpdates()
        self.gyroTagX.text = "--"
    }
    
    func stopGyroY() {
        self.motionManager.stopGyroUpdates()
        self.gyroTagY.text = "--"
    }

    func stopGyroZ() {
        self.motionManager.stopGyroUpdates()
        self.gyroTagZ.text = "--"
    }

}
