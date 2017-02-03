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

        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      //  self.tabBar.barTintColor = UIColor(colorLiteralRed: 69.0/255.0, green: 73.0/255.0, blue: 78.0/255.0, alpha: 1.0)
       UITabBar.appearance().tintColor = UIColor(colorLiteralRed: 69.0/255.0, green: 73.0/255.0, blue: 78.0/255.0, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
