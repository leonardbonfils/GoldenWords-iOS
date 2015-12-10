//
//  SavedArticlesDetailViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-11-19.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import CoreData

class SavedArticlesDetailViewController: UIViewController {
    
    @IBOutlet weak var savedArticleDetailNavigationItem: UINavigationItem!
    
    @IBOutlet weak var savedArticleDetailWebView: UIWebView!
    
    @IBOutlet weak var savedArticleDetailScrollView: UIScrollView!
    
    var savedArticleTitleThroughSegue: String?
    var savedArticleAuthorThroughSegue: String?
    var savedArticleVolumeIndexThroughSegue: String?
    var savedArticleIssueIndexThroughSegue: String?
    var savedArticleArticleContentThroughSegue: String?
    var savedArticleTimeStampThroughSegue: Int?
    var savedArticleNodeIDThroughSegue: Int?
    var savedArticleRowIndexThroughSegue: Int?
    
    @IBOutlet weak var savedArticleDetailHeadlineLabel: UILabel!
    @IBOutlet weak var savedArticleDetailAuthorLabel: UILabel!
    @IBOutlet weak var savedArticleVolumeAndIssueLabel: UILabel!
    
    @IBOutlet weak var savedArticleWebViewHeightConstraint: NSLayoutConstraint!
    
    var observing = false
    
    @IBOutlet weak var showCommentsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedArticleDetailWebView.scrollView.scrollEnabled = false
        savedArticleDetailWebView.delegate = self
        
        savedArticleDetailNavigationItem.title = ""
        
        /* Swipe recognizers for left and right edges (can be used later). */
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)

        savedArticleDetailHeadlineLabel.text = savedArticleTitleThroughSegue
        savedArticleDetailAuthorLabel.text = savedArticleAuthorThroughSegue
        savedArticleVolumeAndIssueLabel.text = "V.\(savedArticleVolumeIndexThroughSegue!) - Issue \(savedArticleIssueIndexThroughSegue!)"
        
        // Allowing webView link previews
        savedArticleDetailWebView.allowsLinkPreview = true
        
        savedArticleDetailWebView.dataDetectorTypes = UIDataDetectorTypes.None
        savedArticleDetailWebView.loadHTMLString(savedArticleArticleContentThroughSegue!, baseURL: nil)

        // Do any additional setup after loading the view.
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
        savedArticleDetailWebView.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
        observing = true
    }
    
    func stopObservingHeight() {
        savedArticleDetailWebView.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
        observing = false
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let keyPath = keyPath else {
            super.observeValueForKeyPath(nil, ofObject: object, change: change, context: context)
            return
        }
        
        switch (keyPath, context) {
        case ("contentSize", &MyObservationContext):
            savedArticleWebViewHeightConstraint.constant = savedArticleDetailWebView.scrollView.contentSize.height
        default:
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    override func previewActionItems() -> [UIPreviewActionItem] {
        
        let deleteFromSavedArticles = UIPreviewAction(title: "Delete from Saved Articles", style: .Destructive) { (action, viewController) -> Void in
            
//            do {
//                // Setting up Core Data variables
//                let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//                let entityDescription = NSEntityDescription.entityForName("Article", inManagedObjectContext: managedObjectContext)
//                
////                let request = NSFetchRequest()
////                request.entity = entityDescription
////                
////                let predicate = NSPredicate(format: "articleTitle == %@", "\(self.savedArticleTitleThroughSegue)")
////                
////                request.predicate = predicate
////                
////                var objects = try managedObjectContext.executeFetchRequest(request)
//                
//                
//                
//            }
//                
//            catch {
//                
//                print("CoreData fetch request failed.")
//                abort()
//                
//            }
            
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            let entityDescription = NSEntityDescription.entityForName("Article", inManagedObjectContext: managedObjectContext)
            
            
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = entityDescription
            
            let predicate = NSPredicate(format: "articleTitle == %@", "\(self.savedArticleTitleThroughSegue)")
            fetchRequest.predicate = predicate
            
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try managedObjectContext.executeRequest(deleteRequest)
                try managedObjectContext.save()
            } catch {
                print(error)
            }
            
//            savedArticleObjects.removeObjectAtIndex(self.savedArticleRowIndexThroughSegue!-1)
            
        }
        
        return []
        
    }
    
    @IBAction func saveArticle(sender: UIBarButtonItem) {
        
        // Setting up the entity description
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Article", inManagedObjectContext: managedObjectContext)
        
        let articleToSave = Article(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        articleToSave.articleArticleContent = self.savedArticleArticleContentThroughSegue
        articleToSave.articleAuthor = self.savedArticleAuthorThroughSegue
        articleToSave.articleImageURL = ""
        articleToSave.articleIssueNumber = self.savedArticleIssueIndexThroughSegue
        articleToSave.articleTitle = self.savedArticleTitleThroughSegue
        articleToSave.articleVolumeNumber = self.savedArticleVolumeIndexThroughSegue
        articleToSave.articleTimeStamp = self.savedArticleTimeStampThroughSegue
        
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
        
        let shareActionText = "Check out this awesome article from Golden Words!"
        
        if let correspondingURL = NSURL(string: "http://www.goldenwords.ca/node/\(savedArticleNodeIDThroughSegue!)") {
            
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

extension SavedArticlesDetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        print(webView.request?.URLString)
        savedArticleWebViewHeightConstraint.constant = savedArticleDetailWebView.scrollView.contentSize.height
        if (!observing) {
            startObservingHeight()
        }
    }
}