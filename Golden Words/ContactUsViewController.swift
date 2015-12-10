//
//  ContactUsViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import MessageUI
import Instructions
import CoreData

class ContactUsViewController: UIViewController, MFMailComposeViewControllerDelegate, CoachMarksControllerDataSource, CoachMarksControllerDelegate {

    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    let coachMarksController = CoachMarksController()

    let pointOfInterest = UIView()
    
    var displayCoachMarksViews = true
    
    override func viewWillAppear(animated: Bool) {
        
//        doOrDoNotThereIsNoTry()
        
//        do {
//            
//            // Initializing Core Data variables to prevent the CoachMarksView's from showing up multiple times.
//            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//            let entityDescription = NSEntityDescription.entityForName("Indicator", inManagedObjectContext: managedObjectContext)
//            
//            let request = NSFetchRequest()
//            request.entity = entityDescription
//            
//            var objects = try managedObjectContext.executeFetchRequest(request)
//            
//            if objects[0]
//            
//        }
//        
//        catch {
//            
//            
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
//        if firstLaunch {
//            print("Not first launch")
//        } else {
//            print("First launch, setting NSUserDefault.")
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
//        }
        
        // Configuring the coachMarksController
        self.coachMarksController.datasource = self
        self.coachMarksController.overlayBlurEffectStyle = UIBlurEffectStyle.Dark
        self.coachMarksController.allowOverlayTap = true
        
        var coachMark = coachMarksController.coachMarkForView(self.view.viewWithTag(1)) {
            (frame: CGRect) -> UIBezierPath in
            return UIBezierPath(rect: frame)
        }
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.goldenWordsYellow()
        
        // Configuring the revealViewcontroller
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        /* initializing all email addresses used to be contacted by users */
        
        let editorsEmailAddress = "eds@goldenwords.net"
        let businessManagerEmailAddress = "biz@goldenwords.net"
        let developerEmailAddress = "appledevelopment@goldenwords.net"
        let operationsManagerEmailAddress = "ops@goldenwords.net"
        
        /* Initializing the URLs corresponding to each email address */
        let editorsURL = NSURL(string: "mailto:\(editorsEmailAddress)")
        let businessManagerURL = NSURL(string: "mailto:\(businessManagerEmailAddress)")
        let developerURL = NSURL(string: "mailto:\(developerEmailAddress)")
        let operationsManagerURL = NSURL(string: "mailto:\(operationsManagerEmailAddress)")
        
    }
    
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        
        // Checking whether or not the coachMarksView should be displayed
//        doOrDoNotThereIsNoTry()
//        
//        if displayCoachMarksViews {
//            return 1
//        } else {
//            return 0
//        }
        
        return 0
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        return coachMarksController.coachMarkForView(self.view.viewWithTag(1))
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
    
        coachViews.bodyView.hintLabel.text = "Tap on any button to email GW Staff"
        coachViews.bodyView.hintLabel.font = UIFont(name: "AvenirNext-Medium", size: 14)
        coachViews.bodyView.hintLabel.textColor = UIColor.blackColor()
        
        coachViews.bodyView.nextLabel.text = "Got it!"
        coachViews.bodyView.nextLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 14)
        coachViews.bodyView.nextLabel.textColor = UIColor.goldenWordsYellow()
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    
    @IBAction func editorsContactButton(sender: UIButton) {
        
        var emailTitle = "GW Feedback"
        var messageBody = ""
        var toRecipients = ["eds@goldenwords.net"]
        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(emailTitle)
        mailCompose.setMessageBody(messageBody, isHTML: false)
        mailCompose.setToRecipients(toRecipients)
        
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
        addCoachMarksViewIndicatorObjectToDatabase()
    }
    
    @IBAction func businessManagerContactButton(sender: UIButton) {
        
        var emailTitle = "GW Feedback"
        var messageBody = ""
        var toRecipients = ["biz@goldenwords.net"]
        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(emailTitle)
        mailCompose.setMessageBody(messageBody, isHTML: false)
        mailCompose.setToRecipients(toRecipients)
        
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
        addCoachMarksViewIndicatorObjectToDatabase()
    }
    
    
    @IBAction func developerContactButton(sender: UIButton) {
        
        var emailTitle = "GW iPhone App Feedback"
        var messageBody = ""
        var toRecipients = ["appledevelopment@goldenwords.net"]
        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(emailTitle)
        mailCompose.setMessageBody(messageBody, isHTML: false)
        mailCompose.setToRecipients(toRecipients)
        
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
        addCoachMarksViewIndicatorObjectToDatabase()
    }
    
    @IBAction func operationsManagerContactButton(sender: UIButton) {
        
        var emailTitle = "GW Feedback"
        var messageBody = ""
        var toRecipients = ["ops@goldenwords.net"]
        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(emailTitle)
        mailCompose.setMessageBody(messageBody, isHTML: false)
        mailCompose.setToRecipients(toRecipients)
        
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
        addCoachMarksViewIndicatorObjectToDatabase()
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
//        self.coachMarksController.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
//        if firstLaunch {
//            self.coachMarksController.startOn(self)
//        } else {
//            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
//        }
//    }
    
    // Add an object to the CoreData database if the coachMarksView is called
    func addCoachMarksViewIndicatorObjectToDatabase() {
        
        // Initializing Core Data variables to prevent the CoachMarksView's from showing up multiple times.
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Indicator", inManagedObjectContext: managedObjectContext)
        
        // Creating an object that will be saved to the CoreData "Indicator" database. As soon as the objects.count > 0 for this particular "Indicator" entity, we will stop displaying coachMarksViewController so that the user does not see the coachMarksView multiple times.
        let coachMarksViewIndicatorObject = Indicator(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        coachMarksViewIndicatorObject.someAttribute = true
        
        do {
            try managedObjectContext.save()
            NSLog("The coachMarksViewIndicatorObject was saved. The database's objects.count for the 'Indicator' entity is not greater than 0. coachMarksView's will no longer be displayed")
        } catch {
            NSLog("The coachMarksIndicatorObject could not be saved.")
            abort()
        }
        
        
    }
    
    func doOrDoNotThereIsNoTry() {
        
        do {
            
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            let entityDescription = NSEntityDescription.entityForName("Indicator", inManagedObjectContext: managedObjectContext)
            
            let request = NSFetchRequest()
            request.entity = entityDescription
            
            var objects = try managedObjectContext.executeFetchRequest(request)
            
            if objects.count > 0 {
                
                self.displayCoachMarksViews = false
                
            } else {
                
                self.displayCoachMarksViews = true
                
            }
            
        } catch {
            print("CoreData fetch request failed")
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
