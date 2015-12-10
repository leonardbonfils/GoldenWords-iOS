//
//  PhotoViewerViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-09-21.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import AlamofireImage

class PhotoViewerViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURLForViewerController: String = ""
    var imageToStore = UIImage()
    
    var photoInfo: PictureElement?
    
    var spinner = UIActivityIndicatorView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    
    var lastZoomScale: CGFloat = 0
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(doubleTapRecognizer)
        
//        self.imageView.image = self.imageToStore
        self.spinner.stopAnimating()
        scrollView.delegate = self
        updateZoom()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor.blackColor()
        self.scrollView.backgroundColor = UIColor.blackColor()
        
        spinner.center = self.view.center
        spinner.color = UIColor.goldenWordsYellow()
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        view.addSubview(spinner)
        
        // Making it snow on Christmas Day!
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.Month.union(NSCalendarUnit.Day).union(NSCalendarUnit.Minute), fromDate: date)
        
        let month = components.month
        let day = components.day
        let hour = components.hour
        
        if (month == 12) && (day == 25) {
            print("It's Christmas Day and we're gonna make it snow!")
            let snowflakeView = SnowflakesView(frame: self.view.frame)
            self.view.addSubview(snowflakeView)
        } else {
            print("It's not Christmas Day and we're going to patiently wait until Dec. 25th to make it snow")
        }
        // End of Christmas Day-specific code
        
        updateZoom()
        updateConstraints()
        
        
//        self.imageView.center = self.scrollView.center
        
        loadPhoto()
    }
    
    func loadPhoto() {
        
        Alamofire.request(.GET, imageURLForViewerController).responseImage { response in
            
            if let image = response.result.value {
                print("image downloaded : \(image)")
                
//                self.imageToStore = image
                self.imageView.image = image
//                                self.imageView.frame = self.scrollView.frame
                //                self.spinner.stopAnimating()
                //                self.centerScrollViewContents()
            }
        }
    }
    
    // Update zoom scale and constraints with animation.
    override func viewWillTransitionToSize(size: CGSize,
        withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
            
            super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
            
            coordinator.animateAlongsideTransition({ [weak self] _ in
                self?.updateZoom()
                }, completion: nil)
    }
    
    func updateConstraints() {
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let viewWidth = scrollView.bounds.size.width
            let viewHeight = scrollView.bounds.size.height
            
            // center image if it is smaller than the scroll view
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding
            
            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding
            
            view.layoutIfNeeded()
        }
    }
    
    // Zoom to show as much image as possible unless image is smaller than the scroll view
    private func updateZoom() {
        if let image = imageView.image {
            var minZoom = min(scrollView.bounds.size.width / image.size.width,
                scrollView.bounds.size.height / image.size.height)
            
            if minZoom > 1 { minZoom = 1 }
            
            scrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            
            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
        }
    }
    
    // UIScrollViewDelegate
    // -----------------------
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

/*
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let savePicture = UIPreviewAction(title: "Save", style: .Default) { (action, viewController) -> Void in
        }
        
        let sharePicture = UIPreviewAction(title: "Share", style: .Default) { (action, viewController) -> Void in
        }
        
        return [savePicture, sharePicture]
    }
*/
    
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Zooming
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer!) {
        let pointInView = recognizer.locationInView(self.imageView)
        self.zoomInZoomOut(pointInView)
    }

    // Zooming function
    func zoomInZoomOut(point: CGPoint!) {
        let newZoomScale = self.scrollView.zoomScale > (self.scrollView.maximumZoomScale/2) ? self.scrollView.minimumZoomScale : self.scrollView.maximumZoomScale
        
        let scrollViewSize = self.scrollView.bounds.size
        
        let width = scrollViewSize.width / newZoomScale
        let height = scrollViewSize.height / newZoomScale
        let x = point.x - (width / 2.0)
        let y = point.y - (height / 2.0)
        
        let rectToZoom = CGRect(x: x, y: y, width: width, height: height)
        
        self.scrollView.zoomToRect(rectToZoom, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
