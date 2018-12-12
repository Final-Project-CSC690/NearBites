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
import MapKit

class CollectionBusinessCell: UICollectionViewCell {
    
    // Outlets!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var startIcon: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var starRating: UIImageView!
    @IBOutlet weak var businessDistance: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var businessPrice: UILabel!
    
    @IBAction func DirectionsButton(_ sender: UIButton) {
        let latitude:CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long

        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapitem = MKMapItem(placemark: placemark)
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapitem.name = businessName.text
        mapitem.openInMaps(launchOptions: options)
    }
    
    var lat = 0.0
    var long = 0.0
    var direction = " "
    
    func setBusinessDescription(business: CDYelpBusiness){
        
        // Loading data to be displayed on cells!
        guard let name = business.name else { return }
        guard let image = business.imageUrl else { return }
        guard let distance = business.distance else { return }
        guard let address = business.location else { return }
        guard let reviews = business.reviewCount else { return }
        guard let price = business.price else { return }
        
        guard let coordinatesLongitude = business.coordinates?.longitude else { return }
        guard let coordinatesLatitude = business.coordinates?.latitude else { return }
        
        self.lat = coordinatesLatitude
        self.long = coordinatesLongitude
        print("from collection business cell lat: \(lat) , long: \(long)")
        
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
        
        // Distance
        businessDistance.text = "\(String(round(distance*0.0006))) mi"
        
        // Review
        reviewsLabel.text = "(\(reviews)+)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Address Style
        businessAddress.textColor = UIColor.white
        
        // Price Style
        businessPrice.textColor = UIColor.white
        
        // Review Styles
        reviewsLabel.textColor = UIColor.gray
        
        
        // Distance Style
        businessDistance.textColor = UIColor.white
        businessDistance.font = UIFont.systemFont(ofSize: 20)
        
        // Name Style
        businessName.textColor = UIColor.white
        businessName.font = UIFont.systemFont(ofSize: 20)
        businessName.font = UIFont.boldSystemFont(ofSize: 20)
        
        // Image style!
        businessImage.layer.cornerRadius = 20
        businessImage.clipsToBounds = true
        businessImage.layer.borderColor = UIColor.black.cgColor
        businessImage.layer.borderWidth = 10
        
        // Cell Style!
        self.layer.cornerRadius = 20
        
    }
}

