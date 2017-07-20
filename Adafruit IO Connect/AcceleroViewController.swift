//
//  AcceleroViewController.swift
//  Adafruit IO Connect
//
//  Created by Trevor Beaton on 6/23/17.
//  Copyright © 2017 Vanguard Logic LLC. All rights reserved.
//

import UIKit
import CoreMotion

class AcceleroViewController: UIViewController {

    @IBOutlet weak var aSwitchZ: UISwitch!
    @IBOutlet weak var aSwitchY: UISwitch!
    @IBOutlet weak var aSwitchX: UISwitch!
    @IBOutlet weak var accelTagZ: UILabel!
    @IBOutlet weak var accelTagX: UILabel!
    @IBOutlet weak var accelTagY: UILabel!
    
    var motionManager = CMMotionManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accelTagX.text = "--"
        self.accelTagY.text = "--"
        self.accelTagZ.text = "--"
    }
   
    
    //for accelerometer x
     @IBAction func stateChange(_ sender: UISwitch) {
        if (sender.isOn == true){
            self.aSwitchY.setOn(false, animated: true)
            self.aSwitchZ.setOn(false, animated: true)
            startAccelerometerX()
            
        }else {
            stopAccelerometerX()
        }
    }
    
    @IBAction func acceleroSwitchZ(_ sender: UISwitch) {
        if (sender.isOn == true){
            self.aSwitchY.setOn(false, animated: true)
            self.aSwitchX.setOn(false, animated: true)
            startAccelerometerZ()
            
        }else {
            stopAccelerometerZ()
        }
    }





@IBAction func acceleroSwitchY(_ sender: UISwitch) {
        if (sender.isOn == true){
            
            self.aSwitchX.setOn(false, animated: true)
            self.aSwitchZ.setOn(false, animated: true)
            self.startAccelerometerY()
            
        }else {
            stopAccelerometerY()
        }
    }


    
    override func viewWillDisappear(_ animated: Bool) {
        stopAccelerometerX()
        stopAccelerometerY()
        stopAccelerometerZ()
    }
    
//-------------------------------------------------------------------------------------------------------
    //Start Updates
    func startAccelerometerX () {
        print("Start Acceleromter Updates")
        motionManager.accelerometerUpdateInterval = 2.5
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {
            (accelerData:CMAccelerometerData?, error: Error?) in
            if (error != nil ) {
               print("Error")
            } else {
               
                let accelX = accelerData?.acceleration.x
                self.accelTagX.text = String(format: "%.02f", accelX!)
                self.postAccelerometerDataX()
                print("Accelerometer X: \(accelX!)")
            }
       })
    }

    
    func startAccelerometerY () {
        print("Start Acceleromter Updates")
        motionManager.accelerometerUpdateInterval = 2.5
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {
            (accelerData:CMAccelerometerData?, error: Error?) in
            if (error != nil ) {
                print("Error")                
            } else {
                
                let accelY = accelerData?.acceleration.y
                self.accelTagY.text = String(format: "%.02f", accelY!)
                self.postAccelerometerDataY()
                print("Accelerometer Y: \(accelY!)")
            }
        })
    }

    
    func startAccelerometerZ () {
        print("Start Acceleromter Updates")
        motionManager.accelerometerUpdateInterval = 2.5
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {
            (accelerData:CMAccelerometerData?, error: Error?) in
            if (error != nil ) {
                  print("Error")                
            } else {
                
                let accelZ = accelerData?.acceleration.z
                self.accelTagZ.text = String(format: "%.02f", accelZ!)
                self.postAccelerometerDataZ()
                print("Accelerometer Z: \(accelZ!)")
            }
        })
    }

    
//--------------------------------------------------------------------------------------------------------------------------------------------
    //Stop Updates
    func stopAccelerometerX () {
        self.motionManager.stopAccelerometerUpdates()
        self.accelTagX.text = "--"
        print("Accelerometer X Stopped")
    }
    
    func stopAccelerometerY () {
        self.motionManager.stopAccelerometerUpdates()
        self.accelTagY.text = "--"
        print("Accelerometer Y Stopped")
    }

    func stopAccelerometerZ () {
        self.motionManager.stopAccelerometerUpdates()
        self.accelTagZ.text = "--"
        print("Accelerometer Z Stopped")
    }

//-----------------------------------------------------------------------------------------------------------------------------------------
    func postAccelerometerDataX() {
        
        let parameters = ["value": "\(String(format: "%.02f", (motionManager.accelerometerData?.acceleration.x)!))"]
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
    
    func postAccelerometerDataY() {
        
        let parameters = ["value": "\(String(format: "%.02f", (motionManager.accelerometerData?.acceleration.y)!))"]
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
    
    
    func postAccelerometerDataZ() {
        
        let parameters = ["value": "\(String(format: "%.02f", (motionManager.accelerometerData?.acceleration.z)!))"]
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

}
    

