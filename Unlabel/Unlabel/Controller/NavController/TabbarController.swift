//
//  TabbarController.swift
//  Unlabel
//
//  Created by SayOne Technologies on 05/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       UITabBar.appearance().tintColor = UIColor(colorLiteralRed: 69.0/255.0, green: 73.0/255.0, blue: 78.0/255.0, alpha: 1.0)
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
