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
//    var locationManager: CLLocationManager!
    
    var businessesReturned: Businesses!
    //How much the map should be zoomed when the location is loaded.
//    var span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
//    var region : MKCoordinateRegion!
    var annotation: [MKPointAnnotation] = []
    var tempAnnotation : MKPointAnnotation!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        map.userTrackingMode = .follow
//
//        let location = locations.last as! CLLocation
//        region = MKCoordinateRegion(
//            center: CLLocationCoordinate2DMake((location.coordinate.latitude, location.coordinate.longitude), span: span)
//        map.setRegion(region, animated: true)
        addBusniessLocations()
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
            self.map.showAnnotations(self.map.annotations, animated: true)
        }
    }
    
}

extension MapViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
      //  print(MKAnnotationView.title)
    }
}
