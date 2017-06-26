//
//  ViewController.swift
//  Adafruit IO Connect
//
//  Created by Trevor Beaton on 6/22/17.
//  Copyright © 2017 Vanguard Logic LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        identities = ["Accelerometer","Barometer", "Gyroscope"]
    }

//In each view controller, we need to had different sensors to post
    //Also, we have a textfield that will have a appended strign of the POST URL endpoint so that the data can be sent straight to Adafruit IO/feed_Name
    //The first View -> Navigate or choose between the sensors you'll choose to be sent to your io feed
    //This View Controller is for you to choose a sensor
    //The first VC Accelerometer- contains A-IO Key, values that will be displayed in the current view.
    
 var sensors = ["Accelerometer Sensor","Barometer Sensor","Gyroscope Sensor"]
    
    var identities = [String]()
   
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = sensors[indexPath.row]
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcNames = identities [indexPath.row]
        let viewController = storyboard?.instantiateViewController(withIdentifier: vcNames)
        self.navigationController?.pushViewController(viewController!, animated: true)
    }

       

    
    
}

