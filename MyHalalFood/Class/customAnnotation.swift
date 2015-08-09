//
//  customAnnotation.swift
//  Terserah
//
//  Created by Febria Roosita Dwi on 7/20/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBook

class customAnnotation: NSObject, MKAnnotation {
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    func setID(_id: String!)
    {
        self.id=_id
    }
    func getID() -> String
    {
        return id
    }
    func setbusinessUrl(_id: NSURL!)
    {
        self.businessUrl=_id
    }
    func getbusinessUrl() -> NSURL
    {
        if(businessUrl == nil)
        {
            return NSURL(string: "http://www.jordans.com/~/media/Jordans%20Redesign/No-image-found.jpg")!
        }
        return businessUrl

    }
    func setbusinessUrlRating(_id: NSURL!)
    {
        self.businessImageUrl=_id
    }
    func getbusinessUrlRating() -> NSURL
    {
        if(businessImageUrl == nil)
        {
            return NSURL(string: "http://www.jordans.com/~/media/Jordans%20Redesign/No-image-found.jpg")!
        }
        return businessImageUrl
    }
    func setbusinessUrlLoad(_id: NSURL!)
    {
        self.businessUrlLoad=_id
    }
    func getbusinessUrlLoad() -> NSURL
    {
        if(businessUrlLoad == nil)
        {
            return NSURL(string: "http://www.yelp.com")!
        }
        return businessUrlLoad
    }
    
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
    var title: String = ""
    var subtitle: String = ""
    var id:String = ""
    var businessId : String!
    var businessName : String!
    var businessImage : String!
    var businessCoordinateLongitude : Double!
    var businessCoordinateLatitude : Double!
    var businessUrl : NSURL!
    var businessImageUrl : NSURL!
    var businessPhone : String!
    var businessAddress : String!
    var businessUrlLoad : NSURL!
    
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
}