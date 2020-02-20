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
import CoreData

class CollectionBusinessCell: UICollectionViewCell {
    
    var currentRestaurant: CDYelpBusiness!
    
    @IBOutlet weak var favoritedButton: UIButton!
    
    @IBAction func callButton(_ sender: UIButton) {
        
        if let url = URL(string: "tel://\(link)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func addToFavorites(_ sender: UIButton) {
        var tempBusiAddr = [String]()
        let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
        do {
            let fetchedData = try PersistenceService.context.fetch(fetchRequest)
            for i in fetchedData {
                tempBusiAddr.append(i.address!)
            }
        } catch { }
        
        if tempBusiAddr.contains((currentRestaurant.location?.addressOne)!){
            let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
            do {
                let fetchedData = try PersistenceService.context.fetch(fetchRequest)
                for i in fetchedData {
                    if currentRestaurant.location?.addressOne! == i.address {
                        PersistenceService.context.delete(i)
                    }
                }
            } catch { }
            (sender ).setTitle("♡", for: [])
            
        } else {
            (sender ).setTitle("❤️", for: [])
            let b = Business(context: PersistenceService.context)
            b.name = currentRestaurant.name
            b.phoneNumber = currentRestaurant.phone
            b.address = currentRestaurant.location?.addressOne
            b.image = convertImageToNSdata(image: self.businessImage!) as Data
            b.starRating = convertImageToNSdata(image: self.starRating!) as Data
            guard let lat = currentRestaurant.coordinates?.latitude else { return }
            guard let long = currentRestaurant.coordinates?.longitude else { return }
            b.long = long
            b.lat = lat
            PersistenceService.saveContext()
        }
    }
    
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
    @IBOutlet weak var phone: UILabel!
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
    
    func convertImageToNSdata(image: UIImageView) -> NSData {
        let returnData = image.image?.pngData()! as! NSData
        return returnData
    }
    
    func setBusinessDescription(business: CDYelpBusiness){
        self.currentRestaurant = business
        
        // Loading data to be displayed on cells!
        guard let name = business.name else { return }
        guard let image = business.imageUrl else { return }
        guard let distance = business.distance else { return }
        guard let address = business.location else { return }
        guard let reviews = business.reviewCount else { return }
        guard let price = business.price else { return }
        guard let coordinatesLongitude = business.coordinates?.longitude else { return }
        guard let coordinatesLatitude = business.coordinates?.latitude else { return }
        guard let phone = business.phone else { return }
        
        self.lat = coordinatesLatitude
        self.long = coordinatesLongitude
        
        // Price
        businessPrice.text = price
        
        // Adress
        businessAddress.text = address.addressOne!
        
        // Name
        businessName.text = name
        
        // Distance
        var d = distance*0.000621371
        businessDistance.text = "\(String(format: "%.2f", d)) mi"
        
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
        businessName.adjustsFontSizeToFitWidth = true
        
        // Image style!
        businessImage.layer.cornerRadius = 20
        businessImage.clipsToBounds = true
        businessImage.layer.borderColor = UIColor.black.cgColor
        businessImage.layer.borderWidth = 1
        
        // Cell Style!
        self.layer.cornerRadius = 20

    }
}
