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


//Ulysses method
struct Business {
    let name: String
    let address: String
}


struct Businesses {
    var businesses = [CDYelpBusiness]()
}

class ViewController: UIViewController {
    //holds all returned business from search
    var businessesReturned = Businesses()
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var MoneySign: UILabel!
    @IBOutlet weak var StarRating: UILabel!
    @IBOutlet weak var Distance: UILabel!
    
    
    let yelpAPIClient = CDYelpAPIClient(apiKey: Constant.init().APIKey)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBusinesses(yelpAPIClient: yelpAPIClient)
        
    }
    
    func getBusinesses(yelpAPIClient: CDYelpAPIClient) {
        
        // Cancel any API requests previously made
        yelpAPIClient.cancelAllPendingAPIRequests()
        // Query Yelp Fusion API for business results
        yelpAPIClient.searchBusinesses(byTerm: "Mexican",
                                       location: "San Francisco",
                                       latitude: 37.730740,
                                       longitude: -122.405275,
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
                                            
                                            self.businessesReturned.businesses = businesses
                                            for b in self.businessesReturned.businesses {
                                                print(b.name)
                                            }
                                            
                                            var minDistance = 99999.99
                                            var closesBusiness = ""
                                            var moneySigns = ""
                                            var rating = 0.0
                                            for business in businesses {
                                                
                                                guard let businessName = business.name else { continue }
                                                guard let businessMoneysigns = business.price else { continue }
                                                guard let businessRating = business.rating else { continue }
                                                guard var businessDistance = business.distance else { continue }
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
                                                print(businessPic)
                                                print(String(format: "%.2f", businessDistance))
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




