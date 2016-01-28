//
//  LeftMenuVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 25/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

//
//MARK:- LeftMenuVC Protocols
//
protocol LeftMenuVCDelegate{
    func didSelectRowAtIndexPath(indexPath: NSIndexPath)
}


class LeftMenuVC: UIViewController {

//
//MARK:- IBOutlets, constants, vars
//
    @IBOutlet weak var IBtblLeftMenu: UITableView!
    private let arrTitles = ["WHAT'S NEW","DISCOVER","FOLLOWING","FAVORITE PRODUCTS","SETTINGS"]
    var delegate:LeftMenuVCDelegate?
    
    
//
//MARK:- VC Lifecycle
//
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIOnLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//
//MARK:- UITableViewDelegate Methods
//
extension LeftMenuVC:UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        close()
    }
}

//
//MARK:- UITableViewDataSource Methods
//
extension LeftMenuVC:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let leftMenuCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        leftMenuCell.textLabel?.text = arrTitles[indexPath.row]
        leftMenuCell.textLabel?.textColor = UnlabelHelper.getMediumGrayTextColor()
        leftMenuCell.textLabel?.font = UnlabelHelper.getNeutraface2Text(style: FONT_STYLE_DEMI, size: 14)
        
        return leftMenuCell
    }
}

//
//MARK:- IBAction Methods
//
extension LeftMenuVC{
    @IBAction func IBActionClose(sender: AnyObject) {
     close()
    }
}



//
//MARK:- Custom Methods
//
extension LeftMenuVC{
    /**
     Setup UI on VC Load.
     */
    func setupUIOnLoad(){
        IBtblLeftMenu.tableFooterView = UIView()
    }

    /**
     Remove self from parentViewController
     */
    func close(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.alpha = 0
            self.view.frame.origin.x = -SCREEN_WIDTH
            }) { (value:Bool) -> Void in
                self.willMoveToParentViewController(nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }

    
}


