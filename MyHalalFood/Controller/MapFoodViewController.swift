//
//  MapFoodViewController.swift
//  MyHalalFood
//
//  Created by Febria Roosita Dwi on 8/7/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation // For Get the user location
import MapKit // For Showing Maps
import CoreLocation // For Get the user location
import MapKit // For Showing Maps
import Darwin // For random number

class MapFoodViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            firstView.hidden = false
            secondView.hidden = true
        case 1:
            firstView.hidden = true
            secondView.hidden = false
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstView.hidden = false
        secondView.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
