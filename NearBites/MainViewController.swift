//
//  MainViewController.swift
//  NearBites
//
//  Created by Ulises Martinez on 11/28/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import CDYelpFusionKit

class MainViewController: UIViewController {

    
    @IBOutlet weak var Tittle: UILabel!
    
    @IBOutlet weak var yelpLogo: UIImageView!
    
    @IBAction func SearchButton(_ sender: UIButton) {
        performSegue(withIdentifier: "SearchTransition", sender: self)
    }
    
    /*
    @IBAction func SettingsButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "settingSegue", sender: self)
        
        // You Will have to pass business settings to base your search on!
    }*/
    
    
    @IBOutlet weak var searchTerm: UISearchBar!
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        yelpLogo.image = UIImage(named: "logo")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let recieverVc = segue.destination as! ViewController
        //recieverVc.term = searchTerm.text!
        
        if let text = searchTerm.text {
            recieverVc.term = text
        }
    
    }

}
