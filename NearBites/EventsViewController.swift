//
//  EventsViewController.swift
//  NearBites
//
//  Created by Ulises Martinez on 12/10/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//
import UIKit
import YelpAPI
import Alamofire
import CDYelpFusionKit
import CoreLocation
import MapKit

struct Event {
    var events = [CDYelpEvent]()
}

class EventsViewController: UIViewController {
    
    let people = ["ulises","rodrigo", "jhoanna"]
    
    // Filter Search Category to Restaurants!
    var categories = [CDYelpBusinessCategoryFilter.restaurants]
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Location manager
    let locationManager = CLLocationManager()
    
    //group is similar to a semaphore, Enter, Leave, Wait, Notify (for when completed)
    let group = DispatchGroup()
    
    // Search term been passed from Main View
    var term: String?
    
    //coordinates to hold
    var longitude = 0.0
    var latitude = 0.0
    
    //holds all returned business from search
    var businessesReturned = Event()
    
    
    //API client key. Remember to make a Constant.swift containing your own constant apikey this file will be ignored by github
    let yelpAPIClient = CDYelpAPIClient(apiKey: Constant.init().APIKey)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Collection view dataSource
        collectionView.dataSource = self
        
        getBusinesses(yelpAPIClient: yelpAPIClient)
        
        //Location Delgate, Request for authorization, Update every 300 meters(around 1 block)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 300
        
        //notification when task is completed. Can input a print string for debugging
        self.group.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    
    }
    
    /*
    func getBusinesses(yelpAPIClient: CDYelpAPIClient) {
        self.group.enter()
        
        // Cancel any API requests previously made
        yelpAPIClient.cancelAllPendingAPIRequests()
        
        // Coordinates before search!
        print("lat : \(self.latitude) long: \(self.longitude)")
        
        // Query Yelp Fusion API for business results
        yelpAPIClient.searchBusinesses(byTerm: term,
                                       location: nil,
                                       latitude: self.latitude,
                                       longitude: self.longitude,
                                       radius: 10000,
                                       categories: categories,
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
                                            
                                            //print(businesses.description)
                                            
                                            DispatchQueue.main.async {
                                                //sort businesses by distance because returned businesses may not be sorted
                                                if businesses.count > 1 {
                                                    self.businessesReturned.businesses = businesses.sorted(by: { ($0.distance!.isLess(than: $1.distance!))})
                                                } else {
                                                    self.businessesReturned.businesses = businesses
                                                }
                                                self.group.leave()
                                            }
                                        }
        }
    }*/
    
    
    
    func getBusinesses(yelpAPIClient: CDYelpAPIClient) {
        self.group.enter()
        
        // Cancel any API requests previously made
        yelpAPIClient.cancelAllPendingAPIRequests()
        
        // Coordinates before search!
        print("lat : \(self.latitude) long: \(self.longitude)")
        
        yelpAPIClient.searchEvents(byLocale: nil,
                                   offset: nil,
                                   limit: 5,
                                   sortBy: .descending,
                                   sortOn: .popularity,
                                   categories: [.foodAndDrink],
                                   startDate: nil,
                                   endDate: nil,
                                   isFree: nil,
                                   location: nil,
                                   latitude: self.latitude,
                                   longitude: self.longitude,
                                   radius: 10000,
                                   excludedEvents: nil) { (response) in
            
                              
                                    
                                    if let response = response,
                                        let events = response.events,
                                        events.count > 0 {
                                  
                                        DispatchQueue.main.async {
                                            //sort businesses by distance because returned businesses may not be sorted
                                            //print(events.count)
                                            self.businessesReturned.events = events
                                            self.group.leave()
                                        }
                                        
                                        /*
                                        for event in events{
                                            print(event.name!)
                                            print(event.attendingCount!)
                                            print(event.category!)
                                            print(event.description!)
                                            print(event.interestedCount!)
                                        
                                        }*/
                                        
                                    }
        }
    }
}

extension EventsViewController: CLLocationManagerDelegate {
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

extension EventsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.businessesReturned.events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let businesx = self.businessesReturned.events[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cellx", for: indexPath) as! CollectionEventsCell
        cell.setEventDescription(event: businesx)
        return cell
 
       
        
        /*
        let businesx = self.businessesReturned.events[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cellx", for: indexPath) as! CollectionEventsCell
        cell.setEventDescription(event: businesx)
        //cell.setEventDescription(event: businesx)
        
        //cell.setBusinessDescription(business: business)
        //getBusinessReview(CDYelpBusiness: business)
        
        return cell*/
        
    }
}




