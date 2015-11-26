//
//  SavedArticlesTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-11-19.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import CoreData

class SavedArticlesTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var savedArticleObjects = NSMutableOrderedSet(capacity: 1000)
    
    let SavedArticlesTableCellIdentifier = "SavedArticlesTableCellIdentifier"
    
    var dateFormatter = NSDateFormatter()
    
    var revealViewControllerIndicator = 0
    
    var cellLoadingIndicator = UIActivityIndicatorView()
    
    override func viewWillAppear(animated: Bool) {
        
        // Populate the saved articles set from the Core Data database.
        populateSavedArticlesFromCoreData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hamburger button configuration
        if self.revealViewController() != nil {
            revealViewControllerIndicator = 1
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 280

        tableView.delegate = self
        tableView.dataSource = self
        
        // Navigation set up
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Saved Articles"
        
        self.dateFormatter.dateFormat = "dd/MM/yy"
        
        tableView.estimatedRowHeight = 50
        
        self.cellLoadingIndicator.backgroundColor = UIColor.goldenWordsYellow()
        self.cellLoadingIndicator.hidesWhenStopped = true
        self.cellLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.cellLoadingIndicator.color = UIColor.goldenWordsYellow()
        self.cellLoadingIndicator.center = self.tableView.center
        self.tableView.addSubview(cellLoadingIndicator)
        self.tableView.bringSubviewToFront(cellLoadingIndicator)
        
        // Checking for 3D Touch Support
        if (traitCollection.forceTouchCapability == .Available) {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return savedArticleObjects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(SavedArticlesTableCellIdentifier, forIndexPath: indexPath) as! SavedArticlesTableViewCell
        
        if let savedArticleObject = savedArticleObjects.objectAtIndex(indexPath.row) as? Article {
            
            if let title = savedArticleObject.valueForKey("articleTitle") as? String {
                cell.savedArticlesHeadlineLabel.text = title
            }
            
            let timeStampDateObject = NSDate(timeIntervalSince1970: NSTimeInterval(savedArticleObject.valueForKey("articleTimeStamp") as! Int))
            if let timeStampDateString = dateFormatter.stringFromDate(timeStampDateObject) as? String {
                cell.savedArticlesPublishDateLabel.text = timeStampDateString
            }
            
            if let author = savedArticleObject.valueForKey("articleAuthor") as? String {
                cell.savedArticlesAuthorLabel.text = author
            }
            
        } else {
            
            cell.savedArticlesHeadlineLabel.text = "Saved Article"
            cell.savedArticlesAuthorLabel.text = "Staff"
            cell.savedArticlesPublishDateLabel.text = "09/09/15"
            
        }
        
        return cell
        
    }
    
    // Change everything here from savedArticleObjects to the database objects
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView?.indexPathForRowAtPoint(location) else { return nil }
        
        guard let cell = tableView?.cellForRowAtIndexPath(indexPath) else { return nil }
        
        guard let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("SavedArticlesDetailViewControllerIdentifier") as? SavedArticlesDetailViewController else { return nil }
        
        if let savedArticleObject = savedArticleObjects.objectAtIndex(indexPath.row) as? Article {
            
            if let title = savedArticleObject.valueForKey("articleTitle") as? String {
                detailViewController.savedArticleTitleThroughSegue = title
            }
            
            if let author = savedArticleObject.valueForKey("articleAuthor") as? String {
                detailViewController.savedArticleAuthorThroughSegue = author
            }
            
            if let articleContent = savedArticleObject.valueForKey("articleArticleContent") as? String {
                detailViewController.savedArticleArticleContentThroughSegue = articleContent
            }
                        
            detailViewController.preferredContentSize = CGSize(width: 0.0, height: 600)
            
            previewingContext.sourceRect = cell.frame
        }
        
        return detailViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
    
    // Creating our data-source NSMutableOrderedSet containing all objects from the CoreData database.
    func populateSavedArticlesFromCoreData() {
        
        self.cellLoadingIndicator.startAnimating()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
        
        var error: NSError?
        
        do {
            // Setting up Core Data variables
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            let entityDescription = NSEntityDescription.entityForName("Article", inManagedObjectContext: managedObjectContext)
            
            let request = NSFetchRequest()
            request.entity = entityDescription
            
            var objects = try managedObjectContext.executeFetchRequest(request)
    
                if objects.count > 0 {
                    for result in objects {
                        
                        let managedObject = result as? Article
                        
                        if (managedObject!.articleTitle!.characters.count != 0) {
                            self.savedArticleObjects.addObject(managedObject!)
                        } else {
                            
                        }
                    }
                    
                } else {
                    
                    dispatch_async(dispatch_get_main_queue()){
                    
                    let customIcon = UIImage(named: "Danger")
                    let noSavedArticlesAlertView = JSSAlertView().show(self, title: "No saved articles", text: "Press the cloud-shaped button in the top-right corner to save an article.", buttonText:  "OK", color: UIColor.opaqueGoldenWordsYellow(), iconImage: customIcon)
                    noSavedArticlesAlertView.addAction(self.closeCallback)
                    noSavedArticlesAlertView.setTitleFont("ClearSans-Bold")
                    noSavedArticlesAlertView.setTextFont("ClearSans")
                    noSavedArticlesAlertView.setButtonFont("ClearSans-Light")
                    noSavedArticlesAlertView.setTextTheme(.Light)
                    
                    print("There was an error while populating the NSMutableOrderedSet 'savedArticleObjects' from the CoreData database")
                    }
                    
            }
        } catch {
            
            dispatch_async(dispatch_get_main_queue()){
            
            let customIcon = UIImage(named: "Danger")
            let savedArticlesCannotLoadAlertView = JSSAlertView().show(self, title: "Saved articles could not load", text: "Please close the app and try again.", buttonText:  "OK", color: UIColor.redColor(), iconImage: customIcon)
            savedArticlesCannotLoadAlertView.addAction(self.closeCallback)
            savedArticlesCannotLoadAlertView.setTitleFont("ClearSans-Bold")
            savedArticlesCannotLoadAlertView.setTextFont("ClearSans")
            savedArticlesCannotLoadAlertView.setButtonFont("ClearSans-Light")
            savedArticlesCannotLoadAlertView.setTextTheme(.Light)
            
            }
            
            abort()
        }
    }
        
        
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.tableView.reloadData()
            self.cellLoadingIndicator.stopAnimating()
    }
}
    
    func closeCallback() {
        
    }
    
    
    func cancelCallback() {
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Deleting object from the data source array
            
            // Delete the entry from the Core Data database
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            let entityDescription = NSEntityDescription.entityForName("Article", inManagedObjectContext: managedObjectContext)
            
            managedObjectContext.deleteObject(self.savedArticleObjects.objectAtIndex(indexPath.row) as! NSManagedObject)
            self.savedArticleObjects.removeObjectAtIndex(indexPath.row)
            do {
                try managedObjectContext.save()
            } catch {
                
                let customIcon = UIImage(named: "Danger")
                let savedArticlesCannotDeleteAlertView = JSSAlertView().show(self, title: "Saved article could not deleted", text: "The saved article could not be deleted. Please restart the app and try again.", buttonText:  "OK", color: UIColor.redColor(), iconImage: customIcon)
                savedArticlesCannotDeleteAlertView.addAction(self.closeCallback)
                savedArticlesCannotDeleteAlertView.setTitleFont("ClearSans-Bold")
                savedArticlesCannotDeleteAlertView.setTextFont("ClearSans")
                savedArticlesCannotDeleteAlertView.setButtonFont("ClearSans-Light")
                savedArticlesCannotDeleteAlertView.setTextTheme(.Light)
                
            }
            
            // Delete the row from the data source
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }
    
    @IBAction func deleteAllSavedArticles(sender: AnyObject) {
        
        let customIcon = UIImage(named: "Thin Cross")
        let deleteSavedArticlesAlertView = JSSAlertView().show(self, title: "Delete all saved articles?", text: "Are you sure you want to delete all of your saved articles?", buttonText: "Yup!", cancelButtonText: "Nope", color: UIColor.redColor(), iconImage: customIcon)
        deleteSavedArticlesAlertView.addAction(deleteSavedArticlesCloseCallback)
        deleteSavedArticlesAlertView.addCancelAction(deleteSavedArticlesCancelCallback)
        deleteSavedArticlesAlertView.setTitleFont("ClearSans-Bold")
        deleteSavedArticlesAlertView.setTextFont("ClearSans")
        deleteSavedArticlesAlertView.setButtonFont("ClearSans-Light")
        deleteSavedArticlesAlertView.setTextTheme(.Light)
        
    }
    
    func deleteSavedArticlesCloseCallback() {
        
        print("deleteSavedArticlesCloseCallback called")
        
        // delete all objects in savedArticleObjects, in the CoreData database and in the table view
        
        // Deleting all objects from the CoreData database
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("Article", inManagedObjectContext: managedObjectContext)
        
        let startTimeDeleteRequest = NSDate()
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entityDescription
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.executeRequest(deleteRequest)
            try managedObjectContext.save()
        } catch {
            print(error)
        }
        
        print("Time to delete all saved articles with batch request: \(NSDate().timeIntervalSinceDate(startTimeDeleteRequest))")
        
        // Deleting all objects from the NSMutableOrderedSet
        self.savedArticleObjects.removeAllObjects()
        
        // Deleting all rows from the tableView
        self.tableView.reloadData()
        
    }
    
    func deleteSavedArticlesCancelCallback() {
        
        print("deleteSavedArticlesCancelCallback called")
        
        // Do nothing. The user does not want to delete all saved articles
        NSLog("User chose to keep all saved articles. No article was deleted.")
        
    }
    
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        // Write code for rearranging table view
    }


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowSavedArticleDetails" {
            
            let detailViewController = segue.destinationViewController as! SavedArticlesDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            if let title = savedArticleObjects.objectAtIndex(row!).valueForKey("articleTitle") as? String {
                detailViewController.savedArticleTitleThroughSegue = title
            }
            
            if let volumeIndex = savedArticleObjects.objectAtIndex(row!).valueForKey("articleVolumeNumber") as? String {
                detailViewController.savedArticleVolumeIndexThroughSegue = volumeIndex
            }
            
            if let issueIndex = savedArticleObjects.objectAtIndex(row!).valueForKey("articleIssueNumber") as? String {
                detailViewController.savedArticleIssueIndexThroughSegue = issueIndex
            }
            
            if let author = savedArticleObjects.objectAtIndex(row!).valueForKey("articleAuthor") as? String {
                detailViewController.savedArticleAuthorThroughSegue = author
            }
            
            if let articleContent = savedArticleObjects.objectAtIndex(row!).valueForKey("articleArticleContent") as? String {
                detailViewController.savedArticleArticleContentThroughSegue = articleContent
            }
        }
    }
}
