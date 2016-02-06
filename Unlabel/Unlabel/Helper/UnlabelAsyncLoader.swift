//
//  UnlabelAsyncLoader.swift
//  Unlabel
//
//  Created by ZAID PATHAN on 07/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import Foundation
import UIKit

class UnlabelAsyncLoader{

    let cache = NSCache()
    
    class var sharedLoader: UnlabelAsyncLoader{
        struct Static {
            static let instance:UnlabelAsyncLoader = UnlabelAsyncLoader()
        }
        return Static.instance
    }
    
    func downloadImage(forURL forURL:String, completionHandler:(image:UIImage?,url:String)->()){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            let data:NSData? = self.cache.objectForKey(forURL) as? NSData
            
            if let imageData = data{
                let image = UIImage(data: imageData)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(image: image, url: forURL)
                })
                return
            }
            
            let downloadTask:NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: forURL)!, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                if let _ = error{
                    completionHandler(image: nil, url: forURL)
                }
                
                if let downloadedData = data{
                    let image = UIImage(data: downloadedData)
                    self.cache.setObject(data!, forKey: forURL)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(image: image, url: forURL)
                    })
                    return
                }
            })
            downloadTask.resume()
        }
    }
}