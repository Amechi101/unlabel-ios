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
      self.automaticallyAdjustsScrollViewInsets = false

      var _title:String?
      if categoryStyleType == CategoryStyleEnum.category {
         _title = categoryStyleType.description + " glossary".uppercased()
      } else {
         _title = categoryStyleType.description + " glossary".uppercased()
      }
      
      IBlblNavBarTitle.text = _title
      IBlblNavBarTitle.textAlignment = .center
      IBlblNavBarTitle.font = UIFont(name: "Neutraface2Text-Demi", size: 16)
      
      IBtableGlossary.register(UINib(nibName: "GlossaryCell", bundle: nil), forCellReuseIdentifier: "GlossaryCell")
      
       self.IBtableGlossary.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   fileprivate func setUpTableView() {
      IBtableGlossary.dataSource = self
      IBtableGlossary.delegate = self
      IBtableGlossary.rowHeight = UITableViewAutomaticDimension
      IBtableGlossary.estimatedRowHeight = 100
      IBtableGlossary.separatorStyle = .none
   }
   
   
   @IBAction func IBActionClose(_ sender: AnyObject) {
      _ = self.navigationController?.popViewController(animated: true)
   }

}


// MARK:- TableView Delegates and Datasource

extension GlossaryController: UITableViewDelegate , UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableViewAutomaticDimension
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
      let cell = tableView.dequeueReusableCell(withIdentifier: "GlossaryCell", for: indexPath) as! GlossaryCell

       cell.configureCell( arGlossaryValues[indexPath.row] )
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      return arGlossaryValues.count
   }

}
