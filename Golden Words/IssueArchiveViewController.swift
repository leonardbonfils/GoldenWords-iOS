//
//  IssueArchiveTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Instructions

class IssueArchiveViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    // MARK: - Sets for JSON objects
    
    var volumeAndIssueNumbersObjects = NSMutableOrderedSet(capacity: 1000)
    
    var coverPictureObjects = NSMutableOrderedSet(capacity: 1000)
    
    var temporarySpecificIssueObjects = NSMutableOrderedSet(capacity: 1000)
    var specificIssueObjects = NSMutableOrderedSet(capacity: 1000)
    
    // MARK: Other variables/constants
    
    var revealViewControllerIndicator : Int = 0
    
    let imageCache = NSCache()
    
    var populatingVolumeAndIssueNumbers = false
    var populatingSpecificIssueObjects = false
    
    var loadingIndicator = UIActivityIndicatorView()
    
//    var donePopulatingVolumeAndIssueNumbers = false
//    var donePopulatingCoverPictureObjectsAndSpecificIssueObjects = false
    
//    let coachMarksController = CoachMarksController()
//    
//    let pointOfInterest = UIView()
    
    @IBOutlet var carousel: iCarousel!
    
    // MARK: - General functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()

        // Hamburger button configuration
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 280
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Issue Archive"
        
        self.loadingIndicator.backgroundColor = UIColor.goldenWordsYellow()
        self.loadingIndicator.hidesWhenStopped = true
        self.loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.loadingIndicator.color = UIColor.goldenWordsYellow()
        self.loadingIndicator.center = self.view.center
        self.view.bringSubviewToFront(self.loadingIndicator)
        
        populateVolumeAndIssueNumbers()
        
//        if donePopulatingVolumeAndIssueNumbers {
            populateCoverPictureObjectsAndSpecificIssueObjects()
//        }
        
        // Configuring the iCarousel
//        carousel.dataSource = self
//        carousel.delegate = self
        carousel.type = .InvertedTimeMachine
//        carousel.reloadData()
        
        
        /*
        // Configuring the coach marks controller
        self.coachMarksController.datasource = self
        self.coachMarksController.overlayBlurEffectStyle = UIBlurEffectStyle.Dark
        self.coachMarksController.allowOverlayTap = true
        
        var coachMark = coachMarksController.coachMarkForView(self.view.viewWithTag(1)) {
            (frame: CGRect) -> UIBezierPath in
            return UIBezierPath(rect: frame)
        }
        
        */
    }

    override func viewDidAppear(animated: Bool) {
//        UIView.animateWithDuration(0.3, animations: {
//            self.view.subviews[1].alpha = 0
//        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closeCallback() {
        
    }
    
    func cancelCallback() {
        
    }
    
    // MARK: - Populating objects from JSON
    
    func populateVolumeAndIssueNumbers() {
        
//        donePopulatingVolumeAndIssueNumbers = false
        
        if populatingVolumeAndIssueNumbers {
            return
        }
        
        populatingVolumeAndIssueNumbers = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var topLevelArrayIndex = 0 // index used to iterate through the array of volumes.
        var issueArrayIndex = 0 // index used to iterate through the array of issues.
        
        Alamofire.request(.GET, "http://goldenwords.ca/api/get/volume_and_issue_numbers").responseJSON() { response in
            if let JSON = response.result.value {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                    
                    if (JSON .isKindOfClass(NSArray)) {
                        
                        for volumeCollection in JSON as! [Dictionary<String,AnyObject>] { // volumeCollection is the set with the volume # and the array of issue numbers
                            
                            if let volumeAndIssueNumbersObject: VolumeAndIssueNumberElement = VolumeAndIssueNumberElement(volumeNumber: "50", issueNumber: "01", randomID: 0) {
                                
                                if let volumeNumber = JSON[topLevelArrayIndex]["Volume"] as? String {
                                    
                                    let issuesArray = JSON[topLevelArrayIndex]["Issues"] as? [String]
                                    
                                    for issue in issuesArray! {
                                        
                                        issueArrayIndex = 0
                                        
                                        if let issuesObject = JSON[topLevelArrayIndex]["Issues"] as? [String] {
                                            if let issueNumber = issuesObject[issueArrayIndex] as? String {
                                                volumeAndIssueNumbersObject.volumeNumber = volumeNumber
                                                volumeAndIssueNumbersObject.issueNumber = issueNumber
                                                
                                                issueArrayIndex = issueArrayIndex+1
                                                self.volumeAndIssueNumbersObjects.addObject(volumeAndIssueNumbersObject)
                                                }
                                            }
                                        }
                                    }
                                }
                            
                        topLevelArrayIndex = topLevelArrayIndex+1
                            
                        }
                    }
                    
                    self.populatingVolumeAndIssueNumbers = false
                }
            } else {
                
                let customIcon = UIImage(named: "Danger")
                let downloadErrorAlertView = JSSAlertView().show(self, title: "Download failed", text: "Please connect to the Internet and try again.", buttonText:  "OK", color: UIColor.redColor(), iconImage: customIcon)
                downloadErrorAlertView.addAction(self.closeCallback)
                downloadErrorAlertView.setTitleFont("ClearSans-Bold")
                downloadErrorAlertView.setTextFont("ClearSans")
                downloadErrorAlertView.setButtonFont("ClearSans-Light")
                downloadErrorAlertView.setTextTheme(.Light)
                
            }
        }
        // Indicate that we are done populating the volume and issue numbers into the volumeAndIssueNumbersObjects array
        
