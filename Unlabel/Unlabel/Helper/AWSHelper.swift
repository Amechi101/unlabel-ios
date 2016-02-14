//
//  AWSHelper.swift
//  Unlabel
//
//  Created by Zaid Pathan on 12/02/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit
import AWSS3

class AWSHelper: NSObject {
    
    /**
     AWS call to upload images
     */
    class func uploadImageWithCompletion(imageName imageName:String,imageURL:NSURL,uploadPathKey:String,completionHandler: (task:AWSS3TransferUtilityUploadTask, error:NSError?)->()){
        
        //defining bucket and upload file name
        let S3BucketName: String = S3_BUCKET_NAME
        let S3UploadKeyName: String = "public/\(uploadPathKey)/\(imageName)"
        
        
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.uploadProgress = {(task: AWSS3TransferUtilityTask, bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) in
            dispatch_async(dispatch_get_main_queue(), {
                let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
                NSLog("Progress is: %f",progress)
            })
        }
        
        var uploadCompletionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        uploadCompletionHandler = { (task, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(task: task,error:error)
            })
        }
        
        let transferUtility = AWSS3TransferUtility.defaultS3TransferUtility()
        
        transferUtility.uploadFile(imageURL, bucket: S3BucketName, key: S3UploadKeyName, contentType: "image/png", expression: expression, completionHander: uploadCompletionHandler).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                NSLog("Error: %@",error.localizedDescription);
            }
            if let exception = task.exception {
                NSLog("Exception: %@",exception.description);
            }
            if let _ = task.result {
                NSLog("Upload Starting!")
            }
            
            return nil;
        }
    }
    
    /**
     AWS call to download images
     */
    class func downloadImageWithCompletion(forImageName imageName:String,uploadPathKey:String,completionHandler:(AWSS3TransferUtilityDownloadTask, NSURL?, NSData?, NSError?)->()){
        
        var completionHandlerObj: AWSS3TransferUtilityDownloadCompletionHandlerBlock?
        
        let S3BucketName: String = S3_BUCKET_NAME
        let S3DownloadKeyName: String = "public/\(uploadPathKey)/\(imageName)"
        
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.downloadProgress = {(task: AWSS3TransferUtilityTask, bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) in
            dispatch_async(dispatch_get_main_queue(), {
                let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
                print("Progress is: \(progress)")
            })
        }
        
        completionHandlerObj = { (task, location, data, error) -> Void in
            completionHandler(task, location, data, error)
        }
        
        let transferUtility = AWSS3TransferUtility.defaultS3TransferUtility()
        transferUtility.downloadToURL(nil, bucket: S3BucketName, key: S3DownloadKeyName, expression: expression, completionHander: completionHandlerObj).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            if let exception = task.exception {
                print("Exception: \(exception.description)")
            }
            if let _ = task.result {
                print("Download Starting!")
            }
            return nil;
        }
    }

    /**
     AWS call to delete image
     */
    class func deleteImageWithCompletion(inBucketName bucketName:String,imageName:String,deletePathKey:String,completion:(task: AWSTask)->()){
        
         let S3DeleteKeyName: String = "public/\(deletePathKey)/\(imageName)"

        let awsDeleteRequest = AWSS3DeleteObjectRequest()
        awsDeleteRequest.bucket = bucketName
        awsDeleteRequest.key = S3DeleteKeyName
        
        let s3 = AWSS3.defaultS3()

        s3.deleteObject(awsDeleteRequest).continueWithBlock { (task:AWSTask) -> AnyObject? in
            completion(task: task)
        
            return nil
        }
    }
    
}
