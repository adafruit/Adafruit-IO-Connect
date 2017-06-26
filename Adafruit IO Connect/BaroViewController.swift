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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAltimeter()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        stopAltimeter()
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

    
    func stopAltimeter() {
        
        // Reset labels
        self.altiTag.text = "--"
        self.pressureTag.text = "--"
        
        self.altimeter.stopRelativeAltitudeUpdates() // Stop updates
        
        print("Stopped Altitude Updates...")
        
    }

}
