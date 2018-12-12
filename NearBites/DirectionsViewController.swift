//
//  DirectionsViewController.swift
//  NearBites
//
//  Created by Simon on 12/11/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import MapKit
import CDYelpFusionKit
import CoreLocation

class DirectionsViewController: UIViewController
{
 //   let blue = UIColor(displayP3Red: 0.26309, green: 0.359486, blue: 0.445889, alpha: 1)
    var restuarantInfo : CDYelpBusiness!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
  //      self.view.backgroundColor = blue
        self.navigationItem.title = restuarantInfo.name
        
        super.viewWillAppear(animated)

        let mapView = MKMapView()

        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 0
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height

        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)

        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true

        // Or, if needed, we can position map in the center of the view
       // mapView.center = view.center

        view.addSubview(mapView)
    }
}

