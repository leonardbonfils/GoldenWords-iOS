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

class ContactUsViewController: UIViewController, MFMailComposeViewControllerDelegate, CoachMarksControllerDataSource, CoachMarksControllerDelegate {

    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)
    
    let coachMarksController = CoachMarksController()

    let pointOfInterest = UIView()
    
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
        
        
        self.navigationController?.navigationBar.barTintColor = goldenWordsYellow
        
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
        
        

        // Do any additional setup after loading the view.
    }
    
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        if NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch") {
            return 0
        } else {
            return 1
        }
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
        coachViews.bodyView.nextLabel.textColor = goldenWordsYellow
        
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    
    @IBAction func editorsContactButton(sender: UIButton) {
        
        var emailTitle = "GW feedback"
        var messageBody = ""
        var toRecipients = ["eds@goldenwords.net"]
        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(emailTitle)
        mailCompose.setMessageBody(messageBody, isHTML: false)
        mailCompose.setToRecipients(toRecipients)
        
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
    }
    
    @IBAction func businessManagerContactButton(sender: UIButton) {
        var emailTitle = "GW feedback"
        var messageBody = ""
        var toRecipients = ["biz@goldenwords.net"]
        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(emailTitle)
        mailCompose.setMessageBody(messageBody, isHTML: false)
        mailCompose.setToRecipients(toRecipients)
        
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
    }
    
    
    @IBAction func developerContactButton(sender: UIButton) {
        var emailTitle = "GW iPhone app feedback"
        var messageBody = ""
        var toRecipients = ["appledevelopment@goldenwords.net"]
        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(emailTitle)
        mailCompose.setMessageBody(messageBody, isHTML: false)
        mailCompose.setToRecipients(toRecipients)
        
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
    }
    
    @IBAction func operationsManagerContactButton(sender: UIButton) {
        var emailTitle = "GW feedback"
        var messageBody = ""
        var toRecipients = ["ops@goldenwords.net"]
        var mailCompose: MFMailComposeViewController = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(emailTitle)
        mailCompose.setMessageBody(messageBody, isHTML: false)
        mailCompose.setToRecipients(toRecipients)
        
        self.presentViewController(mailCompose, animated: true, completion: nil)
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.coachMarksController.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("FirstLaunch")
        if firstLaunch {
            self.coachMarksController.startOn(self)
        } else {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FirstLaunch")
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
