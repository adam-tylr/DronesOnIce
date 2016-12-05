//
//  StartOrderViewController.swift
//  Drones on Ice Mobile
//
//  Created by Adam Tyler on 9/26/16.
//  Copyright © 2016 Adam Tyler. All rights reserved.
//

import UIKit
import PassKit
import CoreLocation
import Alamofire

class StartOrderViewController: UIViewController, CLLocationManagerDelegate, PKPaymentAuthorizationViewControllerDelegate  {

    var flavor = ""
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var flavorText: UILabel!
    @IBOutlet weak var totalText: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex, PKPaymentNetwork.discover]
    let ApplePaySwagMerchantID = "merchant.us.adamtyler.drones"
    var lat = CLLocationDegrees()
    var lon = CLLocationDegrees()
    var fullLocation = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "fName") as String!
        message.text = "Hey \(name!)! Hungry?"
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        payButton.isHidden = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pay(_ sender: AnyObject) {
        let request = PKPaymentRequest()
        request.merchantIdentifier = ApplePaySwagMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: flavor, amount: 8),
            PKPaymentSummaryItem(label: "DOI", amount: 8)
        ]
        
        
        request.requiredShippingAddressFields = PKAddressField.all
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        self.present(applePayController, animated: true, completion: nil)
        applePayController.delegate = self
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        lat = locValue.latitude
        lon = locValue.longitude
    }

    
    @IBAction func vanillaTap(_ sender: AnyObject) {
        flavor = "Vanilla"
        flavorText.text = "Flavor: \(flavor)"
        totalText.text = "Total: $8.00"
        payButton.isHidden = false;
    }
    @IBAction func chocTap(_ sender: AnyObject) {
        flavor = "Chocolate"
        flavorText.text = "Flavor: \(flavor)"
        totalText.text = "Total: $8.00"
        payButton.isHidden = false;
    }
    @IBAction func strawberryTap(_ sender: AnyObject) {
        flavor = "Strawberry"
        flavorText.text = "Flavor: \(flavor)"
        totalText.text = "Total: $8.00"
        payButton.isHidden = false;
    }
    @IBAction func berryTap(_ sender: AnyObject) {
        flavor = "Berry Crisp"
        flavorText.text = "Flavor: \(flavor)"
        totalText.text = "Total: $8.00"
        payButton.isHidden = false;
    }
    @IBAction func caramelTap(_ sender: AnyObject) {
        flavor = "Caramel"
        flavorText.text = "Flavor: \(flavor)"
        totalText.text = "Total: $8.00"
        payButton.isHidden = false;
    }
    @IBAction func coffeeTap(_ sender: AnyObject) {
        flavor = "Coffee"
        flavorText.text = "Flavor: \(flavor)"
        totalText.text = "Total: $8.00"
        payButton.isHidden = false;
    }
    @IBAction func pbTap(_ sender: AnyObject) {
        flavor = "Peanut Butter"
        flavorText.text = "Flavor: \(flavor)"
        totalText.text = "Total: $8.00"
        payButton.isHidden = false;
    }
    @IBAction func pecanTap(_ sender: AnyObject) {
        flavor = "Pecan"
        flavorText.text = "Flavor: \(flavor)"
        totalText.text = "Total: $8.00"
        payButton.isHidden = false;
    }

    @IBAction func logout(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "token")
        self.dismiss(animated: true, completion: nil)

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showConfirmation"{
            let confirmation = segue.destination as! ConfirmationViewController
            confirmation.location = CLLocation(latitude: lat, longitude: lon)
            confirmation.point = self.fullLocation
        }
    }
    
    @available(iOS 8.0, *)
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        // Put the order submit code right here?
        let parameters: Parameters = [
            "flavor": flavor,
            "total": 8,
            "location": String(format:"%f, %f", lat, lon)
        ]
        Alamofire.request("http://76.181.84.191:15666/order", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                print(JSON)
            }
            
        }
        controller.dismiss(animated: true, completion: {self.performSegue(withIdentifier: "showConfirmation", sender: nil)})
        
        
    }
    
    @nonobjc func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: ((PKPaymentAuthorizationStatus) -> Void)) {
        completion(PKPaymentAuthorizationStatus.success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}


