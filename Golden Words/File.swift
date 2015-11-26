//
//  SavedArticlesTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-11-19.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import CoreData

class SampleClassForSavedArticlesTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var savedArticleObjects = NSMutableOrderedSet(capacity: 1000)
    
    let SavedArticlesTableCellIdentifier = "SavedArticlesTableCellIdentifier"
    
    var dateFormatter = NSDateFormatter()
    
    var revealViewControllerIndicator = 0
    
    var cellLoadingIndicator = UIActivityIndicatorView()
    
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
        navigationItem.title = "Editorials"
        
        populateSavedArticlesFromCoreData()
        
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
        //        return savedArticleObjects.count
        return 5
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(SavedArticlesTableCellIdentifier, forIndexPath: indexPath) as! SavedArticlesTableViewCell
        
        if let savedArticleObject = savedArticleObjects.objectAtIndex(indexPath.row) as? EditorialElement {
            
            let title = savedArticleObject.title ?? ""
            
            let timeStampDateObject = NSDate(timeIntervalSince1970: NSTimeInterval(savedArticleObject.timeStamp))
            let timeStampDateString = dateFormatter.stringFromDate(timeStampDateObject) ?? "Date unknown"
            
            let author = savedArticleObject.author ?? ""
            
            let issueNumber = savedArticleObject.issueNumber ?? ""
            let volumeNumber = savedArticleObject.volumeNumber ?? ""
            
            let articleContent = savedArticleObject.articleContent ?? ""
            
            cell.savedArticlesHeadlineLabel.text = title
            cell.savedArticlesAuthorLabel.text = author
            cell.savedArticlesPublishDateLabel.text = timeStampDateString
            
        } else {
            
            cell.savedArticlesHeadlineLabel.text = nil
            cell.savedArticlesAuthorLabel.text = nil
            cell.savedArticlesPublishDateLabel = nil
            
        }
        
        return cell
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView?.indexPathForRowAtPoint(location) else { return nil }
        
        guard let cell = tableView?.cellForRowAtIndexPath(indexPath) else { return nil }
        
        guard let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("SavedArticlesDetailViewControllerIdentifier") as? SavedArticlesDetailViewController else { return nil }
        
        if let savedArticleObject = savedArticleObjects.objectAtIndex(indexPath.row) as? EditorialElement {
            
            let title = savedArticleObject.title ?? ""
            let author = savedArticleObject.author ?? ""
            let articleContent = savedArticleObject.articleContent ?? ""
            
            let savedArticleHeadlineFor3DTouch = title
            let savedArticleAuthorFor3DTouch = author
            let savedArticleArticleContentFor3DTouch = articleContent
            
            detailViewController.savedArticleTitleThroughSegue = savedArticleHeadlineFor3DTouch
            detailViewController.savedArticleAuthorThroughSegue = savedArticleAuthorFor3DTouch
            detailViewController.savedArticleArticleContentThroughSegue = savedArticleArticleContentFor3DTouch
            
            detailViewController.preferredContentSize = CGSize(width: 0.0, height: 600)
            
            previewingContext.sourceRect = cell.frame
        }
        
        return detailViewController
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        showViewController(viewControllerToCommit, sender: self)
    }
    
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
                        
                        let coreDataRequestResult = result as? NSManagedObject
                        
                        if let savedArticleObject: EditorialElement = EditorialElement(title: "An incredible article", nodeID: 0, timeStamp: 1442239200, imageURL: "http://goldenwords.ca/sites/all/themes/custom/gw/logo.png", author: "Staff", issueNumber: "0", volumeNumber: "0", articleContent: "Could not retrieve article content") {
                            
                            if let title = coreDataRequestResult!.valueForKey("articleTitle") as? String {
                                savedArticleObject.title = coreDataRequestResult!.valueForKey("articleTitle") as! String
                            }
                            
                            //                            if let timeStampString = coreDataRequestResult?.valueForKey("articleTimeStamp") as? String {
                            //                                savedArticleObject.timeStamp = Int(timeStampString)!
                            //                            }
                            
                            if let imageURL = coreDataRequestResult?.valueForKey("articleImageURL") as? String {
                                savedArticleObject.imageURL = imageURL
                            }
                            
                            if let author = coreDataRequestResult?.valueForKey("articleAuthor") as? String {
                                savedArticleObject.author = author
                            }
                            
                            if let articleContent = coreDataRequestResult?.valueForKey("articleArticleContent") as? String {
                                savedArticleObject.articleContent = articleContent
                            }
                            
                            if let issueNumber = coreDataRequestResult?.valueForKey("articleIssueNumber") as? String {
                                savedArticleObject.issueNumber = issueNumber
                            }
                            
                            if let volumeNumber = coreDataRequestResult?.valueForKey("articleVolumeNumber") as? String {
                                savedArticleObject.volumeNumber = volumeNumber
                            }
                            
                            if savedArticleObject.articleContent.characters.count > 40 {
                                self.savedArticleObjects.addObject(savedArticleObject)
                            }
                        }
                    }
                    
                    
                } else {
                    
                    print("There was an error when trying to build the array of savedArticleObject's by extracting the managed objects from the CoreData database")
                    
                }
            } catch {
                abort()
            }
            
            //            let timeStampSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
            //            self.savedArticleObjects.sortUsingDescriptors([timeStampSortDescriptor])
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.tableView.reloadData()
            self.cellLoadingIndicator.stopAnimating()
        }
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
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // Deleting object from the data source array
            self.savedArticleObjects.removeObjectAtIndex(indexPath.row)
            
            // Delete the entry from the Core Data database
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            let entityDescription = NSEntityDescription.entityForName("Article", inManagedObjectContext: managedObjectContext)
            
            
            
            /*
            let timeBeforeBatchRequest = NSDate()
            
            let fetchRequest = NSFetchRequest()
            fetchRequest.entity = entityDescription
            
            do {
            try managedObjectContext.executeRequest(deleteRequest)
            try managedObjectContext.save()
            } catch {
            print(error)
            }
            
            print("Time to delete with batch request: \(NSDate.timeIntervalSinceDate(timeBeforeBatchRequest))")
            */
            
            
        }
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
            
            detailViewController.savedArticleTitleThroughSegue = savedArticleObjects.objectAtIndex(row!).title
            detailViewController.savedArticleVolumeIndexThroughSegue = savedArticleObjects.objectAtIndex(row!).volumeNumber
            detailViewController.savedArticleIssueIndexThroughSegue = savedArticleObjects.objectAtIndex(row!).issueNumber
            detailViewController.savedArticleAuthorThroughSegue = savedArticleObjects.objectAtIndex(row!).author
            detailViewController.savedArticleArticleContentThroughSegue = savedArticleObjects.objectAtIndex(row!).articleContent
            
        }
    }
}
