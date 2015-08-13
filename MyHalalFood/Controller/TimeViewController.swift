//
//  TimeViewController.swift
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
import CoreMotion // for track user interaction

class TimeViewController:  UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate  {
    var dataFromAPI : MKUserLocation!
    let locationManager = CLLocationManager()
    
    //JSON DATA
    var jsonResult: NSDictionary!
    var timeArray: [String] = []
    var nameTimeArray: [String] = ["Fajr","Shurooq","Dhuhr", "Asr", "Maghrib", "Isha","Cupertino"]
    
    @IBOutlet weak var bigTableView: UITableView!
   
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var arahKiblatImageView: UIImageView!
    
    var timer = NSTimer()
    
    // track arah
    var motionManager = CMMotionManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
       
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "wallpaper.png")!)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0,
            target: self,
            selector: Selector("tick"),
            userInfo: nil,
            repeats: true)
        
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.gyroUpdateInterval = 0.2
        
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler : { ( accelerometerData : CMAccelerometerData! , error : NSError! ) -> Void in
            self.outputAccelerometerData(accelerometerData.acceleration)
            if error != nil {
                println("\(error)")
            }
            
        })
        motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue(), withHandler: { (gyroData: CMGyroData!, error: NSError! ) -> Void in
        self.outputRotationData(gyroData.rotationRate)
            if error != nil {
                println("\(error)")
            }
            
        })
        // Do any additional setup after loading the view.
    }
    func outputRotationData(rotationRate: CMRotationRate!)
    {
        UIView.animateWithDuration(1.0, animations: {
             self.arahKiblatImageView.transform = CGAffineTransformMakeRotation(CGFloat(rotationRate.y))
            
        })
        
    }
    func outputAccelerometerData(accelerometerData: CMAcceleration)
    {
    
    }
    func tick(){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        timeLabel.text = NSDateFormatter.localizedStringFromDate(NSDate(),
            dateStyle: .MediumStyle,
            timeStyle: .MediumStyle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getDataFromAPI(imgUrl: NSURL!)
    {
        let request: NSURLRequest = NSURLRequest(URL: imgUrl)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    // throwing an error on the line below (can't figure out where the error message is)
                    if(data.length != 0)
                    {
                        self.jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                    }
                    //println("qibla_direction")
                    //println(self.jsonResult["qibla_direction"])
                    var qibla_direction: CGFloat = CGFloat(self.jsonResult["qibla_direction"]!.floatValue)
                    UIView.animateWithDuration(1.0, animations: {
                        self.arahKiblatImageView.transform = CGAffineTransformMakeRotation(qibla_direction)
                    })
                    let myJson: NSArray = self.jsonResult["items"] as! NSArray
                    if let aStatus = myJson[0] as? NSDictionary{
                        //println(aStatus)
                        self.timeArray.append(aStatus["fajr"] as! String)
                        self.timeArray.append(aStatus["dhuhr"] as! String)
                        self.timeArray.append(aStatus["asr"] as! String)
                        self.timeArray.append(aStatus["maghrib"] as! String)
                        self.timeArray.append(aStatus["isha"] as! String)
                        self.timeArray.append(aStatus["shurooq"] as! String)
                        self.bigTableView.reloadData()
                    }
                }
        })
    }
    func showImageRatingFromYelp(imgUrl: NSURL!)
    {
        let request: NSURLRequest = NSURLRequest(URL: imgUrl)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    //self.ratingImage.image = UIImage(data: data)
                    
                }
        })
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil)
            {
                println("Error: " + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0
            {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            }
            else
            {
                println("Error with the data.")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark)
    {
        
        self.locationManager.stopUpdatingLocation()
        // do something with myData
        
        let long = placemark.location.coordinate.longitude
        let lat = placemark.location.coordinate.latitude
        let url = "http://muslimsalat.com/\(lat),\(long).json?683402182c50892c21b19f65fe3b2b78"
        var usrLocation = NSURL(string: url)
        getDataFromAPI(usrLocation)
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
        println("Error: " + error.localizedDescription)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GenreCell", forIndexPath: indexPath) as! myCustomTableViewCell
        if(timeArray.count != 0){
        cell.time.text = timeArray[indexPath.row]
        }
        else {
        cell.time.text = ""
        }
        cell.nameTime.text = nameTimeArray[indexPath.row]
        println("ROW: \(indexPath.row)")
        println(timeArray)
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
