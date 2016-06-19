//
//  UnlabelLoadingView.swift
//  Unlabel
//
//  Created by Zaid Pathan on 19/06/16.
//  Copyright © 2016 Unlabel. All rights reserved.
//

import UIKit

class UnlabelLoadingView: UIView {
    
    static let sharedInstance = UnlabelLoadingView()
    
    var shimmeringLabel:FBShimmeringView?
    var shimmeringImage:FBShimmeringView?
    
    override func drawRect(rect: CGRect) {
        addVisualEffect(rect)
        addShimmeringImageAndLabel()
    }
    
    func start(onView:UIView){
        onView.addSubview(self)
        backgroundColor = UIColor.clearColor()
        translatesAutoresizingMaskIntoConstraints = false
        addConstraintWithVF(self,onView: onView, visualFormat: "H:|[view]|",views: ["view":self])
        addConstraintWithVF(self,onView: onView, visualFormat: "V:|[view]|",views: ["view":self])
    }
    
    func addVisualEffect(rect:CGRect){
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        visualEffectView.frame = rect
        addSubview(visualEffectView)
    }
    
    func addShimmeringImageAndLabel(){
        func addShimmeringImage(){
            if shimmeringImage == nil{
                shimmeringImage = FBShimmeringView(frame: CGRectMake(0, 0, 126, 126))
                if let shimmeringImageObj = shimmeringImage{
                    let unlabelLogo = UIImageView(image: UIImage(named: "logo_black"))
                    unlabelLogo.frame = CGRectMake(0, 0, 126, 126)
                    shimmeringImageObj.center = center
                    shimmeringImageObj.center.y = center.y - 50
                    shimmeringImageObj.contentView = unlabelLogo
                    shimmeringImageObj.shimmering = true
                    shimmeringImageObj.shimmeringAnimationOpacity = 0.1
                    addSubview(shimmeringImageObj)
                }
            }
        }
        
        func addShimmeringLabel(){
            if shimmeringLabel == nil{
                shimmeringLabel = FBShimmeringView(frame: CGRectMake(0, 0, 126, 126))
                if let shimmeringLabelObj = shimmeringLabel{
                    let label = UILabel(frame:CGRectMake(0, 0, 126, 20))
                    label.text = "Loading..."
                    label.textAlignment = NSTextAlignment.Center
                    shimmeringLabelObj.center = center
                    shimmeringLabelObj.center.y = (shimmeringImage?.center.y)! + ((shimmeringImage?.frame.size.height)!/2) + 20
                    shimmeringLabelObj.contentView = label
                    shimmeringLabelObj.shimmering = true
                    shimmeringLabelObj.shimmeringAnimationOpacity = 0.1
                    addSubview(shimmeringLabelObj)
                }
            }
        }
        
        addShimmeringImage()
        addShimmeringLabel()
    }
    
    func addConstraintWithVF(view:UIView,onView:UIView,visualFormat:String,views:[String:AnyObject]){
        onView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: NSLayoutFormatOptions(rawValue: 0), metrics: [:], views: views))
    }

    func stop(fromView:UIView){
        for subView in fromView.subviews{
            if subView.isKindOfClass(UnlabelLoadingView){
                subView.removeFromSuperview()
            }
        }
    }
}
