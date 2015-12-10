//
//  CurrentIssueDetailViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-28.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import CoreData

class CurrentIssueDetailViewController: UIViewController {
    
    @IBOutlet weak var currentIssueNavigationItem: UINavigationItem!
    
    @IBOutlet weak var currentIssueDetailWebView: UIWebView!
    
    @IBOutlet weak var currentIssueDetailScrollView: UIScrollView!
    
    var currentIssueArticleTitleThroughSegue: String?
    var currentIssueAuthorThroughSegue: String?
    var currentIssueTimeStampThroughSegue: Int?
    var currentIssueArticleContentThroughSegue: String?
    var currentIssueNodeIDThroughSegue: Int?
    var currentIssueIssueIndexThroughSegue: String?
    var currentIssueVolumeIndexThroughSegue: String?

    @IBOutlet weak var currentIssueDetailHeadlineLabel: UILabel!
    @IBOutlet weak var currentIssueDetailAuthorLabel: UILabel!
    @IBOutlet weak var currentIssueDetailPublishDateLabel: UILabel!
        
    @IBOutlet weak var showCommentsBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var showCommentsButton: UIView!

    @IBOutlet weak var currentIssueWebViewHeightConstraint: NSLayoutConstraint!
    
    var observing = false
    
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentIssueDetailWebView.scrollView.scrollEnabled = false
        currentIssueDetailWebView.delegate = self
        
        self.dateFormatter.dateFormat = "dd/MM/yy"
        
        // Inserting the selected currentIssue's title
        currentIssueNavigationItem.title = ""
        
        // "Swipe from left edge" recognizer
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        currentIssueDetailHeadlineLabel.text = currentIssueArticleTitleThroughSegue
        currentIssueDetailAuthorLabel.text! = currentIssueAuthorThroughSegue!
        
            /*
        let timeStampDateObject = NSDate(timeIntervalSince1970: NSTimeInterval(self.currentIssueTimeStampThroughSegue))
        let timeStampDateString = dateFormatter.stringFromDate(timeStampDateObject) ?? "Date unknown"
        */
        
        // Allowing webView link previews
        currentIssueDetailWebView.allowsLinkPreview = true
        
//        let URL = NSURL(string: "http://www.apple.com")
//        currentIssueDetailWebView.loadRequest(NSURLRequest(URL: URL!))
        
        currentIssueDetailWebView.dataDetectorTypes = UIDataDetectorTypes.None
        currentIssueDetailWebView.loadHTMLString(currentIssueArticleContentThroughSegue!, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        stopObservingHeight()
    }
    
    func startObservingHeight() {
        let options = NSKeyValueObservingOptions([.New])
        currentIssueDetailWebView.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true
    }
    
    func stopObservingHeight() {
        currentIssueDetailWebView.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
        observing = false
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let keyPath = keyPath else {
            super.observeValueForKeyPath(nil, ofObject: object, change: change, context: context)
            return
        }
        
        switch (keyPath, context) {
        case ("contentSize", &MyObservationContext):
            currentIssueWebViewHeightConstraint.constant = currentIssueDetailWebView.scrollView.contentSize.height
        default:
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }

    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let saveArticleAction = UIPreviewAction(title: "Save", style: .Default) { (action, viewController) -> Void in
            
            self.saveArticleMethod()
            
        }
        
        let shareArticleAction = UIPreviewAction(title: "Share", style: .Default) { (action, viewController) -> Void in
            
            self.shareArticleMethod()
            
        }
        
        return [saveArticleAction]
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .Left) {
            print("Swipe left")
        }
        
        if (sender.direction == .Right) {
            print("Swipe right")
        }
        
    }
    
    @IBAction func saveArticle(sender: UIBarButtonItem) {
        
            saveArticleMethod()
        
    }
    
    func saveArticleMethod() {
        
        // Setting up the entity description
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Article", inManagedObjectContext: managedObjectContext)
        
        let articleToSave = Article(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        articleToSave.articleArticleContent = self.currentIssueArticleContentThroughSegue
        articleToSave.articleAuthor = self.currentIssueAuthorThroughSegue
        articleToSave.articleImageURL = "" // Make sure I include the imageURL once I get the picture view working in Current Issue
        articleToSave.articleIssueNumber = self.currentIssueIssueIndexThroughSegue
        articleToSave.articleTimeStamp = self.currentIssueTimeStampThroughSegue
        articleToSave.articleTitle = self.currentIssueArticleTitleThroughSegue
        articleToSave.articleVolumeNumber = self.currentIssueVolumeIndexThroughSegue
        
        //            var error: NSError?
        
        //            try! managedObjectContext.save()
        //
        //            if let err = error {
        //                print(err.localizedFailureReason)
        //            } else {
        //                print("The article was successfully saved")
        //            }
        
        
        do {
            try managedObjectContext.save()
            NSLog("The article \(articleToSave.articleTitle) was properly saved.")
        } catch {
            NSLog("The article could not be saved.")
            abort()
        }
        
        
        let customIcon = UIImage(named: "Download")
        let articleSavedAlertView = JSSAlertView().show(self, title: "Article saved", text: "Your saved articles are displayed in the 'Saved Articles' tab.", buttonText: "Sweet", color: UIColor.opaqueGoldenWordsYellow(), iconImage: customIcon)
        articleSavedAlertView.addAction(self.closeCallback)
        articleSavedAlertView.setTitleFont("ClearSans-Bold")
        articleSavedAlertView.setTextFont("ClearSans")
        articleSavedAlertView.setButtonFont("ClearSans-Light")
        articleSavedAlertView.setTextTheme(.Light)
        
    }
    
    func closeCallback() {
        
    }
    
    func cancelCallback() {
        
    }

    // Configuring the sharing action with a UIActivityViewController
    @IBAction func shareArticle(sender: UIBarButtonItem) {
    
            shareArticleMethod()
        
    }
    
    func shareArticleMethod() {
        
        let shareActionText = "Check out this awesome article from Golden Words!"
        
        if let correspondingURL = NSURL(string: "http://www.goldenwords.ca/node/\(currentIssueNodeIDThroughSegue!)") {
            
            let objectsToShare = [shareActionText, correspondingURL]
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeOpenInIBooks, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll]
                
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func showCommentsView(sender: AnyObject) {
        
        self.showCommentsButton.tintColor = UIColor.goldenWordsYellow()
        
        let startPoint = CGPoint(x: self.view.frame.width - 128, y: 59)
        let width = self.view.frame.width
//        let height = self.view.frame.height * 0.903
        let height = self.view.frame.height - startPoint.y - 12
        let commentsView = UIView(frame: CGRect(x:0, y: 0, width: width, height: height))
        
        // Configure my commentsView to be a disqusView.
        
        let options = [
            .Type(.Down),
            .CornerRadius(width / 20),
            .AnimationIn(0.3),
            .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.6)),
            .OverlayBlur(UIBlurEffectStyle.Dark),
            .ArrowSize(CGSize(width: 10, height: 10))
        ] as [PopoverOption]
        var popover = Popover(options: options, showHandler: {
            print("showHandler was just activated")
            // Activate
            }, dismissHandler: {
                print("dismissHandler was just activated")
            })
        popover.show(commentsView, point: startPoint)
        self.showCommentsButton.tintColor = UIColor.whiteColor()
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

extension CurrentIssueDetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        print(webView.request?.URLString)
        currentIssueWebViewHeightConstraint.constant = currentIssueDetailWebView.scrollView.contentSize.height
        if (!observing) {
            startObservingHeight()
        }
    }
}