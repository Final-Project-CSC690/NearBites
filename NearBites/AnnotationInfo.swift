//
//  AnnotationInfo.swift
//  NearBites
//
//  Created by Simon on 12/9/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import MapKit
import CDYelpFusionKit


class AnnotationInfo : NSObject
{
    var businessesReturned: Businesses?
    var annotationView: MKAnnotationView!
    var currBusiness : CDYelpBusiness!
    var map: MKMapView!
    
    init(mapView map: MKMapView, bussiness businessesReturned: Businesses, annotationView: MKAnnotationView)
    {
        super.init()
        self.businessesReturned = businessesReturned
        self.annotationView = annotationView
        self.map = map
    }

    func setCurrBusiness()
    {
        for businesses in self.businessesReturned!.businesses
        {
            if((annotationView.annotation?.title)!! == businesses.name)
            {
                self.currBusiness = businesses
                return
            }
        }
    }
    var blackView = UIView()
    func showInfo()
    {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            map.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            blackView.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.5, animations: {
                self.blackView.alpha = 1
            })
        }
    }
    
    @objc func handleDismiss(_ recognizer: UITapGestureRecognizer)
    {
        print("Hello")
        //        map.willRemoveSubview(blackView)
    }
}


