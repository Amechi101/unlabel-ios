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
    var radiusFilter : String = String()
    override func draw(_ rect: CGRect) {
        addVisualEffect(rect)
        addShimmeringImageAndLabel()
    }
    
    func start(_ onView:UIView){
        onView.addSubview(self)
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
        addConstraintWithVF(self,onView: onView, visualFormat: "H:|[view]|",views: ["view":self])
        addConstraintWithVF(self,onView: onView, visualFormat: "V:|[view]|",views: ["view":self])
    }
    
    func addVisualEffect(_ rect:CGRect){
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = rect
        addSubview(visualEffectView)
        bringSubview(toFront: visualEffectView)
    }
    
    func addShimmeringImageAndLabel(){
        func addShimmeringImage(){
            if shimmeringImage == nil{
                shimmeringImage = FBShimmeringView(frame: CGRect(x: 0, y: 0, width: 126, height: 126))
                if let shimmeringImageObj = shimmeringImage{
                    let unlabelLogo = UIImageView(image: UIImage(named: "logo_black"))
                    unlabelLogo.frame = CGRect(x: 0, y: 0, width: 126, height: 126)
                    shimmeringImageObj.center = center
                    shimmeringImageObj.center.y = center.y - 50
                    shimmeringImageObj.contentView = unlabelLogo
                    shimmeringImageObj.isShimmering = true
                    shimmeringImageObj.shimmeringAnimationOpacity = 0.1
                    addSubview(shimmeringImageObj)
                    bringSubview(toFront: shimmeringImageObj)
                }
            }
        }
        
        func addShimmeringLabel(){
            if shimmeringLabel == nil{
                shimmeringLabel = FBShimmeringView(frame: CGRect(x: 0, y: 0, width: 126, height: 126))
                if let shimmeringLabelObj = shimmeringLabel{
                    let label = UILabel(frame:CGRect(x: 0, y: 0, width: 126, height: 20))
                    label.text = "Loading..."
                    label.textAlignment = NSTextAlignment.center
                    shimmeringLabelObj.center = center
                    shimmeringLabelObj.center.y = (shimmeringImage?.center.y)! + ((shimmeringImage?.frame.size.height)!/2) + 20
                    shimmeringLabelObj.contentView = label
                    shimmeringLabelObj.isShimmering = true
                    shimmeringLabelObj.shimmeringAnimationOpacity = 0.1
                    addSubview(shimmeringLabelObj)
                    bringSubview(toFront: shimmeringLabelObj)
                }
            }
        }
        
        addShimmeringImage()
        addShimmeringLabel()
    }
    
    func addConstraintWithVF(_ view:UIView,onView:UIView,visualFormat:String,views:[String:AnyObject]){
        onView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: NSLayoutFormatOptions(rawValue: 0), metrics: [:], views: views))
    }

    func stop(_ fromView:UIView){
        for subView in fromView.subviews{
            if subView.isKind(of: UnlabelLoadingView.self){
                subView.removeFromSuperview()
            }
        }
    }
}
