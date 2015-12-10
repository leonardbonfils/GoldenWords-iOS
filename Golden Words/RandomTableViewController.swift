//
//  RandomTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire

class RandomTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {

    // Hamburger button declaration
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    // Table View Outlet used for the refresh control
    @IBOutlet var randomTableView: UITableView!
    
    var temporaryRandomObjects = NSMutableOrderedSet(capacity: 1000)
    var randomObjects = NSMutableOrderedSet(capacity: 1000)
    
    var goldenWordsRefreshControl = UIRefreshControl()
    
    var revealViewControllerIndicator : Int = 0
    
    var customView: UIView!
    
    var labelsArray: [UILabel] = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer : NSTimer!
    
    var populatingRandomArticles = false
    
    var currentPage = 0
    
    let RandomArticleTableCellIdentifier = "RandomTableCellIdentifier"
    
    var dateFormatter = NSDateFormatter()
    
    var nodeIDArray = NSMutableArray()
    
    var timeStampDateString : String!
    
    var cellLoadingIndicator = UIActivityIndicatorView()
    
    var downloadErrorAlertViewCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadErrorAlertViewCount = 0
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.cellLoadingIndicator.backgroundColor = UIColor.goldenWordsYellow()
        self.cellLoadingIndicator.hidesWhenStopped = true
        
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
        tableView.addSubview(goldenWordsRefreshControl)
        
        // Navigation set up
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Random Articles"
        
//        loadCustomRefreshContents()
        
        populateRandomArticles()
        
        self.dateFormatter.dateFormat = "dd/MM/yy"
        /*
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let currentDateAndTime = NSDate()
        let updateString = "Last updated at " + self.dateFormatter.stringFromDate(currentDateAndTime)
        self.goldenWordsRefreshControl!.attributedTitle = NSAttributedString(string: updateString)
            */
        
        tableView.estimatedRowHeight = 50
        
        self.cellLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.cellLoadingIndicator.color = UIColor.goldenWordsYellow()
        let indicatorCenter = CGPoint(x: self.tableView.center.x, y: self.tableView.center.y - 50)
        self.cellLoadingIndicator.center = indicatorCenter
        self.tableView.addSubview(cellLoadingIndicator)
        self.tableView.bringSubviewToFront(cellLoadingIndicator)
        
        // Checking for 3D Touch Support
        if (traitCollection.forceTouchCapability == .Available){
                registerForPreviewingWithDelegate(self, sourceView: view)
            }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recraeated.
    }

    // MARK: - Table view data source
    
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (randomObjects.count)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier(RandomArticleTableCellIdentifier, forIndexPath: indexPath) as! RandomTableViewCell
        
        if let randomObject = randomObjects.objectAtIndex(indexPath.row) as? RandomElement {
            // we just unwrapped randomObject
            
            let title = randomObject.title ?? "" // if randomObject.title == nil, then we return an empty string.
            
            let timeStampDateObject = NSDate(timeIntervalSince1970: NSTimeInterval(randomObject.timeStamp))
            let timeStampDateString = dateFormatter.stringFromDate(timeStampDateObject)
            
            let author = randomObject.author ?? ""
            
            let issueNumber = randomObject.issueNumber ?? ""
            let volumeNumber = randomObject.volumeNumber ?? ""
            
            let articleContent = randomObject.articleContent ?? ""
            
            let nodeID = randomObject.nodeID ?? 0
            
            
            cell.randomHeadlineLabel.text = title
            
            cell.randomAuthorLabel.text = author
            
            cell.randomPublishDateLabel.text = timeStampDateString
                
            
        } else {
            
            cell.randomHeadlineLabel.text = nil
            cell.randomAuthorLabel.text = nil
            cell.randomPublishDateLabel.text = nil
            
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
        
        guard let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("RandomDetailViewControllerIdentifier") as? RandomDetailViewController else { return nil }
        
        if let randomObject = randomObjects.objectAtIndex(indexPath.row) as? RandomElement {
            
            let title = randomObject.title ?? ""
            
            let author = randomObject.author ?? ""
            
            let articleContent = randomObject.articleContent ?? ""
            
            let currentIssueHeadlineFor3DTouch = title
            let currentIssueAuthorFor3DTouch = author
            let currentIssueArticleContentFor3DTouch = articleContent
            
            detailViewController.randomArticleTitleThroughSegue = currentIssueHeadlineFor3DTouch
            detailViewController.randomArticleAuthorThroughSegue = currentIssueAuthorFor3DTouch
            detailViewController.randomArticleArticleContentThroughSegue = currentIssueArticleContentFor3DTouch
            
            detailViewController.preferredContentSize = CGSize(width: 0.0, height: 600)
            
            previewingContext.sourceRect = cell.frame
            
        }
        
        return detailViewController
        
    }
    
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
    }




    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowRandomArticleDetails" {
            
            let detailViewController = segue.destinationViewController as! RandomDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            tableView.deselectRowAtIndexPath(myIndexPath!, animated: true)
            
            // Passing the article information through the segue
            detailViewController.randomArticleTitleThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).title
