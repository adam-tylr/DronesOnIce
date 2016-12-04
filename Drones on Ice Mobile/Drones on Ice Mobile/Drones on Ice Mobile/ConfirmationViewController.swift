//
//  ConfirmationViewController.swift
//  Drones on Ice Mobile
//
//  Created by Adam Tyler on 9/29/16.
//  Copyright © 2016 Adam Tyler. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class ConfirmationViewController: UIViewController {

    var orderNumber = 0
    var status = String()
    //var location = String()
    var location = CLLocation()
    var point = CLLocationCoordinate2D()
    let regionRadius: CLLocationDistance = 500
    
    @IBOutlet weak var placedMessage: UILabel!
    @IBOutlet weak var orderNumText: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var stage1p1: UILabel!
    @IBOutlet weak var stage1p2: UILabel!
    @IBOutlet weak var stage2p1: UILabel!
    @IBOutlet weak var stage2p2: UILabel!
    @IBOutlet weak var stage3p1: UILabel!
    @IBOutlet weak var stage3p2: UILabel!
    @IBOutlet weak var bullet1: UILabel!
    @IBOutlet weak var bullet2: UILabel!
    @IBOutlet weak var bullet3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        centerMapOnLocation(location: self.location)
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.point
        annotation.title = "Delivery Location"
        map.addAnnotation(annotation)
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token") as String!
        if token != nil{
            Alamofire.request("http://192.168.1.131:5000/order").authenticate(user: token!, password: "").responseJSON { response in
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if let orderNum = JSON["order_number"], let sts = JSON["status"]{
                        self.orderNumber = orderNum as! Int
                        self.status = sts as! String
                        //self.location = lctn as! String
                        self.orderNumText.text = "Order Number: \(self.orderNumber)"
                    }
                    
                    
                }
            }
        }

    }
    


    
    func updateData(){
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token") as String!
        if token != nil{
            Alamofire.request("http://192.168.1.131:5000/order").authenticate(user: token!, password: "").responseJSON { response in
                debugPrint(response)
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if let sts = JSON["status"]{
                        self.status = sts as! String
                        if (self.status == "Shipped"){
                            self.stage2p1.textColor = UIColor.black;
                            self.stage2p2.textColor = UIColor.black;
                            self.stage3p1.textColor = UIColor.black;
                            self.stage3p2.textColor = UIColor.black;
                            self.bullet2.backgroundColor = UIColor.green;
                            self.bullet3.backgroundColor = UIColor.green;
                        } else if (self.status == "Cancelled"){
                            self.stage1p1.text = "Cancelled";
                            self.stage1p2.text = "Call for details"
                            self.bullet1.backgroundColor = UIColor.red;
                            self.stage2p1.textColor = UIColor.white;
                            self.stage2p2.textColor = UIColor.white;
                            self.stage3p1.textColor = UIColor.white;
                            self.stage3p2.textColor = UIColor.white;
                            self.bullet2.backgroundColor = UIColor.white;
                            self.bullet3.backgroundColor = UIColor.white;
                        }
                        print("DONE")
                    }
                    
                    
                }
            }
        }
    }
    
    @IBAction func refreshData(_ sender: AnyObject) {
        updateData();
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func done(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)

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
