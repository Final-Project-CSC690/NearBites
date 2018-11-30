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
    
    
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessRating: UILabel!
    @IBOutlet weak var businessDistance: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    
    @IBOutlet weak var locationIcon: UIImageView!
    
    /*
    @IBAction func reloadbusinessButton(_ sender: Any) {
        print("business button")
    }*/
    /*
    func viewDidLoad(){
        businessName.tintColor = UIColor.yellow
    }*/
    
    func setBusinessDescription(business: CDYelpBusiness){
        //print("hi")
        
        locationIcon.image = UIImage(named: "location")
        
        guard let name = business.name else { return }
        guard let image = business.imageUrl else { return }
        guard let rating = business.rating else { return }
        guard let distance = business.distance else { return }
        guard let address = business.location else { return }
        
        print(rating)
        print(image)
        print(name)
        print(distance)
        print(address.addressOne!)
        
        
        
        let url = URL(string: image.absoluteString)
        let data = try? Data(contentsOf: url!)
        
        businessAddress.text = address.addressOne!
        
        // Address label Style
        businessAddress.textColor = UIColor.white
        
        
        businessImage.image = UIImage(data: data!)
        
        // Image style!
        businessImage.layer.cornerRadius = 20
        businessImage.clipsToBounds = true
        
        businessName.text = name
        
        // Name Style
        businessName.textColor = UIColor.white
        businessName.font = UIFont.systemFont(ofSize: 20)
            
            
            //UIFont(name:"fontname", size: 20.0)
        
        
        businessRating.text = String(rating)
        businessRating.textColor = UIColor.white
        
        businessDistance.text = "\(String(round(distance*0.0006))) mi"
        businessDistance.textColor = UIColor.white
        businessDistance.font = UIFont.systemFont(ofSize: 20)
        
        /*
        businessName: UILabel = {
            let label = UILabel()
            label.text = "restaurant"
            
            return label
        }*/
       /*
        guard let image = business.imageUrl else { return }
        guard let rating = business.rating else { return }
        guard let distance = business.distance else { return }
        
        var url = URL(string: image.absoluteString)
        var data = try? Data(contentsOf: url!)
        businessImage.image = UIImage(data: data!)
        businessName.text = business.name
        businessRating.text = String(rating)
        businessDistance.text = String(distance * 0.0006)
        */
    }
    
    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        // Image to display in collection view!
        //addSubview(imgView)
        
    }
    
    
    
    let imgView: UIImageView = {
        let v=UIImageView()
        //v.frame = CGRect(x: 10, y: 10, width: 10, height:  10)
        //let screenSize: CGRect = UIScreen.main.bounds
        //image.frame = CGRect(x: 0, y: 0, width: 50, height: screenSize.height * 0.2)
        v.image = #imageLiteral(resourceName: "yelp_logo_outline")
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()*/
    
}

