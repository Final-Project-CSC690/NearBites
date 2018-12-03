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
    @IBOutlet weak var businessAddress: UILabel!
    
    @IBOutlet weak var reviewsLabel: UILabel!
    
    
    @IBOutlet weak var locationIcon: UIImageView!
    
    @IBOutlet weak var startIcon: UIImageView!
    
    //Glitch inputting businesPhone!
    //@IBOutlet weak var businessPhone: UILabel!

    func setBusinessDescription(business: CDYelpBusiness){
        
        
        locationIcon.image = UIImage(named: "location")
        startIcon.image = UIImage(named: "star")
        
        guard let name = business.name else { return }
        guard let image = business.imageUrl else { return }
        guard let rating = business.rating else { return }
        guard let distance = business.distance else { return }
        guard let address = business.location else { return }
        guard let reviews = business.reviewCount else { return }
        
        //guard let phone = business.price else { return }
        
        print(reviews)
        print(rating)
        print(image)
        print(name)
        print(distance)
        print(address.addressOne!)
        //print(phone)
        
        
        let url = URL(string: image.absoluteString)
        let data = try? Data(contentsOf: url!)
        
        businessAddress.text = address.addressOne!
        
        // Address label Style
        businessAddress.textColor = UIColor.white
        
        
        businessImage.image = UIImage(data: data!)
        
        // Image style!
        businessImage.layer.cornerRadius = 20
        businessImage.clipsToBounds = true
        
        businessName.text = name
        
        // Name Style
        businessName.textColor = UIColor.white
        businessName.font = UIFont.systemFont(ofSize: 20)
            
            
            //UIFont(name:"fontname", size: 20.0)
        
        
        businessRating.text = String(rating)
        businessRating.textColor = UIColor.white
        businessDistance.text = "\(String(round(distance*0.0006))) mi"
        businessDistance.textColor = UIColor.white
        businessDistance.font = UIFont.systemFont(ofSize: 20)
        
        
        reviewsLabel.textColor = UIColor.gray
        reviewsLabel.text = "(\(reviews)+)"
        //businessPhone.text = phone
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 20
        
    }
}

