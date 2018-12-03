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
    
    // Outlets!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var startIcon: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessRating: UILabel!
    @IBOutlet weak var businessDistance: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var businessPrice: UILabel!
    
    @IBOutlet weak var BusinessOpen: UILabel!
    func setBusinessDescription(business: CDYelpBusiness){
        
        // Loading Images
        locationIcon.image = UIImage(named: "location")
        startIcon.image = UIImage(named: "star")
        
        // Loading data to be displayed on cells!
        guard let name = business.name else { return }
        guard let image = business.imageUrl else { return }
        guard let rating = business.rating else { return }
        guard let distance = business.distance else { return }
        guard let address = business.location else { return }
        guard let reviews = business.reviewCount else { return }
        guard let price = business.price else { return }
        guard let status = business.isClosed else { return }
        
        var businessStatus = "Status"
        if status == true {
            businessStatus = "Open Now"
            BusinessOpen.textColor = UIColor.green
        }else{
            businessStatus = "Closed Now"
            BusinessOpen.textColor = UIColor.red
        }
        
        // Business Status
        BusinessOpen.text = businessStatus
        
        // image String preparation!
        let url = URL(string: image.absoluteString)
        let data = try? Data(contentsOf: url!)
        
        // Price
        businessPrice.text = price
        
        // Adress
        businessAddress.text = address.addressOne!
        
        // Image
        businessImage.image = UIImage(data: data!)
        
        // Name
        businessName.text = name
        
        // Rating
        businessRating.text = String(rating)
        
        
        // Distance
        businessDistance.text = "\(String(round(distance*0.0006))) mi"
        
        // Review
        reviewsLabel.text = "(\(reviews)+)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Price Style
        businessPrice.textColor = UIColor.white
        
        // Review Styles
        reviewsLabel.textColor = UIColor.gray
        
        
        // Distance Style
        businessDistance.textColor = UIColor.white
        businessDistance.font = UIFont.systemFont(ofSize: 20)
        
        // Rating Style
        businessRating.textColor = UIColor.white
        
        // Name Style
        businessName.textColor = UIColor.white
        businessName.font = UIFont.systemFont(ofSize: 20)
        
        
        // Address label Style
        businessAddress.textColor = UIColor.white
        
        // Image style!
        businessImage.layer.cornerRadius = 20
        businessImage.clipsToBounds = true
        businessImage.layer.borderColor = UIColor.black.cgColor
        businessImage.layer.borderWidth = 10
        
        // Cell Style!
        self.layer.cornerRadius = 20
        
    }
}

