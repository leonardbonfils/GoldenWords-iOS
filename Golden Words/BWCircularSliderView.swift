//
//  BWCircularSliderView.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-11-09.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

/*

import UIKit

@IBDesignable class BWCircularSliderView: UIView {

    @IBInspectable var startColor:UIColor = UIColor.redColor()
    @IBInspectable var endColor:UIColor = UIColor.blueColor()
    
    #if TARGET_INTERFACE_BUILDER
    override func willMoveToSuperview(newSuperview: UIView?) {
    
    let slider:BWCircularSlider = BWCircularSlider(startColor:self.startColor, endColor:self.endColor, frame: self.bounds)
    self.addSubview(slider)
    
    }
    
    #else
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Build the slider
        let slider:BWCircularSlider = BWCircularSlider(startColor:self.startColor, endColor:self.endColor, frame: self.bounds)
        
        // Attach an Action and a Target to the slider
        slider.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Add the slider as subview of this view
        self.addSubview(slider)
        
//        self.alpha = 0.0
//        self.backgroundColor = UIColor.blueColor()
        
    }
    #endif
    
    func valueChanged(slider:BWCircularSlider){

        // This is where we will be scrolling through the cover pictures in our scroll view (use Alamofire to download the images as the scrolling is happening)
        
        print("Value changed \(slider.angle)")
    }

}

*/