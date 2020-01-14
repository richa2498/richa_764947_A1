//
//  ViewController.swift
//  richa_764947_A1
//
//  Created by MacStudent on 2020-01-14.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class ViewController:  UIViewController,CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var direction: UIButton!
    var coordinate : CLLocationCoordinate2D!
    @IBOutlet weak var mapView: MKMapView!
    var locatioManager = CLLocationManager()
       var address = ""
    
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            
            locatioManager.delegate = self
            mapView.delegate = self
            locatioManager.desiredAccuracy = kCLLocationAccuracyBest
            locatioManager.requestWhenInUseAuthorization()
            locatioManager.startUpdatingLocation()
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(onTap))
            mapView.addGestureRecognizer(doubleTap)
        }
        
    @IBAction func show_route(_ sender: Any) {
          showDirection(destination:coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //getting users location
        let userLoaction : CLLocation = locations[0]
        
        let lat = userLoaction.coordinate.latitude
        let long = userLoaction.coordinate.longitude
        
        let latDelta:CLLocationDegrees = 0.05
        let longDelta:CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        let loaction = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let region = MKCoordinateRegion(center: loaction, span: span)
        mapView.setRegion(region, animated: true)
        
        print(userLoaction)
   
            
        }
    
    func showDirection(destination : CLLocationCoordinate2D){
        let souceCordinate = mapView.annotations[0].coordinate
             
             let soucePlaceMark = MKPlacemark(coordinate: souceCordinate)
             let destPlaceMark = MKPlacemark(coordinate: destination)
             
             let sourceItem = MKMapItem(placemark: soucePlaceMark)
             let destItem = MKMapItem(placemark: destPlaceMark)
             
             let destinationRequest = MKDirections.Request()
             destinationRequest.source = sourceItem
             destinationRequest.destination = destItem
             destinationRequest.transportType = .automobile
//             destinationRequest.requestsAlternateRoutes = true
             
             let directions = MKDirections(request: destinationRequest)
             directions.calculate { (response, error) in
                 guard let response = response else {
                     if let error = error {
                         print("Something is wrong :(")
                     }
                     return
                 }
                 
               let route = response.routes[0]
                print(route)
                self.mapView.addOverlay(route.polyline)
                print("hi")
            //  self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                 
             }
    }
        
    
        
    
    @objc func onTap(gestureRecognizer : UIGestureRecognizer){
        
      if gestureRecognizer.state == .ended{
          
                 let destination_loaction = gestureRecognizer.location(in: mapView)
                   coordinate = mapView.convert(destination_loaction, toCoordinateFrom: mapView)
                      let annotation = MKPointAnnotation()
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: 0, timestamp: Date())) { (placemark, error) in
                           
                           if let error = error{
                               print(error)
                           }else{
                               
                               if let placemark = placemark?[0]{
                                  
                                   self.address = ""
                                   if placemark.name != nil{
                                       self.address = placemark.name!
                                   }
                               }
                           }
                       }
                       
                         annotation.title = address
                         annotation.coordinate = coordinate
                         mapView.addAnnotation(annotation)
       
        
    }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
     
        if overlay is  MKPolyline{
         
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .blue
        render.lineWidth = 5.0
        return render
    }
        return MKOverlayRenderer()
    
        }

        
}
