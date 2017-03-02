//
//  FilterViewController.swift
//  Unlabel
//
//  Created by SayOne Technologies on 16/01/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit
import SwiftyJSON

class FilterViewController: UIViewController {
  
  
  //MARK: -  IBOutlets,vars,constants
  @IBOutlet weak var IBButtonMenswear: UIButton!
  @IBOutlet weak var IBButtonWomenswear: UIButton!
  @IBOutlet weak var IBButtonBrandCategory: UIButton!
  @IBOutlet weak var IBButtonStyle: UIButton!
  @IBOutlet weak var IBButtonLocation: UIButton!
  @IBOutlet weak var IBSearchBar: UISearchBar!
  
  //MARK: -  View lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
   // self.navigationController?.isNavigationBarHidden = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(_ animated: Bool) {
     self.navigationController?.isNavigationBarHidden = true
  }
  //MARK: -  IBAction methods
  
  @IBAction func IBActionStoreType(_ sender: Any) {
    UnlabelAPIHelper.sharedInstance.getBrandStoreType({ (arrCountry:[FilterModel], meta: JSON) in
      print(meta)
    }, failed: { (error) in
    })

  }
  @IBAction func IBActionCategory(_ sender: Any) {
      let _presentController = self.storyboard?.instantiateViewController(withIdentifier: "FilterListController") as! FilterListController
      _presentController.categoryStyleType = .category
      _presentController.arSelectedValues = []
      
      
      let _navFilterList = UINavigationController(rootViewController: _presentController)
      _navFilterList.isNavigationBarHidden = true
      
      self.present(_navFilterList, animated: true, completion: nil)
    
    
  }
  
  @IBAction func IBActionStyle(_ sender: Any) {

    let _presentController = storyboard?.instantiateViewController(withIdentifier: "FilterListController") as! FilterListController
    _presentController.categoryStyleType = .style
    _presentController.arSelectedValues = []
    
    
    let _navFilterList = UINavigationController(rootViewController: _presentController)
    _navFilterList.isNavigationBarHidden = true
    
    self.present(_navFilterList, animated: true, completion: nil)

  }
  @IBAction func IBActionLocation(_ sender: Any) {
    UnlabelAPIHelper.sharedInstance.getBrandLocation({ (arrCountry:[UnlabelStaticList], meta: JSON) in
      print(meta)
    }, failed: { (error) in
    })
    let _presentController = storyboard?.instantiateViewController(withIdentifier: "FilterListController") as! FilterListController
    _presentController.categoryStyleType = .style
    _presentController.arSelectedValues = []
    
    
    let _navFilterList = UINavigationController(rootViewController: _presentController)
    _navFilterList.isNavigationBarHidden = true
    
    self.present(_navFilterList, animated: true, completion: nil)
  }
  @IBAction func IBActionShowFilteredResults(_ sender: Any) {
    
  }
}
extension UIButton{
  func setBorderColor(_ color: UIColor){
    self.layer.borderWidth = 1.0
    self.layer.borderColor = LIGHT_GRAY_BORDER_COLOR.cgColor
  }
}
