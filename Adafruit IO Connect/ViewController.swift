//
//  ViewController.swift
//  Adafruit IO Connect
//
//  Created by Trevor Beaton on 6/22/17.
//  Copyright © 2017 Vanguard Logic LLC. All rights reserved.
//

import UIKit


var ioKey: String?


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBAction func ioKeyPressed(_ sender: Any) {
        storedIOKey()
    }
    @IBOutlet weak var ioKeyTextField: UITextField!
    @IBOutlet weak var ioKeyEnter: UIButton!

   
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        identities = ["Accelerometer","Barometer", "Gyroscope"]
    }

    
    

    
    
    var sensors = ["Accelerometer Sensor","Barometer Sensor","Gyroscope Sensor"]
    
    var identities = [String]()
   
    @IBOutlet weak var tableView: UITableView!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func storedIOKey() {
        let keyInput = ioKeyTextField.text
        ioKey = keyInput
        print(ioKey!)
        
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

