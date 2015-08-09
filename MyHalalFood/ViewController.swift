//
//  ViewController.swift
//  MyHalalFood
//
//  Created by Febria Roosita Dwi on 8/4/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation // For Get the user location
import MapKit // For Showing Maps
import CoreLocation // For Get the user location
import MapKit // For Showing Maps
import Darwin // For random number
import AddressBook
import SimpleTab


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //direction
    var dir : MKDirections!
    var poly : MKPolyline!
    
    // Other Items
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var myDestination: MKPlacemark!
    
    // Variable for the distance of maps
    let regionRadius: CLLocationDistance = 1000
    
    // Variable for get the Restaurant List
    var businesses: [Restaurant]!
    
    // direction
    var directionku: [String]!
    
    @IBOutlet weak var businessView: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    // PM
    var pm: CLPlacemark!
    
    // show messagebox to shake it
    let actionSheetController: UIAlertView = UIAlertView(title: "Shake now!!", message: "Hi! shake it!", delegate: nil, cancelButtonTitle: "Ok!")
    var countShake = 0
    
    // variable longlat
    var longlat: [String]!
    
    var restaurantName:String!
    var restaurantLong:Double!
    var restaurantLat:Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if Reachability.isConnectedToNetwork() == true {
            println("Internet connection OK")
            //get UserLocation
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.mapView.showsUserLocation = true
            self.mapView.userLocation.title = "I'm Here!"
            self.locationManager.startUpdatingLocation()
            
            self.locationManager.delegate = self
            self.mapView.delegate = self
            //let heightku = bawah.frame.origin.y
            //businessView.frame = CGRectMake(bawah.frame.width/2, heightku, 128, 128)
            
            
            
        } else {
            println("Internet connection FAILED")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
       
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: function to get the Update Location
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                println("ERROR nih! \(error.localizedDescription)")
                return
            }
            
            if placemarks.count > 0 {
                self.pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(self.pm)
                self.locationManager.stopUpdatingLocation()
            } else {
                println("Error with data")
            }
        })
    }
    
    //MARK: Function to show the location data
    func displayLocationInfo(placemarks: CLPlacemark)
    {
        self.locationManager.stopUpdatingLocation()
        
        // println(placemarks.locality)
        // println(placemarks.postalCode)
        // println(placemarks.administrativeArea)
        // println(placemarks.country)
        
        // Show in Maps
        
    }
    
    //Mark: get Restaurant data after get User Location!
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        self.getData("\(userLocation.location.coordinate.latitude)",location_long : "\(userLocation.location.coordinate.longitude)")
    }

    // MARK: GetRestaurantDataFromYelp
    
    func getData(location_lat: String!, location_long: String!) {
        
        var concatLocation = "" + location_lat + "," + location_long
        
        Restaurant.getRealDataFromYelp("mosques", sort: .Distance, location: concatLocation, category: ["mosques"]) { (Restaurant: [Restaurant]!, error: NSError!) -> Void in
            self.businesses = Restaurant
            
            var businessCount: Int = Restaurant.count
            var i:Int = 0
            
            for business in Restaurant {
                //println(business.businessName!)
                //println(business.businessAddress!)
                //println()
                    //show in map
                let restaurantPosition = customAnnotation()
                restaurantPosition.setCoordinate( CLLocationCoordinate2DMake(business.businessCoordinateLatitude, business.businessCoordinateLongitude))
                restaurantPosition.title = business.businessName
                restaurantPosition.subtitle = business.businessAddress
                
                //                    coordinate: , title: business.businessName, subtitle:
                self.mapView.viewForAnnotation(restaurantPosition)
                self.mapView.addAnnotation(restaurantPosition)
                var coordinateBusiness = CLLocation(latitude: business.businessCoordinateLatitude, longitude: business.businessCoordinateLongitude)
                self.centerMapOnLocation(self.mapView.userLocation.location)
                self.restaurantName = business.businessName
                self.restaurantLong = business.businessCoordinateLongitude
                self.restaurantLat = business.businessCoordinateLongitude

                
            }
        }
        println()
    }
    
    // Function to show the error if it failed.
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error nih :( " + error.localizedDescription)
    }
    
    // Function for center the location (Radius)
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            10000, 10000)
        mapView.setRegion(coordinateRegion, animated: true)
    }


    // annotation
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is customAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinColor = .Red
            pinAnnotationView.draggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            
            let deleteButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            deleteButton.frame.size.width = 44
            deleteButton.frame.size.height = 44
            deleteButton.backgroundColor = UIColor.clearColor()
            deleteButton.setImage(UIImage(named: "go"), forState: .Normal)
            
            pinAnnotationView.leftCalloutAccessoryView = deleteButton
            
            return pinAnnotationView
        }
        
        return nil
    }
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "calloutTapped:")
        view.addGestureRecognizer(tapGesture)
    }
    
    func calloutTapped(gestureRecognizer: UIGestureRecognizer) {
        println("kepencet")
        
        let location = self.mapView.selectedAnnotations[0] as! customAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
        
        
        if let annotation = self.mapView.selectedAnnotations[0] as? customAnnotation{
            println("IT clicked!!")
            
            if let ann = self.mapView.selectedAnnotations[0] as? customAnnotation {
                openMapForPlace(ann.title, venueLat: ann.coordinate.latitude,venueLng: ann.coordinate.longitude)
            }
        }
        
    }

    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        //searchActive = false
        println("kepencet")
        
        let location = view.annotation as! customAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)

        
        if let annotation = view.annotation as? customAnnotation {
            var newProgramVar = myResto()
            println("IT clicked!!")
            
            if let ann = self.mapView.selectedAnnotations[0] as? customAnnotation {
                openMapForPlace(ann.title, venueLat: ann.coordinate.latitude,venueLng: ann.coordinate.longitude)
            }
        }
    }
    
    
    func openMapForPlace(venueName:String!, venueLat: Double!, venueLng:Double! ) {
        
        
        var latitute:CLLocationDegrees =  venueLat
        var longitute:CLLocationDegrees = venueLng
        
        let regionDistance:CLLocationDistance = 10000
        var coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        var options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(venueName)"
        mapItem.openInMapsWithLaunchOptions(options)
        
        //self.businessView.image = UIImage(data:)
    }
    // annotation callout info button opens this mapItem in Maps app
    
}

