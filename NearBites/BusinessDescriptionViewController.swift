//
//  BusinessDescriptionView.swift
//  NearBites
//
//  Created by Ulises Martinez on 11/30/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import CDYelpFusionKit


class BusinessDescriptionViewController: UIViewController {
   
    
    @IBOutlet weak var review: UILabel!
    
    var reviewFromViewController: String!
   
    override func viewDidLoad() {
        review.sizeToFit()
        review.text = reviewFromViewController
    }
    
}
