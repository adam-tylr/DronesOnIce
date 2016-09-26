//
//  ViewController.swift
//  Drones on Ice Mobile
//
//  Created by Adam Tyler on 9/22/16.
//  Copyright © 2016 Adam Tyler. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "back")!)
        loginButton.layer.cornerRadius = 3.0
        registerButton.layer.cornerRadius = 3.0
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor.black.cgColor
        registerButton.layer.borderWidth = 1.0
        registerButton.layer.borderColor = UIColor.black.cgColor

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("fdfgsdfgsdfg")
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token") as String!
        if token != nil{
            Alamofire.request("http://192.168.1.131:5000/user").authenticate(user: token!, password: "").responseJSON { response in
                debugPrint(response)
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if let fName = JSON["first_name"] , let lName = JSON["last_name"]{
                        defaults.set(fName, forKey: "fName")
                        defaults.set(lName, forKey: "lName")
                        print(fName)
                        self.performSegue(withIdentifier: "showOrderPage", sender: nil)
                    }
                }
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

