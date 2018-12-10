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
    var blackView = UIView()
    
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
//        print((view.annotation?.title)!!)
//        AnnotationInfo(mapView: map, bussiness: businessesReturned, annotationView: view)
        showInfo()
        
    }
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
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
        })
    }
}
