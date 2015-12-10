//
//  EditorialsDetailViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-26.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import CoreData

var MyObservationContext = 0

class EditorialsDetailViewController: UIViewController {
    
    @IBOutlet weak var editorialDetailNavigationItem: UINavigationItem!

    @IBOutlet weak var editorialDetailWebView: UIWebView!
    
    @IBOutlet weak var editorialDetailScrollView: UIScrollView!
    
    var editorialTitleThroughSegue: String?
    var editorialAuthorThroughSegue: String?
    var editorialNodeIDThroughSegue: Int?
    var editorialTimeStampThroughSegue: Int?
    var editorialVolumeIndexThroughSegue: String?
    var editorialIssueIndexThroughSegue: String?
    var editorialArticleContentThroughSegue: String?

    @IBOutlet weak var editorialDetailHeadlineLabel: UILabel!
    @IBOutlet weak var editorialDetailAuthorLabel: UILabel!
    @IBOutlet weak var editorialDetailVolumeAndIssueLabel: UILabel!
    
    @IBOutlet weak var editorialWebViewHeightConstraint: NSLayoutConstraint!
    
    var observing = false
    
    @IBOutlet weak var showCommentsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editorialDetailWebView.scrollView.scrollEnabled = false
        editorialDetailWebView.delegate = self
        
        editorialDetailNavigationItem.title = ""
        
        /* Swipe recognizers for left and right edges (can be used later). */
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        editorialDetailHeadlineLabel.text = editorialTitleThroughSegue
        editorialDetailAuthorLabel.text = editorialAuthorThroughSegue
        editorialDetailVolumeAndIssueLabel.text = "V.\(editorialVolumeIndexThroughSegue!) - Issue \(editorialIssueIndexThroughSegue!)"
        
        // Allowing webView link previews
        editorialDetailWebView.allowsLinkPreview = true
        
        /*
        let justifiedArticleContent = "<p style=\"text-align:justify\"> \(editorialArticleContentThroughSegue) </p>"
        */
        
        editorialDetailWebView.dataDetectorTypes = UIDataDetectorTypes.None
        editorialDetailWebView.loadHTMLString(editorialArticleContentThroughSegue!, baseURL: nil)

    }
    
    deinit {
        stopObservingHeight()
    }
    
    func startObservingHeight() {
        let options = NSKeyValueObservingOptions([.New])
        editorialDetailWebView.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true
    }
    
    func stopObservingHeight() {
        editorialDetailWebView.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
        observing = false
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let keyPath = keyPath else {
            super.observeValueForKeyPath(nil, ofObject: object, change: change, context: context)
            return
        }
        
        switch (keyPath, context) {
        case ("contentSize", &MyObservationContext):
            editorialWebViewHeightConstraint.constant = editorialDetailWebView.scrollView.contentSize.height
        default:
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
/*
    func webViewDidFinishLoad(webView: UIWebView!) {
        
        var webViewFrame: CGRect = editorialDetailWebView.frame
        webViewFrame.size.height = 1
        editorialDetailWebView.frame = webViewFrame
        var fittingSize: CGSize = (editorialDetailWebView.sizeThatFits(CGSizeZero))
        webViewFrame.size = fittingSize
        
        editorialDetailWebView.frame = webViewFrame
        
        var webViewHeight = editorialDetailWebView.frame.size.height

    }
*/


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func saveArticle(sender: UIBarButtonItem) {
        
        self.saveArticleMethod()
   
    }
    
    func saveArticleMethod() {
        
        // Setting up the entity description
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Article", inManagedObjectContext: managedObjectContext)
        
        let articleToSave = Article(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        articleToSave.articleArticleContent = self.editorialArticleContentThroughSegue
        articleToSave.articleAuthor = self.editorialAuthorThroughSegue
        articleToSave.articleImageURL = ""
        articleToSave.articleIssueNumber = self.editorialIssueIndexThroughSegue
        articleToSave.articleTitle = self.editorialTitleThroughSegue
        articleToSave.articleVolumeNumber = self.editorialVolumeIndexThroughSegue
        articleToSave.articleTimeStamp = self.editorialTimeStampThroughSegue
        
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
        
        self.shareArticleMethod()
       
    }
    
    func shareArticleMethod() {
        
        let shareActionText = "Check out this awesome article from Golden Words!"
        
        if let correspondingURL = NSURL(string: "http://www.goldenwords.ca/node/\(editorialNodeIDThroughSegue!)") {
            
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
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .Left) {
            print("Swipe left")
      
        }
        
        if (sender.direction == .Right) {
                print("Swipe right")
          
        }
        
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

extension EditorialsDetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        print(webView.request?.URLString)
        editorialWebViewHeightConstraint.constant = editorialDetailWebView.scrollView.contentSize.height
        if (!observing) {
            startObservingHeight()
        }
    }
}
