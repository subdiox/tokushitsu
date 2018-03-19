//
//  StartupViewController.swift
//  Dr.Tokushitsu
//
//  Created by subdiox on 2017/03/11.
//  Copyright © 2017年 com.gmail.ooka.dev. All rights reserved.
//

import UIKit

class StartupViewController : UIViewController {
    
    var didAgree: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "agree" {
            didAgree = true
            saveUserDefaults()
        }
    }
    
    func saveUserDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(didAgree, forKey: "didAgree")
        userDefaults.synchronize()
    }
}
