//
//  LeftMenuVC.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 25/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

enum LeftMenuItems:Int{
    case Discover = 0
    case Following = 1
    case Settings = 2
}

//
//MARK:- LeftMenuVC Protocols
//
protocol LeftMenuVCDelegate{
    func didSelectRowAtIndexPath(indexPath: NSIndexPath)
    func willCloseChildVC(childVCName:String)
}


class LeftMenuVC: UIViewController {

//
//MARK:- IBOutlets, constants, vars
//
    @IBOutlet weak var IBtblLeftMenu: UITableView!
    @IBOutlet weak var IBlblUserName: UILabel!
    
    
    private let arrTitles = ["DISCOVER","FOLLOWING","SETTINGS"]
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
        leftMenuCell.textLabel?.textColor = MEDIUM_GRAY_TEXT_COLOR
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
        IBlblUserName.text = UnlabelHelper.getDefaultValue(sDISPLAY_NAME)
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
                self.delegate?.willCloseChildVC(S_ID_LEFT_MENU_VC)
        }
    }

    
}


