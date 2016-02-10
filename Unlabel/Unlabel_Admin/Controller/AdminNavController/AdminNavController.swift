//
//  AdminNavController.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 26/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class AdminNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == S_ID_LABEL_LIST_VC{
            if let labelListVC:LabelListVC = segue.destinationViewController as? LabelListVC{
                if let adminVC:AdminVC = sender as? AdminVC{
                    if let brand:Brand = adminVC.arrBrandList[adminVC.didSelectIndexPath.row]{
                        labelListVC.selectedBrand = brand
                    }
                }
            }
        }
    }
}
