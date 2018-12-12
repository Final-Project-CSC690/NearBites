//
//  FavoritesViewCell.swift
//  NearBites
//
//  Created by Paul Ancajima on 12/11/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import CDYelpFusionKit

class FavoritesViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var starRating: UIImageView!
    @IBAction func goButton(_ sender: Any) {
    }
    @IBOutlet weak var restaurantImage: UIImageView!
    
    
    func setFavCell(business: CDYelpBusiness){
        guard let restaurantName = business.name else { return }
        guard let restaurantAddress = business.location?.addressOne else { return }
        
        guard let restaurantImage = business.imageUrl else { return }
        let url = URL(string: restaurantImage.absoluteString)
        let data = try? Data(contentsOf: url!)
        
        self.restaurantImage.image = UIImage(data: data!)
        self.restaurantName.text = restaurantName
        self.restaurantAddress.text = restaurantAddress
    }
    
}

