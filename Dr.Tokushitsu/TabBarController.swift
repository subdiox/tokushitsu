//
//  FirstViewController.swift
//  Dr.Tokushitsu
//
//  Created by Yuta Ooka on 2016/11/01.
//  Copyright © 2016年 Yuta Ooka. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let all = AllViewController()
        let favorite = FavoriteViewController()
        if (all == viewController) {
            all.tabDidSelect()
        } else if (favorite == viewController) {
            favorite.tabDidSelect()
        }
    }
}

