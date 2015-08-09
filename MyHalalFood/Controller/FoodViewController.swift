//
//  FoodViewController.swift
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
import RESideMenu

class FoodViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    //direction
    var dir : MKDirections!
    var poly : MKPolyline!
    
    // tabel view
    
    @IBOutlet weak var myTable: UITableView!
   
    
    //search variable
    var searchActive : Bool = false
    var filtered:[String] = []
    
    // Other Items
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    var myDestination: MKPlacemark!
    var mapOn = true
    var listOn = false
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Variable for the distance of maps
    let regionRadius: CLLocationDistance = 1000
    
    // Variable for get the Restaurant List
    var businesses: [Restaurant]!
    
    // direction
    var directionku: [String]!
    
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
        list.hidden = true
        
        searchBar.delegate = self
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
            
            
            let navBackgroundImage:UIImage! = UIImage(named: "testing")
            
        } else {
            println("Internet connection FAILED")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
       
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapmap: MKMapView!
    @IBOutlet weak var list: UITableView!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            NSLog("Popular selected")
            //show popular view
            mapmap.hidden = false
            list.hidden = true
            mapOn = true
            listOn = false
        case 1:
            NSLog("History selected")
            //show history view
            mapmap.hidden = true
            list.hidden = false
            mapOn = false
            listOn = true
            myTable.reloadData()
        default:
            break;
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "calloutTapped:")
        view.addGestureRecognizer(tapGesture)
    }
    
    func calloutTapped(gestureRecognizer: UIGestureRecognizer) {
        searchActive = false
        if let annotation = self.mapView.selectedAnnotations[0] as? customAnnotation {
            var newProgramVar = myResto()
            println("IT clicked!!")
            
            if let ann = self.mapView.selectedAnnotations[0] as? customAnnotation {
                println("\(ann.getID())")
                println("\(ann.getbusinessUrl())")
                println("\(ann.getbusinessUrlRating())")
                println("\(ann.coordinate)")
            }
            
            let vc = DetailFoodViewController(nibName: "DetailFoodViewController", bundle: nil)
            self.performSegueWithIdentifier("detailFoodViewController", sender: self)
        }
        
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
//    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
//        openMapForPlace(restaurantName, venueLat: restaurantLat, venueLng: restaurantLong)
//    }
    
    // MARK: GetRestaurantDataFromYelp
    
    func getData(location_lat: String!, location_long: String!) {
        
        var concatLocation = "" + location_lat + "," + location_long
        
        Restaurant.getRealDataFromYelp("", sort: .Distance, location: concatLocation, category: ["halal"]) { (Restaurant: [Restaurant]!, error: NSError!) -> Void in
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
                restaurantPosition.setID(business.businessId)
                restaurantPosition.setbusinessUrl(business.businessUrl)
                restaurantPosition.setbusinessUrlRating(business.businessImageUrl)
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
                
                
                i++
                
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
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    

    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //change subject of search
        searchDataYelp(searchText)
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("search bar clicked!")
        searchActive = false;
    }
    func searchDataYelp(cari: String!)
    {
        let annotationsToRemove = self.mapView.annotations.filter { $0 !== self.mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
        let loc = "\(self.mapView.userLocation.coordinate.latitude),\(self.mapView.userLocation.coordinate.longitude)"
        Restaurant.getRealDataFromYelp(cari, sort: .Distance, location: loc, category: ["halal"]) { (Restaurant: [Restaurant]!, error: NSError!) -> Void in
            self.businesses = Restaurant
            
            var businessCount: Int = Restaurant.count
            var i:Int = 0
            
            for business in Restaurant {
                let restaurantPosition = customAnnotation()
                restaurantPosition.setCoordinate( CLLocationCoordinate2DMake(business.businessCoordinateLatitude, business.businessCoordinateLongitude))
                restaurantPosition.setID(business.businessId)
                restaurantPosition.setbusinessUrl(business.businessUrl)
                restaurantPosition.setbusinessUrlRating(business.businessImageUrl)
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
    
    
    // annotation
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is customAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinColor = .Purple
            pinAnnotationView.draggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            let deleteButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
            deleteButton.frame.size.width = 44
            deleteButton.frame.size.height = 44
            deleteButton.backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
            deleteButton.setImage(UIImage(named: "detail"), forState: .Normal)
            
            pinAnnotationView.leftCalloutAccessoryView = deleteButton
            
            return pinAnnotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        searchActive = false
        if let annotation = view.annotation as? customAnnotation {
            var newProgramVar = myResto()
            println("IT clicked!!")
            
            if let ann = self.mapView.selectedAnnotations[0] as? customAnnotation {
                println("\(ann.getID())")
                println("\(ann.getbusinessUrl())")
                println("\(ann.getbusinessUrlRating())")
                println("\(ann.coordinate)")
            }
            
            let vc = DetailFoodViewController(nibName: "DetailFoodViewController", bundle: nil)
        self.performSegueWithIdentifier("detailFoodViewController", sender: self)
            
//            let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("DetailFoodViewController") as? DetailFoodViewController
//            self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a variable that you want to send

        
        // Create a new variable to store the instance of PlayerTableViewController
        searchBar.endEditing(true)
        let destinationVC = segue.destinationViewController as! DetailFoodViewController
        if let ann = self.mapView.selectedAnnotations[0] as? customAnnotation {
            println("\(ann.getID())")
            println("\(ann.getbusinessUrl())")
            println("\(ann.getbusinessUrlRating())")
            println("\(ann.coordinate)")
            destinationVC.imgURL = ann.getbusinessUrl()
            destinationVC.imgURLRating = ann.getbusinessUrlRating()
            /*
            var restaurantName: String!
            var restaurantAddress: String!
            var restaurantLocation: CLLocation!
            */
            
            destinationVC.restaurantName = ann.title
            destinationVC.restaurantAddress = ann.subtitle
            destinationVC.restaurantLocation = ann.coordinate
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resto", forIndexPath: indexPath) as! customFoodTableViewCell
        
        let annotationsToRemove = self.mapView.annotations.filter { $0 !== self.mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
        let loc = "\(self.mapmap.userLocation.coordinate.latitude),\(self.mapmap.userLocation.coordinate.longitude)"
        Restaurant.getRealDataFromYelp("Restaurant", sort: .Distance, location: loc, category: ["halal"]) { (Restaurant: [Restaurant]!, error: NSError!) -> Void in
            self.businesses = Restaurant
            
            var businessCount: Int = Restaurant.count
            var i:Int = 0
            
            for myresto in Restaurant {
                
                cell.foodAddressLabel.text = myresto.businessAddress
                cell.foodNameLabel.text = myresto.businessName
                
                
            }
        }
        println()
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("seribu")
        return 8
    }
    func getFotoFromYelp(myURL: NSURL!, mycell: UIImageView?)
    {
        let request: NSURLRequest = NSURLRequest(URL: myURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                   // mycell.image = UIImage(data: data,scale: 1)
                   
                    
                }
        })

    }
    
}
class myResto: NSObject{
    var businessId : String!
    var businessName : String!
    var businessImage : String!
    var businessCoordinateLongitude : Double!
    var businessCoordinateLatitude : Double!
    var businessUrl : NSURL!
    var businessImageUrl : NSURL!
    var businessPhone : String!
    var businessAddress : String!
}
    