//        donePopulatingVolumeAndIssueNumbers = true
        
    }
    
    func populateCoverPictureObjectsAndSpecificIssueObjects() {
        
//        donePopulatingCoverPictureObjectsAndSpecificIssueObjects = false
        
        if populatingSpecificIssueObjects {
            return
        }
        
        populatingSpecificIssueObjects = true
        
        for object in volumeAndIssueNumbersObjects {
            
            let volumeAndIssueNumbersObject = object as! VolumeAndIssueNumberElement
            
            let volume = volumeAndIssueNumbersObject.volumeNumber
            let issue = volumeAndIssueNumbersObject.issueNumber
            
            Alamofire.request(GWNetworking.Router.SpecificIssue(Int(volume)!, Int(issue)!)).responseJSON() { response in
                if let JSON = response.result.value {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                        
                        if (JSON .isKindOfClass(NSDictionary)) {
                            
                            for node in JSON as! Dictionary<String, AnyObject> {
                                
                                let nodeIDValue = node.0
                                var lastItem : Int = 0
                                
                                if let specificIssueElement : IssueElement = IssueElement(title: "Another GW archive...", nodeID: 0, timeStamp: 1442239200, imageURL: "http://goldenwords.ca/sites/all/themes/custom/gw/logo.png", author: "Staff", issueNumber: "Issue # error", volumeNumber: "50", articleContent: "Looks like the server is acting up again!", coverImageInteger: "init", coverImage: UIImage()) {
                                    
                                    specificIssueElement.title = node.1["title"] as! String
                                    specificIssueElement.nodeID = Int(nodeIDValue)!
                                    
                                    let timeStampString = node.1["revision_timestamp"] as! String
                                    specificIssueElement.timeStamp = Int(timeStampString)!
                                    
                                    if let imageURL = node.1["image_url"] as? String {
                                        specificIssueElement.imageURL = imageURL
                                    }
                                    
                                    if let author = node.1["author"] as? String {
                                        specificIssueElement.author = author
                                    }
                                    
                                    if let issueNumber = node.1["issue_int"] as? String {
                                        specificIssueElement.issueNumber = issueNumber
                                    }
                                    
                                    if let volumeNumber = node.1["volume_int"] as? String {
                                        specificIssueElement.volumeNumber = volumeNumber
                                    }
                                    
                                    if let articleContent = node.1["html_content"] as? String {
                                        specificIssueElement.articleContent = articleContent
                                    }
                                    
                                    if let coverImageInteger = node.1["cover_image"] as? String {
                                        specificIssueElement.coverImageInteger = coverImageInteger
                                        
                                        // If the node is a cover image node, add that to the set of cover picture objects
                                        if specificIssueElement.coverImageInteger == "1" {
                                            self.coverPictureObjects.addObject(specificIssueElement)
                                        }
                                    }
                                        // Once the cover image node has been securely added to coverPictureObjects, make sure article content isn't
                                    if specificIssueElement.articleContent.characters.count > 60 {
                                        lastItem = self.temporarySpecificIssueObjects.count
                                        self.temporarySpecificIssueObjects.addObject(specificIssueElement)
                                    }
                                    
                                    let indexPaths = (lastItem..<self.temporarySpecificIssueObjects.count).map {
                                        NSIndexPath(forItem: $0, inSection: 0) }
                                    }
                                }
                            
                            // Sorting with decreasing timestamp from top to bottom.
                            let timestampSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
                            self.temporarySpecificIssueObjects.sortUsingDescriptors([timestampSortDescriptor])

                            }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.specificIssueObjects = self.temporarySpecificIssueObjects
                            self.populatingSpecificIssueObjects = false
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        }
                    }
                } else {
                    
                    let customIcon = UIImage(named: "Danger")
                    let downloadErrorAlertView = JSSAlertView().show(self, title: "Download failed", text: "Please connect to the Internet and try again.", buttonText:  "OK", color: UIColor.redColor(), iconImage: customIcon)
                    downloadErrorAlertView.addAction(self.closeCallback)
                    downloadErrorAlertView.setTitleFont("ClearSans-Bold")
                    downloadErrorAlertView.setTextFont("ClearSans")
                    downloadErrorAlertView.setButtonFont("ClearSans-Light")
                    downloadErrorAlertView.setTextTheme(.Light)
                    
                }
            }
        }
        
