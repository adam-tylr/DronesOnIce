//
//  ConfirmationViewController.swift
//  Drones on Ice Mobile
//
//  Created by Adam Tyler on 9/29/16.
//  Copyright © 2016 Adam Tyler. All rights reserved.
//

import UIKit
import Alamofire

class ConfirmationViewController: UIViewController {

    var orderNumber = String()
    var status = String()
    var location = String()
    
    @IBOutlet weak var placedMessage: UILabel!
    @IBOutlet weak var orderNumText: UILabel!
    
    @IBOutlet weak var stage1p1: UILabel!
    @IBOutlet weak var stage1p2: UILabel!
    @IBOutlet weak var stage2p1: UILabel!
    @IBOutlet weak var stage2p2: UILabel!
    @IBOutlet weak var stage3p1: UILabel!
    @IBOutlet weak var stage3p2: UILabel!
    @IBOutlet var loadingBar: UIView!
    @IBOutlet weak var bullet1: UILabel!
    @IBOutlet weak var bullet2: UILabel!
    @IBOutlet weak var bullet3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token") as String!
        if token != nil{
            Alamofire.request("http://192.168.1.131:5000/order").authenticate(user: token!, password: "").responseJSON { response in
                debugPrint(response)
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if let orderNum = JSON["order_number"], let sts = JSON["status"], let lctn = JSON["location"]{
                        self.orderNumber = orderNum as! String
                        self.status = sts as! String
                        self.location = lctn as! String
                        self.orderNumText.text = "Order Number: \(self.orderNumber)"
                    }
                    
                    
                }
            }
        }

    }
    
//    var timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: Selector(("updateData:")), userInfo: nil, repeats: true)

    
    func updateData(timer: Timer){
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token") as String!
        if token != nil{
            Alamofire.request("http://192.168.1.131:5000/order").authenticate(user: token!, password: "").responseJSON { response in
                debugPrint(response)
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if let sts = JSON["status"]{
                        self.status = sts as! String
                        print("DONE")
                    }
                    
                    
                }
            }
        }
    }
    



    @IBAction func done(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)

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
