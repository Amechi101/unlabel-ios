//
//  UnlabelExtensions.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 27/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import Foundation

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: replacement, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    
    func encodedURL()->String{
        if let encodedURL = self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()){
            return encodedURL
        }else{
            return ""
        }
    }

}


extension CALayer {
    func borderUIColor() -> UIColor? {
        return borderColor != nil ? UIColor(CGColor: borderColor!) : nil
    }
    
    func setBorderUIColor(color: UIColor) {
        borderColor = color.CGColor
    }
}

extension Array where Element : Equatable {
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}


extension UITableView {
   func removeMargines() {
      self.layoutMargins = UIEdgeInsetsZero
      self.preservesSuperviewLayoutMargins = false
      self.separatorInset = UIEdgeInsetsZero
   }
}

extension UITableViewCell {
   func removeMargines() {
      self.layoutMargins = UIEdgeInsetsZero
      self.preservesSuperviewLayoutMargins = false
      self.separatorInset = UIEdgeInsetsZero
   }
}