//        donePopulatingCoverPictureObjectsAndSpecificIssueObjects = true
        
    }
    
    // MARK: - iCarousel configuration
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
//        return coverPictureObjects.count
        return 5
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        
//        if donePopulatingCoverPictureObjectsAndSpecificIssueObjects {
        
        var itemView: customCarouselItemView
        var imageView: UIImageView
        
//        itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        itemView.image = UIImage(named: "reveal Image")
//        itemView.contentMode = .Center

        if (view == nil) {
            itemView = customCarouselItemView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//            itemView.image = UIImage(named: "Round portrait")
            itemView.contentMode = .Center
            
            imageView = UIImageView(frame: itemView.bounds)
            imageView.backgroundColor = UIColor.clearColor()
            imageView.tag = 1
            itemView.addSubview(imageView)
            
        } else {
            itemView = view as! customCarouselItemView;
            imageView = itemView.viewWithTag(1) as! UIImageView!
        }
        
//        imageView.image = UIImage(named: "Round portrait")
        

        itemView.request?.cancel()
        
        let coverPictureAtIndex = coverPictureObjects.objectAtIndex(index) as! IssueElement // problem is here
        let imageURL = coverPictureAtIndex.imageURL
        
        if var image = self.imageCache.objectForKey(imageURL) as? UIImage {
            
            itemView.image = image
            
        } else {
            
            itemView.image = nil
            itemView.request = Alamofire.request(.GET, imageURL).responseImage() { response in
                if var image = response.result.value {
                    self.imageCache.setObject(response.result.value!, forKey: imageURL)
                    if itemView.image == nil {
                        itemView.image = image
                }
            }
        }
    }
        
        return itemView
            
//        } else {
//            
//            return UIImageView(image: UIImage(named: "Round portrait"))
//        }
}
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .Spacing) {
            return value * 1.1
        }
        
        return value
    }
    
    // MARK: - CoachMarks configuration
    
    /*
    
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        return coachMarksController.coachMarkForView(self.view.viewWithTag(1))
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
        
        coachViews.bodyView.hintLabel.text = "Drag the button to view previous issues"
        coachViews.bodyView.hintLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        coachViews.bodyView.hintLabel.textColor = UIColor.blackColor()
        
        coachViews.bodyView.nextLabel.text = "Got it!"
        coachViews.bodyView.nextLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        coachViews.bodyView.nextLabel.textColor = UIColor.goldenWordsYellow()
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    */
}