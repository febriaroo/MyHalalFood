//
//  RootViewController.swift
//  MyHalalFood
//
//  Created by Febria Roosita Dwi on 8/6/15.
//  Copyright (c) 2015 Febria Roosita Dwi. All rights reserved.
//

import UIKit
import RESideMenu

class RootViewController: RESideMenu, RESideMenuDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func awakeFromNib() {
        
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.LightContent
        self.contentViewShadowColor = UIColor.blackColor();
        self.contentViewShadowOffset = CGSizeMake(0, 0);
        self.contentViewShadowOpacity = 0.6;
        self.contentViewShadowRadius = 12;
        self.contentViewShadowEnabled = true;
        
        self.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AllViewController") as! UIViewController
        self.leftMenuViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailFoodViewController") as! UIViewController
        
    }
    
    // MARK: RESide Delegate Methods
    
    func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        println("This will show the menu")
    }
}
