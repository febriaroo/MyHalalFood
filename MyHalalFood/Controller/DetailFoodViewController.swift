//
//  DetailFoodViewController.swift
//  MyHalalFood
//
//  Created by Febria Roosita Dwi on 8/6/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import UIKit
import MapKit

class DetailFoodViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        println("cancel")
    }
    
    @IBAction func callInfoDetailClicked(sender: AnyObject) {
        println("Kepencet!!")
    }
    @IBOutlet weak var myView: UIView!
    @IBAction func getDirectionClicked(sender: AnyObject) {
        openMapForPlace(restaurantName, venueLat: restaurantLocation.latitude, venueLng: restaurantLocation.longitude)
    }
    
    @IBOutlet weak var restaurantImage: UIImageView!
    
    // data-data
    var myresto: myResto!
    var imgURL:NSURL!
    var imgURLRating:NSURL!
    var restaurantName: String!
    var restaurantAddress: String!
    var restaurantLocation: CLLocationCoordinate2D!
    
    var pm: CLPlacemark!
    
    let locationManager = CLLocationManager()
    
    var myDestination: MKPlacemark!
    
    // Variable for the distance of maps
    let regionRadius: CLLocationDistance = 1000
    
    // Variable for get the Restaurant List
    var businesses: [Restaurant]!
    
    // direction
    var directionku: [String]!

    
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var restaurantMap: MKMapView!
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var businessImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if restaurantName != nil {
        nameLabel.text = restaurantName
        addressLabel.text = restaurantAddress
        var stringku = "\(imgURLRating)"
            
        //rounded image
            self.businessImage.layer.borderWidth = 1
            self.businessImage.layer.masksToBounds = false
            self.businessImage.layer.borderColor = UIColor.clearColor().CGColor
            self.businessImage.layer.cornerRadius = self.businessImage.frame.height/2
            self.businessImage.clipsToBounds = true
            
        let aString: String = "This is my string"
        let newString = stringku.stringByReplacingOccurrencesOfString("ms.jpg", withString: "348s.jpg", options: NSStringCompareOptions.LiteralSearch, range: nil)
            println(newString)
            
        myView.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
            
            if Reachability.isConnectedToNetwork() == true {
                println("Internet connection OK")
                //show image
                showImageRatingFromYelp(imgURL)
                showBusinessImageRatingFromYelp(NSURL(string: newString))
                
                //get UserLocation
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestWhenInUseAuthorization()
                self.restaurantMap.showsUserLocation = true
                //self.restaurantMap.userLocation.title = "I'm Here!"
                self.locationManager.startUpdatingLocation()
                
                self.locationManager.delegate = self
                self.restaurantMap.delegate = self
                
                //let heightku = bawah.frame.origin.y
                //businessView.frame = CGRectMake(bawah.frame.width/2, heightku, 128, 128)
                
                
                let navBackgroundImage:UIImage! = UIImage(named: "testing")
                
            } else {
                println("Internet connection FAILED")
                var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showImageRatingFromYelp(imgUrl: NSURL!)
    {
        let request: NSURLRequest = NSURLRequest(URL: imgUrl)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    self.ratingImage.image = UIImage(data: data)
                    
                }
        })
    }
    func showBusinessImageRatingFromYelp(imgUrl: NSURL!)
    {
        
        let request: NSURLRequest = NSURLRequest(URL: imgUrl)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    self.businessImage.image = UIImage(data: data)
                }
        })
        
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
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
       // openMapForPlace(restaurantName, venueLat: restaurantLat, venueLng: restaurantLong)
    }
    // MARK: GetRestaurantDataFromYelp
    
    func getData(location_lat: String!, location_long: String!) {
        let restaurantPosition = customAnnotation()
                restaurantPosition.setCoordinate(self.restaurantLocation)
                restaurantPosition.title = self.restaurantName
                restaurantPosition.subtitle = self.restaurantAddress
                
                //                    coordinate: , title: business.businessName, subtitle:
                self.restaurantMap.viewForAnnotation(restaurantPosition)
                self.restaurantMap.addAnnotation(restaurantPosition)
                var coordinateBusiness = CLLocation(latitude:self.restaurantLocation.latitude, longitude: self.restaurantLocation.longitude)
                self.centerMapOnLocation(restaurantLocation)
                
                
            
                self.myDestination = MKPlacemark(coordinate: self.restaurantLocation, addressDictionary: nil)
                let destMKMap = MKMapItem(placemark: self.myDestination)!
                
                var directionRequest:MKDirectionsRequest = MKDirectionsRequest()
                
                directionRequest.setSource(MKMapItem.mapItemForCurrentLocation())
                
                directionRequest.setDestination(destMKMap)
                var dir: MKDirections!
                dir = MKDirections(request: directionRequest)
                
                dir.calculateDirectionsWithCompletionHandler() {
                (response:MKDirectionsResponse!, error:NSError!) in
                if response == nil {
                    println(error)
                    return
                }
                
                println("got directions")
                let route = response.routes[0] as! MKRoute
                var poly = route.polyline
                
                
                self.restaurantMap.addOverlay(poly)
                
            }
        
    }

    
    // Function to show the error if it failed.
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error nih :( " + error.localizedDescription)
    }
    
    // Function for center the location (Radius)
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
            500, 500)
        
        restaurantMap.setRegion(coordinateRegion, animated: true)
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
        var mapItem = MKMapItem(placemark: myDestination)
        mapItem.name = "\(venueName)"
        mapItem.openInMapsWithLaunchOptions(options)
        
        //self.businessView.image = UIImage(data:)
    }
}

