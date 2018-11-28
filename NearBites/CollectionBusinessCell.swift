//
//  CollectionBusinessCell.swift
//  NearBites
//
//  Created by Ulises Martinez on 11/26/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import Foundation
import UIKit
import CDYelpFusionKit

class CollectionBusinessCell: UICollectionViewCell {
    
    
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessRating: UILabel!
    @IBOutlet weak var businessDistance: UILabel!
    
    @IBAction func reloadbusinessButton(_ sender: Any) {
        print("business button")
    }
    func setBusinessDescription(business: CDYelpBusiness){
        print("hi")
        let name = business.name!
        let image = business.imageUrl!
        let rating = String(business.rating!)
        let distance = String(round(business.distance! * 0.0006))
        
        print(rating)
        print(image)
        print(name)
        print(distance)
        
        var url = URL(string: image.absoluteString)
        var data = try? Data(contentsOf: url!)
        businessImage.image = UIImage(data: data!)
        businessName.text = name
        businessRating.text = rating
        businessDistance.text = "\(distance) mi"
        
       /*
        guard let image = business.imageUrl else { return }
        guard let rating = business.rating else { return }
        guard let distance = business.distance else { return }
        
        var url = URL(string: image.absoluteString)
        var data = try? Data(contentsOf: url!)
        businessImage.image = UIImage(data: data!)
        businessName.text = business.name
        businessRating.text = String(rating)
        businessDistance.text = String(distance * 0.0006)
        */
    }
    
}
