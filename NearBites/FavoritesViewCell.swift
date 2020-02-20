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
import CoreData

class FavoritesViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var starRating: UIImageView!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        
        let context = PersistenceService.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Business")
        let predicate = NSPredicate(format: "name = %@", argumentArray: [restaurantName.text ?? ""])
        fetch.predicate = predicate
        
        if favoriteButton.titleLabel!.text == "❤️" {
            do {
                let result = try context.fetch(fetch)
                for data in result as! [NSManagedObject] {
                    print(data.value(forKey: "name") as! String)
                }
                if result.count > 0 {
                    PersistenceService.context.delete(result[0] as! NSManagedObject)
                    PersistenceService.saveContext()
                }
                sender.setTitle("♡", for: [])
            } catch {
                print("Failed")
            }
        } else {
            let b = Business(context: PersistenceService.context)
            b.name = restaurantName.text
            b.phoneNumber = phone.text
            b.address = restaurantAddress.text
            b.image = convertImageToNSdata(image: restaurantImage!) as Data
            b.starRating = convertImageToNSdata(image: starRating) as Data
            b.long = long
            b.lat = lat
            PersistenceService.saveContext()
            sender.setTitle("❤️", for: [])
        }
        
    }
    
    func convertImageToNSdata(image: UIImageView) -> NSData {
        let returnData = image.image?.pngData()! as! NSData
        return returnData
    }
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Image style!
        restaurantImage.layer.cornerRadius = 10
        restaurantImage.clipsToBounds = true
        restaurantImage.layer.borderColor = UIColor.black.cgColor
        restaurantImage.layer.borderWidth = 1
    }
}

