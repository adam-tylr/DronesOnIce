//
//  ViewController.swift
//  Drones on Ice Mobile
//
//  Created by Adam Tyler on 9/22/16.
//  Copyright © 2016 Adam Tyler. All rights reserved.
//

import UIKit

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

