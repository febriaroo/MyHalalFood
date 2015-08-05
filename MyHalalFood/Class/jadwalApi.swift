//
//  jadwalApi.swift
//  MyHalalFood
//
//  Created by Febria Roosita Dwi on 8/5/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import UIKit
// Yelp API Data for Authentification
let jadwalAPIKey = "683402182c50892c21b19f65fe3b2b78"

class jadwalApi: BDBOAuth1RequestOperationManager {
    func get_data_from_url(url:String)
    {
        let httpMethod = "GET"
        let timeout = 15
        let url = NSURL(string: url)
        let urlRequest = NSMutableURLRequest(URL: url!,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15.0)
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(
            urlRequest,
            queue: queue,
            completionHandler: {(response: NSURLResponse!,
                data: NSData!,
                error: NSError!) in
                if data.length > 0 && error == nil{
                    let json = NSString(data: data, encoding: NSASCIIStringEncoding)
                    self.extract_json(json!)
                }else if data.length == 0 && error == nil{
                    println("Nothing was downloaded")
                } else if error != nil{
                    println("Error happened = \(error)")
                }
            }
        )
    }
    func extract_json(data:NSString)
    {
        var parseError: NSError?
        let jsonData:NSData = data.dataUsingEncoding(NSASCIIStringEncoding)!
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &parseError)
        if (parseError == nil)
        {
            if let countries_list = json as? NSArray
            {
                for (var i = 0; i < countries_list.count ; i++ )
                {
                    if let country_obj = countries_list[i] as? NSDictionary
                    {
                        if let country_name = country_obj["country"] as? String
                        {
                            if let country_code = country_obj["code"] as? String
                            {
                                
                            }
                        }
                    }
                }
            }
        }
    }

}
