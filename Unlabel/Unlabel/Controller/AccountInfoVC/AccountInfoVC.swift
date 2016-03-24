//
//  AccountInfoVC.swift
//  Unlabel
//
//  Created by Zaid Pathan on 25/03/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class AccountInfoVC: UITableViewController {
    
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
extension AccountInfoVC{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}


//
//MARK:- IBAction Methods
//
extension AccountInfoVC{
    
    @IBAction func IBActionBack(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}


//
//MARK:- Custom Methods
//
extension AccountInfoVC{
    
    /**
     Setup UI on VC Load.
     */
    func setupOnLoad(){
        
    }
}
