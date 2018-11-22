//
//  ViewController.swift
//  NearBites
//
//  Created by Paul Ancajima on 11/19/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

//
//  ViewController.swift
//  Yelp API
//
//  Created by Paul Ancajima on 11/11/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import YelpAPI
import Alamofire
import CDYelpFusionKit
import CoreLocation


//Ulysses method
struct Business {
    let name: String
    let address: String
}

struct Businesses {
    var businesses = [CDYelpBusiness]()
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //Location manager
    let locationManager = CLLocationManager()
    
    //group is similar to a semaphore, Enter, Leave, Wait, Notify (for when completed)
    let group = DispatchGroup()
    
    //coordinates to hold
    var longitude = 0.0
    var latitude = 0.0
    
    //holds all returned business from search
    var businessesReturned = Businesses()
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var MoneySign: UILabel!
    @IBOutlet weak var StarRating: UILabel!
    @IBOutlet weak var Distance: UILabel!
    
    @IBAction func RefreshCoordinate(_ sender: Any) {
        viewDidLoad()
    }
    
    let yelpAPIClient = CDYelpAPIClient(apiKey: Constant.init().APIKey)
    
    override func viewDidLoad() {
        
        //function that gets all nearby businesses
        getBusinesses(yelpAPIClient: yelpAPIClient)
        
        //Location Delgate, Request for authorization, Update every 300 meters(around 1 block)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 300
        
        super.viewDidLoad()
        
        //notification when task is completed
        self.group.notify(queue: .main) {
            print("Finally completed and able to use elements in array to do stuff such as reload data if there was a tableview" )
            print(self.businessesReturned.businesses.count)
            for b in self.businessesReturned.businesses {
                print(b.distance)
            }
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            guard let latitude = locations.first?.coordinate.latitude else { return }
            guard let longitude = locations.first?.coordinate.longitude else { return }
            self.latitude = latitude
            self.longitude = longitude
            print(self.longitude)
            print(self.latitude)
        } else {
            print("No coordinates")
        }
    }
    
    func getBusinesses(yelpAPIClient: CDYelpAPIClient) {
        self.group.enter()
        // Cancel any API requests previously made
        yelpAPIClient.cancelAllPendingAPIRequests()
        // Query Yelp Fusion API for business results
        yelpAPIClient.searchBusinesses(byTerm: "Mexican",
                                       location: "San Francisco",
                                       latitude: self.latitude,
                                       longitude: self.longitude,
                                       radius: 10000,
                                       categories: nil,
                                       locale: .english_unitedStates,
                                       limit: 5,
                                       offset: 0,
                                       sortBy: .distance,
                                       priceTiers: nil,
                                       openNow: true,
                                       openAt: nil,
                                       attributes: nil) { (response) in
                                        
                                        if let response = response,
                                            let businesses = response.businesses,
                                            businesses.count > 0 {
                                            
                                            var minDistance = 99999.99
                                            var closesBusiness = ""
                                            var moneySigns = ""
                                            var rating = 0.0
                                            
                                            
                                            DispatchQueue.main.async {
                                                //sort businesses by distance because returned businesses may not be sorted
                                                if businesses.count > 1 {
                                                    self.businessesReturned.businesses = businesses.sorted(by: { ($0.distance!.isLess(than: $1.distance!))})
                                                } else {
                                                    self.businessesReturned.businesses = businesses
                                                }
                                                self.group.leave()
                                            }
                                           
                                            self.businessesReturned.businesses = businesses
                                            
                                            for business in self.businessesReturned.businesses {
                                                guard let businessName = business.name else { continue }
                                                guard let businessMoneysigns = business.price else { continue }
                                                guard let businessRating = business.rating else { continue }
                                                guard let businessDistance = business.distance else { continue }
                                                guard let businessPic = business.imageUrl else { continue }
                                                
                                                if businessDistance < minDistance {
                                                    minDistance = businessDistance
                                                    closesBusiness = businessName
                                                    moneySigns = businessMoneysigns
                                                    rating = businessRating
                                                }
                                                
                                                print(businessName)
                                                print(businessMoneysigns)
                                                print(businessRating)
                                                print(String(format: "%.2f", businessDistance * 0.0006))
                                                print()
                                                
                                                let url = URL(string: businessPic.absoluteString)
                                                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                                                self.picture.image = UIImage(data: data!)
                                                
                                            }
                                            
                                            print("The closes restaurant \(closesBusiness) is about \(String(format: "%.2f", minDistance * 0.0006)) miles away")
                                            
                                            self.Name.text = closesBusiness
                                            self.MoneySign.text = moneySigns
                                            self.StarRating.text = String(rating)
                                            self.Distance.text = "\(String(format: "%.2f", minDistance * 0.0006)) miles away"
                                        }
                                        
        }
    }
    
    
}




