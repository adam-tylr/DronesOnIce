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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func SumbitRegistration(_ sender: AnyObject) {
        //
        let parameters: Parameters = [
            "first_name": firstName.text!,
            "last_name": lastName.text!,
            "username": email.text!,
            "password": password.text!
        ]
        
        Alamofire.request("http://192.168.1.23:5000/user/register", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            debugPrint("All Response Info: \(response)")
            
            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
        }

        
//        var request = URLRequest(url: URL(string: "http://192.168.1.23:5000")!)
//        request.httpMethod = "POST"
//        let data = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted);
//        request.httpBody = data as Data
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {                                                 // check for fundamental networking error
//                print("error=\(error)")
//                return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
//            
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(responseString)")
//        }
//        task.resume()
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
