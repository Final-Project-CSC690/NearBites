//
//  MapViewController.swift
//  NearBites
//
//  Created by Simon on 12/8/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//


import UIKit
import YelpAPI
import Alamofire
import CDYelpFusionKit
import CoreLocation
import MapKit

class MapViewController: UIViewController
{
    @IBOutlet weak var map: MKMapView!
    var businessesReturned: Businesses!
    var annotation: [MKPointAnnotation] = []
    var tempAnnotation : MKPointAnnotation!
    let annotationLauncher : AnnotationLauncher = {
        let launcher = AnnotationLauncher()
        return launcher
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addBusniessLocations()
        self.map.showAnnotations(self.map.annotations, animated: true)
    }
    
    func addBusniessLocations()
    {
        if(businessesReturned.businesses.count == 0)
        {
            return
        }
        else
        {
            for business in businessesReturned.businesses
            {
                tempAnnotation = MKPointAnnotation()
                tempAnnotation.coordinate = CLLocationCoordinate2DMake((business.coordinates?.latitude)!, (business.coordinates?.longitude)!)
                tempAnnotation.title = business.name
                annotation.append(tempAnnotation)
            }
            map.addAnnotations(annotation)
        }
    }
}

extension MapViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        annotationLauncher.businessesReturned = self.businessesReturned
        annotationLauncher.annotationView = view
        annotationLauncher.showInfo()
    }
}

