//
//  UnlabelStaticList.swift
//  Unlabel
//
//  Created by SayOne Technologies on 23/02/17.
//  Copyright © 2017 Unlabel. All rights reserved.
//

import UIKit

class UnlabelStaticList: NSObject, NSCoding {
 
  var uId:String = String()
  var uName:String = String()
  var isSelected: Bool
  
  init(uId: String, uName: String, isSelected: Bool) {
    self.uId = uId
    self.uName = uName
    self.isSelected = isSelected
  }
  
  // MARK: NSCoding
  required convenience init?(coder decoder: NSCoder) {
    guard let uId = decoder.decodeObject(forKey: "uId") as? String,
      let uName = decoder.decodeObject(forKey: "uName") as? String
      else { return nil }
    self.init(uId: uId,
      uName: uName,isSelected: decoder.decodeBool(forKey: "isSelected") )
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.uId, forKey: "uId")
    aCoder.encode(self.uName, forKey: "uName")
    aCoder.encode(self.isSelected, forKey: "isSelected")
  }
}
