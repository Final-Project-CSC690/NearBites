//
//  CollectionEventsCell.swift
//  NearBites
//
//  Created by Ulises Martinez on 12/11/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//
import Foundation
import UIKit
import CDYelpFusionKit
import MapKit

class CollectionEventsCell: UICollectionViewCell {

    var link = "www.google.com"
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventAddress: UILabel!
    @IBOutlet weak var eventInterestedCount: UILabel!
    @IBOutlet weak var eventAttendingCount: UILabel!
    @IBOutlet weak var eventIsFree: UILabel!
    
    @IBAction func website(_ sender: UIButton) {
        //print("jump to address")
        UIApplication.shared.open(URL(string: link)! as URL, options: [:], completionHandler: nil)
    }
    
    var charge = ""
    
    
    func setEventDescription(event: CDYelpEvent){
        
        
        
        
        guard let name = event.name else { return }
        guard let image = event.imageUrl else { return }
        guard let address = event.location else { return }
        guard let attendingCount = event.interestedCount else { return }
        guard let interestedCount = event.attendingCount else { return }
        guard let isFree = event.isFree else { return }
        guard let eventLink = event.eventSiteUrl else { return }
        //guard let price = event.cost else { return }
        //guard let category = event.category else { return }
        //guard let cost = event.cost else { return }
        
        //guard let timeStart = event.timeStart else { return }
        //guard let location = event.location else { return }
        //guard let address = event.location else { return }
        
        //print(date)
        //print(name)
        //print(address.addressOne!)
        //print(cost)
        //print(interestecount)
        //print(timeStart)
        //print(location.addressOne!)
        
        if(isFree == true){
            charge = "Free"
            //eventIsFree.textColor = UIColor.green
        }else{
            //charge = " $ \(String(price))"
            charge = "PAID"
            //eventIsFree.textColor = UIColor.red
        }
        
        
        // link
        let urlx = eventLink.absoluteString
        self.link = urlx
        
        /*
        func link(){
            
            UIApplication.shared.open(URL(string: urlx)! as URL, options: [:], completionHandler: nil)
            
        }*/
        
        
        
        // Category

        //eventCategory.text = "4"
        
        // Cost

        //eventCost.text = "3"
        
        // Interested count
        //eventInterestedCount.text = "2"
        
        // Time Start
        //eventTimeStart.text = "1"
    
        
        // image String preparation!
        let url = URL(string: image.absoluteString)
        let data = try? Data(contentsOf: url!)
        
        // Image
        eventImage.image = UIImage(data: data!)
        
        // Name
        eventName.text = name
        
        // Attending Count
        eventAddress.text = address.addressOne!
        
        // Interested Count
        eventInterestedCount.text = " \(String(interestedCount)) interested"
        
        // Attending Count
        eventAttendingCount.text = " Attending: \(String(attendingCount))"
        
        // Cost
        eventIsFree.text = "Cost:  \(charge)"
        
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Name Style
        eventName.textColor = UIColor.white
        eventName.font = UIFont.systemFont(ofSize: 20)
        eventName.font = UIFont.boldSystemFont(ofSize: 20)
        
        // Interested
        eventInterestedCount.textColor = UIColor.gray
        
        // Image style!
        eventImage.layer.cornerRadius = 20
        eventImage.clipsToBounds = true
        eventImage.layer.borderColor = UIColor.black.cgColor
        eventImage.layer.borderWidth = 10
        
        
        // Cell Style!
        self.layer.cornerRadius = 20
    }
}
