//
//  RegisterViewController.swift
//  Drones on Ice Mobile
//
//  Created by Adam Tyler on 9/24/16.
//  Copyright © 2016 Adam Tyler. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SumbitRegistration(_ sender: AnyObject) {
        
        status.text = "Loading...."
        
        let parameters: Parameters = [
            "first_name": firstName.text!,
            "last_name": lastName.text!,
            "username": email.text!,
            "password": password.text!
        ]
        
        Alamofire.request("http://192.168.1.131:5000/user/register", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                if let token = JSON["token"]{
                    let defaults = UserDefaults.standard
                    defaults.set(token, forKey: "token")
                    self.navigationController?.popViewController(animated: true)
                }else {
                    if let error = JSON["error"]{
                        self.status.text = "\(error)"
                    }
                }
            }
        }

    }
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
