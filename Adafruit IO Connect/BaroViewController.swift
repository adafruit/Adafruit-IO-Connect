//
//  BaroViewController.swift
//  Adafruit IO Connect
//
//  Created by Trevor Beaton on 6/23/17.
//  Copyright © 2017 Vanguard Logic LLC. All rights reserved.
//

import UIKit
import CoreMotion

class BaroViewController: UIViewController {

    
    var motionManager = CMMotionManager()
    lazy var altimeter = CMAltimeter()
    
    
    @IBOutlet weak var altiSwitch: UISwitch!
    @IBOutlet weak var pressureSwitch: UISwitch!
    @IBOutlet weak var pressureTag: UILabel!
    @IBOutlet weak var altiTag: UILabel!
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.altiTag.text = "--"
        self.pressureTag.text = "--"
        
    }

   
    
    
    
    
    
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        stopAltimeter()
        stopPressureMeter()
    }
    
    func startAltimeter() {
       print("Start Altimeter Updates")
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: {
                
                (altimeterData: CMAltitudeData?, error: Error?) in
                if (error != nil) {
                    let alertView = UIAlertView(title: "Error", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                    
                } else {
                    
                    let altitude = altimeterData?.relativeAltitude.floatValue
                    let pressure = altimeterData?.pressure.floatValue
                    
                    self.altiTag.text = String(format: "%0.2f", altitude!)
                    self.pressureTag.text = String(format: "%0.2f", pressure!)
                    
                    
                    print("Altitude: \(altitude!)")
                    print("Pressure: \(pressure!)")
                    
                }
            })
        }
    }

    //new functions for individual sensors
    func startAltitudeMeter() {
        print("Sensor: Meters of relative altitude")
        if(CMAltimeter.isRelativeAltitudeAvailable()) {
            self.altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: {
                
                (altimeterData: CMAltitudeData?, error: Error?) in
                if (error != nil) {
                    let alertView = UIAlertView(title: "Error", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                    
                } else {
                    
                    let altitude = altimeterData?.relativeAltitude.floatValue
               
                    self.altiTag.text = String(format: "%0.2f", altitude!)
                    print("Meters of relative Altitude: \(altitude ?? 0)")
                
                
                    
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
                    let alertView = UIAlertView(title: "Error", message: error!.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                    
                } else {
                    
                    let pressure = altimeterData?.pressure.floatValue
                    
                    self.pressureTag.text = String(format: "%0.2f", pressure!)
                    print("Kilopascals of Pressure: \(pressure ?? 0)")
               
                //The recorded pressure, in kilopascals.
                    
                    
                }
            })
        }
    }
    
    
    
    
    
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

}
