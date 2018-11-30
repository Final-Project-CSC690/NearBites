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

    @IBOutlet weak var yelpLogo: UIImageView!
    @IBAction func SearchButton(_ sender: UIButton) {
        performSegue(withIdentifier: "SearchTransition", sender: self)
        
        
        //guard let term = searchTerm.text else { return}
        //print(term)
    }
    
    @IBOutlet weak var searchTerm: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //cell.imageView?.image = UIImage.yelpStars(numberOfStars: .twoHalf, forSize: .large)
        //cell.imageView?.image = UIImage.yelpBurstLogoRed(
        yelpLogo.image = UIImage(named: "logo")
        
        // Do any additional setup after loading the view.
        // Hide the navigation bar on the this view controller
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
