//
//  FavoritesViewCell.swift
//  NearBites
//
//  Created by Paul Ancajima on 12/11/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CDYelpFusionKit
import CoreLocation


class FavoritesViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var starRating: UIImageView!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var phone: UILabel!
    @IBAction func goButton(_ sender: UIButton) {
        let latitude:CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapitem = MKMapItem(placemark: placemark)
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapitem.name = restaurantName.text
        mapitem.openInMaps(launchOptions: options)
    }
    var lat = 0.0
    var long = 0.0
    
//    func setFavCell(business: CDYelpBusiness){
//        guard let restaurantName = business.name else { return }
//        guard let restaurantAddress = business.location?.addressOne else { return }
//        guard let restaurantImage = business.imageUrl else { return }
//        guard let phoneNumber = business.phone else { return }
//        guard let latitude = business.coordinates?.latitude else { return }
//        guard let longitude = business.coordinates?.longitude else { return }
//
//        let url = URL(string: restaurantImage.absoluteString)
//        let data = try? Data(contentsOf: url!)
//
//        self.restaurantImage.image = UIImage(data: data!)
//        self.restaurantName.text = restaurantName
//        self.restaurantAddress.text = restaurantAddress
//        self.lat = latitude
//        self.long = longitude
//        self.phone.text = phoneNumber
//    }
    
}

