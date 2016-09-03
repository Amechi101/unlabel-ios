//
//  GlossaryController.swift
//  Unlabel
//
//  Created by jasmin on 03/09/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class GlossaryController: UIViewController {
   
   @IBOutlet weak var IBlblNavBarTitle: UILabel!
   @IBOutlet weak var IBtableGlossary: UITableView!
   
   var arGlossaryValues:[JSON] = []
   var categoryStyleType:CategoryStyleEnum!

   
    override func viewDidLoad() {
        super.viewDidLoad()
      setUpTableView()
      
      var _title:String?
      if categoryStyleType == CategoryStyleEnum.Category {
         _title = categoryStyleType.description + " glossary".uppercaseString
      } else {
         _title = categoryStyleType.description + " glossary".uppercaseString
      }
      
      IBlblNavBarTitle.text = _title
      IBlblNavBarTitle.textAlignment = .Center
      IBlblNavBarTitle.font = UIFont(name: "Neutraface2Text-Demi", size: 16)
      
      IBtableGlossary.registerNib(UINib(nibName: "GlossaryCell", bundle: nil), forCellReuseIdentifier: "GlossaryCell")
      
       self.IBtableGlossary.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   private func setUpTableView() {
      IBtableGlossary.dataSource = self
      IBtableGlossary.delegate = self
      IBtableGlossary.rowHeight = UITableViewAutomaticDimension
      IBtableGlossary.estimatedRowHeight = 100
      IBtableGlossary.separatorStyle = .None
   }
   
   
   @IBAction func IBActionClose(sender: AnyObject) {
      self.navigationController?.popViewControllerAnimated(true)
   }

}


// MARK:- TableView Delegates and Datasource

extension GlossaryController: UITableViewDelegate , UITableViewDataSource {
   
   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      return UITableViewAutomaticDimension
   }
   
   func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
      let cell = tableView.dequeueReusableCellWithIdentifier("GlossaryCell", forIndexPath: indexPath) as! GlossaryCell

       cell.configureCell( arGlossaryValues[indexPath.row] )
      
      return cell
   }
   
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      return arGlossaryValues.count
   }

}
