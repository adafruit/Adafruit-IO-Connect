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
    
    @IBOutlet weak var switchChangeP: UISwitch!
    @IBOutlet weak var pressureTag: UILabel!
  
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if (sender.isOn == true){
            self.startAltimeter()
        }else {
            self.stopAltimeter()
        }
    }
    @IBOutlet weak var altiTag: UILabel!
    
    //UI Sensor Labels
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAltimeter()
        // Do any additional setup after loading the view.
    }

    
    
    func startAltimeter() {
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

   
    
    func stopAltimeter() {
        
        // Reset labels
        self.altiTag.text = "--"
        self.pressureTag.text = "--"
        
        self.altimeter.stopRelativeAltitudeUpdates() // Stop updates
        
        print("Stopped relative altitude updates.")
        
    }

    
    

   //This view controller holds pressure data and altitude data.
    
}
