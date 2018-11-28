//
//  ViewController.swift
//  NearBites
//
//  Created by Paul Ancajima on 11/19/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//
//1234
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

struct Businesses {
    var businesses = [CDYelpBusiness]()
}

class ViewController: UIViewController {
    
    @IBOutlet weak var businessTableView: UITableView!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var MoneySign: UILabel!
    @IBOutlet weak var StarRating: UILabel!
    @IBOutlet weak var Distance: UILabel!
    @IBAction func RefreshCoordinate(_ sender: Any) {
        viewDidLoad()
    }

    //Location manager
    let locationManager = CLLocationManager()
    
    //group is similar to a semaphore, Enter, Leave, Wait, Notify (for when completed)
    let group = DispatchGroup()
    
    //coordinates to hold
    var longitude = 0.0
    var latitude = 0.0
    
    //holds all returned business from search
    var businessesReturned = Businesses()
    
    //API client key. Remember to make a Constant.swift containing your own constant apikey this file will be ignored by github
    let yelpAPIClient = CDYelpAPIClient(apiKey: Constant.init().APIKey)
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        //function that gets all nearby businesses
        getBusinesses(yelpAPIClient: yelpAPIClient)
        
        //Location Delgate, Request for authorization, Update every 300 meters(around 1 block)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 300
        
        //notification when task is completed. Can input a print string for debugging
        self.group.notify(queue: .main) {
//            print("Business array is now filled")
            self.businessTableView.reloadData()
        }
       
    }
    
    func getBusinesses(yelpAPIClient: CDYelpAPIClient) {
        self.group.enter()
        // Cancel any API requests previously made
        yelpAPIClient.cancelAllPendingAPIRequests()
        // Query Yelp Fusion API for business results
        print("\(self.latitude) \(self.longitude)")
        yelpAPIClient.searchBusinesses(byTerm: "Mexican",
                                       location: nil,
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
                                            
                                            DispatchQueue.main.async {
                                                //sort businesses by distance because returned businesses may not be sorted
                                                if businesses.count > 1 {
                                                    self.businessesReturned.businesses = businesses.sorted(by: { ($0.distance!.isLess(than: $1.distance!))})
                                                } else {
                                                    self.businessesReturned.businesses = businesses
                                                }
                                                self.group.leave()
                                            }
                                            
                                            //following lines of code is meant for debugging
                                            
//                                            self.businessesReturned.businesses = businesses
//                                            var minDistance = 99999.99
//                                            var closesBusiness = ""
//                                            var moneySigns = ""
//                                            var rating = 0.0
//                                            for business in self.businessesReturned.businesses {
//                                                guard let businessName = business.name else { continue }
//                                                guard let businessMoneysigns = business.price else { continue }
//                                                guard let businessRating = business.rating else { continue }
//                                                guard let businessDistance = business.distance else { continue }
//                                                guard let businessPic = business.imageUrl else { continue }
//                                                if businessDistance < minDistance {
//                                                    minDistance = businessDistance
//                                                    closesBusiness = businessName
//                                                    moneySigns = businessMoneysigns
//                                                    rating = businessRating
//                                                }
//                                                print(businessName)
//                                                print(businessMoneysigns)
//                                                print(businessRating)
//                                                print(String(format: "%.2f", businessDistance * 0.0006))
//                                                print()
//                                                let url = URL(string: businessPic.absoluteString)
//                                                let data = try? Data(contentsOf: url!)
//                                                self.picture.image = UIImage(data: data!)
//                                                print("The closes restaurant \(closesBusiness) is about \(String(format: "%.2f", minDistance * 0.0006)) miles away")
//                                            }
                                        }
        }
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            guard let latitude = locations.last?.coordinate.latitude else { return }
            guard let longitude = locations.last?.coordinate.longitude else { return }
            self.latitude = latitude
            self.longitude = longitude
            print(self.latitude)
            print(self.longitude)
        } else {
            print("No coordinates")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businessesReturned.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let business = self.businessesReturned.businesses[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
        cell.setBusinessDescription(business: business)
        return cell 
    }
}






