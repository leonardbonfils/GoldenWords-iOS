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
    
    var dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateFormat = "dd/MM/yy"
        
        // Inserting the selected currentIssue's title
        currentIssueNavigationItem.title = "Article"
        
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
        
        currentIssueDetailWebView.dataDetectorTypes = UIDataDetectorTypes.None
        currentIssueDetailWebView.loadHTMLString(currentIssueArticleContentThroughSegue!, baseURL: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func previewActionItems() -> [UIPreviewActionItem] {
        
        enum usedAction {
            case Save
            case Share
        }
        
        var actionType = usedAction.Save // initializing a variable that will tell us which action was used. Initial value is Save.
        
        let saveArticleAction = UIPreviewAction(title: "Save", style: .Default) { (action, viewController) -> Void in
            /* Save the article to the device's storage permanently */
            
        }
        
        let shareArticleAction = UIPreviewAction(title: "Share", style: .Default) { (action, viewController) -> Void in
            actionType = usedAction.Share
            
        }
        
        if actionType == usedAction.Save {
//            self.saveArticle(saveArticleAction)
        } else if actionType == usedAction.Share {
            // Share the article, open the share UIActivityViewController view.
        }

        return [saveArticleAction, shareArticleAction]
        
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
        
        let shareActionText = "Check out this awesome article from Golden Words!"
        
            if let correspondingURL = NSURL(string: "http://www.goldenwords.ca/node/\(currentIssueNodeIDThroughSegue!)") {
                
                let objectsToShare = [shareActionText, correspondingURL]
                let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                activityViewController.excludedActivityTypes = [UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeOpenInIBooks, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll]
                
                self.presentViewController(activityViewController, animated: true, completion: nil)
                
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
