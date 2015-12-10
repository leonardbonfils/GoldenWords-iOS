//
//  EditorialsTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire

class EditorialsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    // Hamburger button declaration
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // Table View Outlet used for the refresh control
    @IBOutlet var editorialsTableView: UITableView!
    
    var temporaryEditorialObjects = NSMutableOrderedSet(capacity: 1000)
    var editorialObjects = NSMutableOrderedSet(capacity: 1000)
    
    var goldenWordsRefreshControl = UIRefreshControl()
    
    var revealViewControllerIndicator : Int = 0
    
    var customView: UIView!
    
    var labelsArray: [UILabel] = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer : NSTimer!
    
    var populatingEditorials = false
    
    var currentPage = 0
    
    let EditorialTableCellIdentifier = "EditorialTableCellIdentifier"
    
    var dateFormatter = NSDateFormatter()
    
    var nodeIDArray = NSMutableArray()
    
    var timeStampDateString : String!
    
    var cellLoadingIndicator = UIActivityIndicatorView()
    
    var handleRefreshCalled = false
    
    var downloadErrorAlertViewCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadErrorAlertViewCount = 0
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // Hamburger button configuration
        if self.revealViewController() != nil {
            revealViewControllerIndicator = 1
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 280
        
        // Preliminary refresh control "set up"
        tableView.delegate = self
        tableView.dataSource = self
        
        // Creating and configuring the goldenWordsRefreshControl subview
        goldenWordsRefreshControl = UIRefreshControl()
        goldenWordsRefreshControl.backgroundColor = UIColor.goldenWordsYellow()
        goldenWordsRefreshControl.tintColor = UIColor.whiteColor()
//        goldenWordsRefreshControl.addTarget(self, action: "handleRefresh", forControlEvents: .ValueChanged)
        editorialsTableView.addSubview(goldenWordsRefreshControl)
        
        // Navigation set up
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Editorials"
        
        populateEditorials()
        
        self.dateFormatter.dateFormat = "dd/MM/yy"
//        
//        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
//        self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
//
//        let currentDateAndTime = NSDate()
//        let updateString = "Last updated at " + self.dateFormatter.stringFromDate(currentDateAndTime]
//        self.goldenWordsRefreshControl.attributedTitle = NSAttributedString(string: updateString]
        
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        self.cellLoadingIndicator.backgroundColor = UIColor.goldenWordsYellow()
        self.cellLoadingIndicator.hidesWhenStopped = true
        self.cellLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.cellLoadingIndicator.color = UIColor.goldenWordsYellow()
        let indicatorCenter = CGPoint(x: self.editorialsTableView.center.x, y: self.editorialsTableView.center.y - 50)
        self.cellLoadingIndicator.center = indicatorCenter
        self.editorialsTableView.addSubview(cellLoadingIndicator)
        self.editorialsTableView.bringSubviewToFront(cellLoadingIndicator)
        
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
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if goldenWordsRefreshControl.refreshing {
            if !isAnimating {
                holdRefreshControl()
//                animateRefreshStep1()
                
            }
        }
    }
    
    func holdRefreshControl() {
        timer = NSTimer.scheduledTimerWithTimeInterval(MyGlobalVariables.holdRefreshControlTime, target: self, selector: "handleRefresh", userInfo: nil, repeats: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (editorialObjects.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier(EditorialTableCellIdentifier, forIndexPath: indexPath) as! EditorialsTableViewCell
        
        if let editorialObject = editorialObjects.objectAtIndex(indexPath.row) as? EditorialElement {
            // we just unwrapped editorialObject
            
            let title = editorialObject.title ?? "" // if editorialObject.title == nil, then we return an empty string.
            
            let timeStampDateObject = NSDate(timeIntervalSince1970: NSTimeInterval(editorialObject.timeStamp))
            let timeStampDateString = dateFormatter.stringFromDate(timeStampDateObject) ?? "Date unknown"
            
            let author = editorialObject.author ?? ""
          
            let issueNumber = editorialObject.issueNumber ?? ""
            let volumeNumber = editorialObject.volumeNumber ?? ""
            
            let articleContent = editorialObject.articleContent ?? ""
            
            let nodeID = editorialObject.nodeID ?? 0
            
            
            cell.editorialHeadlineLabel.text = title
            
            cell.editorialAuthorLabel.text = author
            
            cell.editorialPublishDateLabel.text = timeStampDateString
            
//            cell.view.updateSize()
            
        } else {
            
            cell.editorialHeadlineLabel.text = nil
            cell.editorialAuthorLabel.text = nil
            cell.editorialPublishDateLabel.text = nil
            
//            var noInternetConnectionAlert = UIAlertController(title: "No Internet Connection", message: "Could not retrieve data from Golden Words servers", preferredStyle: UIAlertControllerStyle.Alert)
//            noInternetConnectionAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            self.presentViewController(noInternetConnectionAlert, animated: true, completion: nil)
        
        }
        
        return cell
        
    }
    
    func closeCallback() {
        
    }
    
    func cancelCallback() {
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView?.indexPathForRowAtPoint(location) else { return nil }
        
        guard let cell = tableView?.cellForRowAtIndexPath(indexPath) else { return nil }
        
        guard let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("EditorialsDetailViewControllerIdentifier") as? EditorialsDetailViewController else { return nil }
        
        if let editorialObject = editorialObjects.objectAtIndex(indexPath.row) as? EditorialElement {
            
            let title = editorialObject.title ?? ""
            
            let author = editorialObject.author ?? ""
            
            let articleContent = editorialObject.articleContent ?? ""
            
            let editorialHeadlineFor3DTouch = title
            let editorialAuthorFor3DTouch = author
            let editorialArticleContentFor3DTouch = articleContent
            
            detailViewController.editorialTitleThroughSegue = editorialHeadlineFor3DTouch
            detailViewController.editorialAuthorThroughSegue = editorialAuthorFor3DTouch
            detailViewController.editorialArticleContentThroughSegue = editorialArticleContentFor3DTouch
            
            detailViewController.preferredContentSize = CGSize(width: 0.0, height: 600)
            
            previewingContext.sourceRect = cell.frame
        }
        
        return detailViewController
        
    }
    
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
    }
    
    
    
    
    // The "didDeselectItemAtIndexPath" method from the Pictures View Controller does not need to be implemented since the Storyboard has already defined the segue from each table view cell to the detail view controller (i.e. select a cell, it takes you to the corresponding view controller].
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath] -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath] {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade]
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath] {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath] -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Data loading

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowEditorialDetails" {
         
            let detailViewController = segue.destinationViewController as! EditorialsDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            tableView.deselectRowAtIndexPath(myIndexPath!, animated: true)
            
            // Passing the article information through the segue
            detailViewController.editorialTitleThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).title
            detailViewController.editorialVolumeIndexThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).volumeNumber
            detailViewController.editorialIssueIndexThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).issueNumber
            detailViewController.editorialAuthorThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).author
            detailViewController.editorialArticleContentThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).articleContent
            detailViewController.editorialNodeIDThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).nodeID
            detailViewController.editorialTimeStampThroughSegue = editorialObjects.objectAtIndex((myIndexPath?.row)!).timeStamp
            
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.75) {
            populateEditorials()
        }
    }
    
    func populateEditorials() {
        
        if populatingEditorials {
            return
        }
        populatingEditorials = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if handleRefreshCalled == false {
            self.cellLoadingIndicator.startAnimating()
        }
        
        Alamofire.request(GWNetworking.Router.Editorials(self.currentPage)).responseJSON() { response in
            if let JSON = response.result.value {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                    
                    /* Making an array of all the node IDs from the JSON file */
                var nodeIDArray : [Int]
                    
                if (JSON .isKindOfClass(NSDictionary)) {
                    
                    for node in JSON as! Dictionary<String, AnyObject> {
                            
                        let nodeIDValue = node.0
                        var lastItem : Int = 0
                        
                        self.nodeIDArray.addObject(nodeIDValue)
                        
                        if let editorialElement : EditorialElement = EditorialElement(title: "Just another Golden Words article", nodeID: 0, timeStamp: 1442239200, imageURL: "init", author: "Staff", issueNumber: "Issue # error", volumeNumber: "Volume # error", articleContent: "Could not retrieve article content") {
                        
                                editorialElement.title = node.1["title"] as! String
                                editorialElement.nodeID = Int(nodeIDValue)!
                                        
                                let timeStampString = node.1["revision_timestamp"] as! String
                                editorialElement.timeStamp = Int(timeStampString)!
                            
                                if let imageURL = node.1["image_url"] as? String {
                                    editorialElement.imageURL = imageURL
                                }
                                
                                if let author = node.1["author"] as? String {
                                    editorialElement.author = author
                                }
                                if let issueNumber = node.1["issue_int"] as? String {
                                    editorialElement.issueNumber = issueNumber
                                }
                                if let volumeNumber = node.1["volume_int"] as? String {
                                    editorialElement.volumeNumber = volumeNumber
                                }
                            
                                if let articleContent = node.1["html_content"] as? String {
                                    editorialElement.articleContent = articleContent
                                }
                            
                            if editorialElement.articleContent.characters.count > 40 {
                                lastItem = self.temporaryEditorialObjects.count
                                self.temporaryEditorialObjects.addObject(editorialElement)
                            }
                                    
                            let indexPaths = (lastItem..<self.temporaryEditorialObjects.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                            
                               /*
                                nodeIDArray[nodeCounter] = jsonValue{nodeCounter}.string
                                let editorialInfos : EditorialElement = ((jsonValue as! NSDictionary].1["\(nodeIDArray[nodeCounter]]"] as! [NSDictionary]].map { EditorialElement(title: $0["title"] as! String, nodeID: $0["nid"] as! Int, timeStamp: $0["revision_timestamp"] as! Int, imageURL: $0["image_url"] as! String, author: $0["author"], issueNumber: $0["issue_int"] as! Int, volumeNumber: $0["volume_int"] as! Int, articleContent: $0["html_content"] as! String] // I am going to try to break this line down to simplify it and fix the build errors
                            */
                    }
                }
                    
                    /* Sorting the elements in order of newest to oldest (as the array index increases] */
                    let timestampSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
                    self.temporaryEditorialObjects.sortUsingDescriptors([timestampSortDescriptor])
                    
                    
            }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.editorialObjects = self.temporaryEditorialObjects
                        self.editorialsTableView.reloadData()
                        
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        
                        self.cellLoadingIndicator.stopAnimating()
                        
                        self.currentPage++
                        self.populatingEditorials = false
                        self.handleRefreshCalled = false

                    }
                }
            } else {
                
//                self.tableView.gestureRecognizers = nil
                
                if self.downloadErrorAlertViewCount < 1 {
                
                let customIcon = UIImage(named: "Danger")
                let downloadErrorAlertView = JSSAlertView().show(self, title: "Download failed", text: "Please connect to the Internet and try again.", buttonText:  "OK", color: UIColor.redColor(), iconImage: customIcon)
                downloadErrorAlertView.addAction(self.closeCallback)
                downloadErrorAlertView.setTitleFont("ClearSans-Bold")
                downloadErrorAlertView.setTextFont("ClearSans")
                downloadErrorAlertView.setButtonFont("ClearSans-Light")
                downloadErrorAlertView.setTextTheme(.Light)
                    
                self.downloadErrorAlertViewCount++
                    
                }
                
            }
    }
}

    func handleRefresh() {
        
            handleRefreshCalled = true
            
            goldenWordsRefreshControl.beginRefreshing()
            
            self.currentPage = 0 // switched from 1
        
            self.populatingEditorials = false
            populateEditorials()
        
            goldenWordsRefreshControl.endRefreshing()
            
        }
 }