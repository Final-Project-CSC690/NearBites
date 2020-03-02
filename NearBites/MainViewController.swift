//
//  MainViewController.swift
//  NearBites
//
//  Created by Ulises Martinez on 11/28/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import CDYelpFusionKit
import CoreLocation

extension UITextField {
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(0.6),
            NSAttributedString.Key.font: self.font!
            ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }
}

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Tittle: UILabel!
    @IBOutlet weak var yelpLogo: UIImageView!
    @IBOutlet weak var searchTerm: UISearchBar!
    @IBOutlet weak var numberOfResults: UITextField!
    @IBAction func SearchButton(_ sender: UIButton) {
        performSegue(withIdentifier: "SearchTransition", sender: self)
    }
    
    //Location manager
    let locationManager = CLLocationManager()
    
    //coordinates to hold
    var longitude = 0.0
    var latitude = 0.0
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location Delgate, Request for authorization, Update every 300 meters(around 1 block)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100

        yelpLogo.image = UIImage(named: "logo")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        searchTerm.searchTextField.textColor = .white
        
        numberOfResults.translatesAutoresizingMaskIntoConstraints = false
        numberOfResults.attributedPlaceholder = NSAttributedString(string: "Number of results", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1.0)])
        numberOfResults.borderStyle = .none
        numberOfResults.layer.cornerRadius = 10
        numberOfResults.layer.masksToBounds = true
        numberOfResults.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        numberOfResults.widthAnchor.constraint(equalToConstant: 200).isActive = true
        numberOfResults.font = .systemFont(ofSize: 17)
        
        numberOfResults.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let numberPressed = string
        let numberInTextField = textField.text
        if Int(numberInTextField! + numberPressed) ?? 5 > 50{
            numberOfResults.attributedPlaceholder = NSAttributedString(string: "Must be less than 50", attributes: [.font: UIFont.systemFont(ofSize: 17), .foregroundColor: UIColor.red])
            textField.text = ""
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recieverVc = segue.destination as! ViewController
        //recieverVc.term = searchTerm.text!
        recieverVc.longitude = self.longitude
        recieverVc.latitude = self.latitude
        if let text = searchTerm.text, let resultNum = numberOfResults.text  {
            recieverVc.term = text
            recieverVc.numberOfResults = Int(resultNum)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            guard let latitude = locations.last?.coordinate.latitude else { return }
            guard let longitude = locations.last?.coordinate.longitude else { return }
            self.latitude = latitude
            self.longitude = longitude
        } else {
            print("No coordinates")
        }
    }
}

extension UIButton{
    override open func didMoveToWindow() {
        self.layer.cornerRadius = 15
    }
}

