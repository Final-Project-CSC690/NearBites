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
import MapKit


class ViewController: UIViewController {
    
    //API client key. Remember to make a Constant.swift containing your own constant apikey this file will be ignored by github
    let yelpAPIClient = CDYelpAPIClient(apiKey: Constant.init().APIKey)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Reload Button
    @IBAction func reloadbusinessButton(_ sender: UIBarButtonItem) {
        viewDidLoad()
    }
    
    // View Map Button (To display all restaurants at once
    @IBAction func viewMapButton(_ sender: UIBarButtonItem) {
        //print("simon view will load with segue")
        
        //BusinessesMapSegue
        //performSegue(withIdentifier: "BusinessesMapSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let businessDesriptionVC = segue.destination as? BusinessDescriptionViewController else { return }
        businessDesriptionVC.reviewFromViewController = review
        
        
    }
    // THIS MIGHT BE IMPLEMENTED!
    @IBAction func businessDescription(_ sender: UIButton) {
        performSegue(withIdentifier: "businessDescriptionSegue", sender: self)
        
    }
    
    //reviews
    var review: String?
    
    // Search term been passed from Main View
    var term: String?
    
    // Filter Search Category to Restaurants!
    var categories = [CDYelpBusinessCategoryFilter.restaurants]
    
    //Location manager
    let locationManager = CLLocationManager()
    
    //group is similar to a semaphore, Enter, Leave, Wait, Notify (for when completed)
    let group = DispatchGroup()
    
    //coordinates to hold
    var longitude = 0.0
    var latitude = 0.0
    
    //holds all returned business from search
    var businessesReturned = Businesses()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Eliminating Visible bar!
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Collection view dataSource
        collectionView.dataSource = self
        
        //function that gets all nearby businesses
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
    
    
    func getBusinessReview(CDYelpBusiness: CDYelpBusiness) {
        yelpAPIClient.fetchReviews(forBusinessId: CDYelpBusiness.id,
                                   locale: nil) { (response) in
                                    if let response = response,
                                        let reviews = response.reviews,
                                        reviews.count > 1 {
                                        
                                        self.review = reviews.max { $0.rating! < $1.rating!}?.text
                                       
                                    }
        }
    }
    
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
                                            
                                            //print(businesses.)
                                            
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

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.businessesReturned.businesses.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("inside collection view")
        let business = self.businessesReturned.businesses[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionBusinessCell
        cell.starRating.image = UIImage.yelpStars(numberOfStars: starRating(rating: business.rating!), forSize: .small)
        cell.setBusinessDescription(business: business)
        getBusinessReview(CDYelpBusiness: business)
        
        return cell
    }
}

//Business struct object
struct Businesses {
    var businesses = [CDYelpBusiness]()
}

//function for displaying star rating
func starRating (rating: Double) -> CDYelpStars {
    if rating == 0.0 {
        return CDYelpStars.zero
    }else if rating == 1.0 {
        return CDYelpStars.one
    }else if rating == 1.5 {
        return CDYelpStars.oneHalf
    }else if rating == 2.0 {
        return CDYelpStars.two
    }else if rating == 2.5 {
        return CDYelpStars.twoHalf
    }else if rating == 3.0 {
        return CDYelpStars.three
    }else if rating == 3.5 {
        return CDYelpStars.threeHalf
    }else if rating == 4.0 {
        return CDYelpStars.four
    }else if rating == 4.5 {
        return CDYelpStars.fourHalf
    }else if rating == 5.0 {
        return CDYelpStars.five
    } else {
        return CDYelpStars.zero
    }
}






