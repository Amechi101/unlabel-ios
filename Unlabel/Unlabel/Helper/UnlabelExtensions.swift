//
//  UnlabelExtensions.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 27/01/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import Foundation
import Alamofire

extension String {
  func replace(_ string:String, replacement:String) -> String {
    return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
  }
  
  func removeWhitespace() -> String {
    return self.replace(" ", replacement: "")
  }
  
  func encodedURL()->String{
    if let encodedURL = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
      return encodedURL
    }else{
      return ""
    }
  }
  
}


extension String: ParameterEncoding {
  
  public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
    var request = try urlRequest.asURLRequest()
    request.httpBody = data(using: .utf8, allowLossyConversion: false)
    return request
  }
  
}

extension CALayer {
  func borderUIColor() -> UIColor? {
    return borderColor != nil ? UIColor(cgColor: borderColor!) : nil
  }
  
  func setBorderUIColor(_ color: UIColor) {
    borderColor = color.cgColor
  }
}

extension Array where Element : Equatable {
  mutating func removeObject(_ object : Iterator.Element) {
    if let index = self.index(of: object) {
      self.remove(at: index)
    }
  }
}


extension UITableView {
  func removeMargines() {
    self.layoutMargins = UIEdgeInsets.zero
    self.preservesSuperviewLayoutMargins = false
    self.separatorInset = UIEdgeInsets.zero
  }
}

extension UITableViewCell {
  func removeMargines() {
    self.layoutMargins = UIEdgeInsets.zero
    self.preservesSuperviewLayoutMargins = false
    self.separatorInset = UIEdgeInsets.zero
  }
}



