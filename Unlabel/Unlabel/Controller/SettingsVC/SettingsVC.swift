//
//  SettingsVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 23/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {

    //
    //MARK:- IBOutlets, constants, vars
    //
    
    
    //
    //MARK:- VC Lifecycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
       setupOnLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//MARK:- UITableViewDelegate Methods
//
extension SettingsVC{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 3{
            UnlabelHelper.logout()
        }
    }
}


//
//MARK:- IBAction Methods
//
extension SettingsVC{
    
    @IBAction func IBActionBack(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}


//
//MARK:- Custom Methods
//
extension SettingsVC{
    
    /**
     Setup UI on VC Load.
     */
    func setupOnLoad(){
        
    }
}
