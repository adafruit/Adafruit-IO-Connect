//
//  BaroViewController.swift
//  Adafruit IO Connect
//
//  Created by Trevor Beaton on 6/23/17.
//  Copyright © 2017 Vanguard Logic LLC. All rights reserved.
//

import UIKit
import CoreMotion


class BaroViewController: UIViewController, UITextFieldDelegate {

    
    lazy var altimeter = CMAltimeter()
    var motionManager = CMMotionManager()
    var pressureData: Float?
    var altimeterData: Float?
    var textFeedString: String?
    //Barometer Sensor UI
    @IBOutlet weak var altiSwitch: UISwitch!
    @IBOutlet weak var pressureSwitch: UISwitch!
    @IBOutlet weak var feedString: UILabel!
    @IBOutlet weak var baroFeedButton: UIButton!
    @IBOutlet weak var pressureTag: UILabel!
    @IBOutlet weak var altiTag: UILabel!
    @IBOutlet weak var feedTextField: UITextField!
    
    func storedTextFeed () {
        let feedInput = feedTextField.text
        textFeedString = feedInput
        print("Sent To Feed: \(textFeedString!)")
        self.feedString.text = textFeedString
    }
    
    //Switches
    //This is the altitude meter switch action
    @IBAction func switchChanged(_ sender: UISwitch) {
        //This is the altiSwitch
        if (sender.isOn == true){
            self.pressureSwitch.setOn(false, animated: true)
            self.startAltitudeMeter()
        }else if (sender.isOn == false) {
            self.stopAltimeter()
        }
    }
   
   @IBAction func pressureSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            self.altiSwitch.setOn(false, animated: true)
            self.startPressureMeter()
        }else {
            self.stopPressureMeter()
        }
    }
    
    @IBAction func feedButtonPressed(_ sender: Any) {
    storedTextFeed()
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Barometer Sensor"
        self.altiTag.text = "--"
        self.pressureTag.text = "--"
    }

   override func viewWillDisappear(_ animated: Bool) {
        stopAltimeter()
        stopPressureMeter()
    }
   
    
    //Start Functions
    func startAltitudeMeter() {
        print("Sensor: Meters of relative altitude")
        if(CMAltimeter.isRelativeAltitudeAvailable()) {
            self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: {
                
                (altimeterData: CMAltitudeData?, error: Error?) in
                if (error != nil) {
                   print("Error")
                } else {
                   let altitude = altimeterData?.relativeAltitude.floatValue
                    self.altimeterData = altimeterData?.relativeAltitude.floatValue

                    self.altiTag.text = String(format: "%0.2f", altitude!)
                    print("Meters of relative Altitude: \(altitude ?? 0)")
                    self.postAltitudeData()
                
        /*Altitude events reflect the change in the current altitude, not the absolute altitude. So a hiking app might use this object to track the user’s elevation gain over the course of a hike. Because altitude events may not be available on all devices, always call the isRelativeAltitudeAvailable() method before using this service. */
                
                }
            })
        }
    }

    
    
    func startPressureMeter() {
        
            print("Sensor: Kilopascal of pressure")
        
               if(CMAltimeter.isRelativeAltitudeAvailable()) {
        self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: {
                
                (altimeterData: CMAltitudeData?, error: Error?) in
                if (error != nil) {
                     print("Error")                    
                } else {
                    
                    let pressure = altimeterData?.pressure.floatValue
                    self.pressureTag.text = String(format: "%0.2f", pressure!)
                    print("Kilopascals of Pressure: \(pressure ?? 0)")
                    self.pressureData = altimeterData?.pressure.floatValue
                    
                    //Post
                    self.postPressureData()
                    //The recorded pressure, in kilopascals.
                    
                }
            })
        }
    }
    
    
    
    
    //Stop Functions
    func stopPressureMeter() {
        self.pressureTag.text = "--"
        self.altimeter.stopRelativeAltitudeUpdates() // Stop Update
        print("Stopped Updates For Pressure Meter")

    }
    
    
    func stopAltimeter() {
        self.altiTag.text = "--"
        self.altimeter.stopRelativeAltitudeUpdates() // Stop Update
        print("Stopped Updates For Altitude Meter")
        
    }
    
    //REST API POST Function
    func postPressureData() {
    
    let parameters = ["value": "\(String(format: "%.2f", (pressureData)!))"]
        
    guard let url = URL(string: "https://io.adafruit.com/api/feeds/\(textFeedString!)/data.json?X-AIO-Key=\(ioKey!)") else { return }
        
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

    //REST API POST Function
    func postAltitudeData() {
    
        let parameters = ["value": "\(String(format: "%.2f", (altimeterData)!))"]
        
        guard let url = URL(string: "https://io.adafruit.com/api/feeds/\(textFeedString!)/data.json?X-AIO-Key=\(ioKey!)") else { return }
        
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
