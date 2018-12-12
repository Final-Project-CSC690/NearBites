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
    let blue = UIColor(displayP3Red: 0.26309, green: 0.359486, blue: 0.445889, alpha: 1)
    var restaurantInfo : CDYelpBusiness!
    var currLatitude : CLLocationDegrees!
    var currLongitude : CLLocationDegrees!
    var restaurantLongitude : CLLocationDegrees!
    var restaurantLatitude : CLLocationDegrees!
    let mapView = MKMapView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        restaurantLongitude = restaurantInfo.coordinates!.longitude
        restaurantLatitude = restaurantInfo.coordinates!.latitude
        var restaurantAnnotation : MKPointAnnotation{
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(restaurantLatitude!, restaurantLongitude!)
            annotation.title = restaurantInfo.name
            return annotation
        }
//        var currLocation = CLLocation(latitude: currLatitude, longitude: currLongitude)
//        var restaurantLocation = CLLocation(latitude: restaurantLatitude, longitude: restaurantLongitude)
//        var distance = currLocation.distance(from: restaurantLocation)
        mapView.addAnnotations([restaurantAnnotation])
        mapView.showAnnotations(mapView.annotations, animated: true)

        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(currLatitude, currLongitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.delegate = self
        showDirections()
    }
    
    func showDirections()
    {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(currLatitude!, currLongitude!)))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(restaurantLatitude!, restaurantLongitude!)))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = blue
        self.navigationItem.title = restaurantInfo.name
        
        super.viewWillAppear(animated)

        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 88
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

extension DirectionsViewController : MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = view.tintColor
        renderer.lineWidth = 1.5
        return renderer
    }
}