//            detailViewController.randomArticlePublishDateThroughSegue = timeStampDateString
            detailViewController.randomArticleVolumeIndexThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).volumeNumber
            detailViewController.randomArticleIssueIndexThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).issueNumber
            detailViewController.randomArticleAuthorThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).author
            detailViewController.randomArticleArticleContentThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).articleContent
            detailViewController.randomArticleNodeIDThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).nodeID
            detailViewController.randomArticleTimeStampThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).timeStamp
            
//            detailViewController.randomArticleTitleThroughSegue = randomHeadline[row]
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.75) {
            populateRandomArticles()
        }
    }
    
    func populateRandomArticles() {
    
        if populatingRandomArticles {
            return
        }
        populatingRandomArticles = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.cellLoadingIndicator.startAnimating()
        
        Alamofire.request(GWNetworking.Router.Random(self.currentPage)).responseJSON() { response in
            if let JSON = response.result.value {

                /* Creating objects for every single editorial is long running work, so we put that work on a background queue, to keep the app very responsive. */
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                    
                    /* Making an array of all the node IDs from the JSON file */
                    var nodeIDArray : [Int]
                    
                    if (JSON .isKindOfClass(NSDictionary)) {
                        
                        for node in JSON as! Dictionary<String, AnyObject> {
                            
                            let nodeIDValue = node.0
                            var lastItem : Int = 0
                            
                            self.nodeIDArray.addObject(nodeIDValue)
                            
                            if let randomElement : RandomElement = RandomElement(title: "Just another Golden Words article", nodeID: 0, timeStamp: 1442239200, imageURL: "init", author: "Staff", issueNumber: "Issue # error", volumeNumber: "Volume # error", articleContent: "Could not retrieve article content") {
                                
                                randomElement.title = node.1["title"] as! String
                                randomElement.nodeID = Int(nodeIDValue)!
                                
                                let timeStampString = node.1["revision_timestamp"] as! String
                                randomElement.timeStamp = Int(timeStampString)!
                                
                                if let imageURL = node.1["image_url"] as? String {
                                    randomElement.imageURL = imageURL
                                }
                                
                                if let author = node.1["author"] as? String {
                                    randomElement.author = author
                                }

                                if let issueNumber = node.1["issue_int"] as? String {
                                    randomElement.issueNumber = issueNumber
                                }
                                if let volumeNumber = node.1["volume_int"] as? String {
                                    randomElement.volumeNumber = volumeNumber
                                }
                                if let articleContent = node.1["html_content"] as? String {
                                    randomElement.articleContent = articleContent
                                }
                                
                                if randomElement.articleContent.characters.count > 40 {
                                    lastItem = self.temporaryRandomObjects.count
                                    self.temporaryRandomObjects.addObject(randomElement)
                                    // print(randomElement.nodeID)
                                }
                                let indexPaths = (lastItem..<self.temporaryRandomObjects.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                            }
                        }
                        
                        /* Sorting the elements in order of newest to oldest (as the array index increases] */
                        let timestampSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
                        self.temporaryRandomObjects.sortUsingDescriptors([timestampSortDescriptor])
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.randomObjects = self.temporaryRandomObjects
                        self.tableView.reloadData()
                        
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        
                        self.cellLoadingIndicator.stopAnimating()
                        
                        self.currentPage++
                        self.populatingRandomArticles = false
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
        
        goldenWordsRefreshControl.beginRefreshing()
        
//        let currentNumberOfPages : Int = self.currentPage
//        
//        self.randomObjects.removeAllObjects()
        
        self.currentPage = 0
        
        self.cellLoadingIndicator.startAnimating()
        self.tableView.bringSubviewToFront(cellLoadingIndicator)
        
        /*
        repeat {
            
            populateRandomArticles()
            // I initially thought I would need to add 1 to the currentPage everytime, but this is already done in the populateNewsArticles function, so there is no need to write it again.
            //                self.currentPage++
            
        }
            
            while self.currentPage <= currentNumberOfPages
        */
        
        self.populatingRandomArticles = false
        populateRandomArticles()
        
        // print(randomObjects.count)
        
        self.cellLoadingIndicator.stopAnimating()
        self.cellLoadingIndicator.hidesWhenStopped = true
        
/*        self.tableView!.reloadData() */
        
        goldenWordsRefreshControl.endRefreshing()
        
        //            populateEditorials()
    }

}