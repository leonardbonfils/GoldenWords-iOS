//
//  NewsTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-15.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire

class NewsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    // Hamburger button declaration
    @IBOutlet weak var menuButton:UIBarButtonItem!

    // Table View Outlet used for the refresh control
    @IBOutlet var newsTableView: UITableView!
    
    var temporaryNewsObjects = NSMutableOrderedSet(capacity: 1000)
    var newsObjects = NSMutableOrderedSet(capacity: 1000)
        
    var goldenWordsRefreshControl = UIRefreshControl()
    
    var revealViewControllerIndicator : Int = 0
    
    var customView: UIView!
    
    var labelsArray: [UILabel] = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer : NSTimer!
    
    var populatingNewsArticles = false
    
    var currentPage = 0
    
    let newsArticleTableCellIdentifier = "NewsTableCellIdentifier"
    
    var dateFormatter = NSDateFormatter()
    
    var nodeIDArray = NSMutableArray()
    
    var timeStampDateString : String!
    
    var cellLoadingIndicator = UIActivityIndicatorView()
    
    // Refresh control variables - end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellLoadingIndicator.backgroundColor = UIColor.yellowColor()
        self.cellLoadingIndicator.hidesWhenStopped = true
        
        // Hamburger button configuration
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 280
        
        // Preliminary refresh "set up"
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        // Creating and configuring the goldenWordsRefreshControl subview
        goldenWordsRefreshControl = UIRefreshControl()
        goldenWordsRefreshControl.backgroundColor = UIColor.goldenWordsYellow()
        goldenWordsRefreshControl.tintColor = UIColor.whiteColor()
//        goldenWordsRefreshControl.addTarget(self, action: "handleRefresh", forControlEvents: .ValueChanged)
        newsTableView.addSubview(goldenWordsRefreshControl)
        
        // Navigation set up
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "News Articles"
        
//        loadCustomRefreshContents()
        
        populateNewsArticles()
        
        self.dateFormatter.dateFormat = "dd/MM/yy"
/*
        // Formatting the date for the "last updated on..." string
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let currentDateAndTime = NSDate()
        let updateString = "Last updated at " + self.dateFormatter.stringFromDate(currentDateAndTime)
        self.goldenWordsRefreshControl!.attributedTitle = NSAttributedString(string: updateString) */
        
        tableView.estimatedRowHeight = 50
        
        self.cellLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.cellLoadingIndicator.color = UIColor.goldenWordsYellow()
        let indicatorCenter = CGPoint(x: self.newsTableView.center.x, y: self.newsTableView.center.y - 50)
        self.cellLoadingIndicator.center = indicatorCenter
        self.newsTableView.addSubview(cellLoadingIndicator)
        self.newsTableView.bringSubviewToFront(cellLoadingIndicator)
        
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
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "handleRefresh", userInfo: nil, repeats: true)
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return (newsObjects.count)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCellWithIdentifier("NewsTableCellIdentifier", forIndexPath: indexPath) as! NewsTableViewCell
//        
        let row = indexPath.row

//        guard let cell = tableView.dequeueReusableCellWithIdentifier(newsArticleTableCellIdentifier, forIndexPath: indexPath) as? NewsTableViewCell else {
//                print ("error: newsArticleTableview cell is not of class NewsTableViewCell, we will use RandomTableViewCell instead")
//            return tableView.dequeueReusableCellWithIdentifier(newsArticleTableCellIdentifier, forIndexPath: indexPath) as! RandomTableViewCell
//        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(newsArticleTableCellIdentifier, forIndexPath: indexPath) as! NewsTableViewCell
        
        if let newsObject = newsObjects.objectAtIndex(indexPath.row) as? NewsElement {
            // we just unwrapped newsObject
            
            let title = newsObject.title ?? "" // if newsObject.title == nil, we will return an empty string.
            
            let timeStampDateObject = NSDate(timeIntervalSince1970: NSTimeInterval(newsObject.timeStamp))
            let timeStampDateString = dateFormatter.stringFromDate(timeStampDateObject)
            
            let author = newsObject.author ?? ""
            
            let issueNumber = newsObject.issueNumber ?? ""
            let volumeNumber = newsObject.volumeNumber ?? ""
            
            let articleContent = newsObject.articleContent ?? ""
            
            let nodeID = newsObject.nodeID ?? 0
            
            
            cell.newsHeadlineLabel.text = title
            
            cell.newsAuthorLabel.text = author
            
            cell.newsPublishDateLabel.text = timeStampDateString
            
        } else {
            
            cell.newsHeadlineLabel.text = nil
            cell.newsAuthorLabel.text = nil
            cell.newsPublishDateLabel.text = nil
        }
        
        return cell

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView?.indexPathForRowAtPoint(location) else { return nil }
        
        guard let cell = tableView?.cellForRowAtIndexPath(indexPath) else { return nil }
        
        guard let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("NewsDetailViewControllerIdentifier") as? NewsDetailViewController else { return nil }
        
        if let newsObject = newsObjects.objectAtIndex(indexPath.row) as? NewsElement {
            
            let title = newsObject.title ?? ""
            
            let author = newsObject.author ?? ""
            
            let articleContent = newsObject.articleContent ?? ""
            
            let newsArticleHeadlineFor3DTouch = title
            let newsArticleAuthorFor3DTouch = author
            let newsArticleArticleContentFor3DTouch = articleContent
            
            detailViewController.newsArticleTitleThroughSegue = newsArticleHeadlineFor3DTouch
            detailViewController.newsArticleAuthorThroughSegue = newsArticleAuthorFor3DTouch
            detailViewController.newsArticleArticleContentThroughSegue = newsArticleArticleContentFor3DTouch
            
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
    // Return NO if you do not want the specified item to be editable.
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
        
        if segue.identifier == "ShowNewsArticleDetails" {
            
            let detailViewController = segue.destinationViewController as! NewsDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            // Passing the article information through the segue
            detailViewController.newsArticleTitleThroughSegue = newsObjects.objectAtIndex((myIndexPath?.row)!).title
//            detailViewController.newsArticlePublishDateThroughSegue = timeStampDateString
            detailViewController.newsArticleVolumeIndexThroughSegue = newsObjects.objectAtIndex((myIndexPath?.row)!).volumeNumber
            detailViewController.newsArticleIssueIndexThroughSegue = newsObjects.objectAtIndex((myIndexPath?.row)!).issueNumber
            detailViewController.newsArticleAuthorThroughSegue = newsObjects.objectAtIndex((myIndexPath?.row)!).author
            detailViewController.newsArticleArticleContentThroughSegue = newsObjects.objectAtIndex((myIndexPath?.row)!).articleContent

            
//            detailViewController.newsArticleTitleThroughSegue = newsHeadline[row!]
            
        }
        
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    
    
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.75) {
        populateNewsArticles()
        }
    }
    
    func populateNewsArticles() {
        
        if populatingNewsArticles {
            return
        }
        populatingNewsArticles = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.cellLoadingIndicator.startAnimating()
        
        Alamofire.request(GWNetworking.Router.News(self.currentPage)).responseJSON() { response in
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
                            
                            if let newsArticleElement : NewsElement = NewsElement(title: "Just another Golden Words article", nodeID: 0, timeStamp: 1442239200, imageURL: "init", author: "Staff", issueNumber: "Issue # error", volumeNumber: "Volume # error", articleContent: "Could not retrieve article content") {
                                
                                newsArticleElement.title = node.1["title"] as! String
                                newsArticleElement.nodeID = Int(nodeIDValue)!
                                
                                let timeStampString = node.1["revision_timestamp"] as! String
                                newsArticleElement.timeStamp = Int(timeStampString)!
                                
                                if let imageURL = node.1["image_url"] as? String {
                                    newsArticleElement.imageURL = imageURL
                                }
                                
                                if let author = node.1["author"] as? String {
                                    newsArticleElement.author = author
                                }
                                if let issueNumber = node.1["issue_int"] as? String {
                                    newsArticleElement.issueNumber = issueNumber
                                }
                                if let volumeNumber = node.1["volume_int"] as? String {
                                    newsArticleElement.volumeNumber = volumeNumber
                                }
                                
                                if let articleContent = node.1["html_content"] as? String {
                                    newsArticleElement.articleContent = articleContent
                                }
                                
                                if newsArticleElement.articleContent.characters.count > 40 {
                                    lastItem = self.temporaryNewsObjects.count
                                    self.temporaryNewsObjects.addObject(newsArticleElement)
                                    // print(newsArticleElement.nodeID)
                                }
                                
                                let indexPaths = (lastItem..<self.temporaryNewsObjects.count).map { NSIndexPath(forItem: $0, inSection: 0) }

                            }
                        }
                        
                        /* Sorting the elements in order of newest to oldest (as the array index increases] */
                        let timestampSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
                        self.temporaryNewsObjects.sortUsingDescriptors([timestampSortDescriptor])
                        
                }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.newsObjects = self.temporaryNewsObjects
                        self.newsTableView.reloadData()
                        
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        
                        self.cellLoadingIndicator.stopAnimating()
                        self.currentPage++
                        self.populatingNewsArticles = false

                    }
                }
            }
        }
    }
    
    func handleRefresh() {
        
        goldenWordsRefreshControl.beginRefreshing()
        
        //            let currentNumberOfPages = self.currentPage
        
        //            self.newsObjects.removeAllObjects()
        
        self.currentPage = 0
        
        self.cellLoadingIndicator.startAnimating()
        self.newsTableView.bringSubviewToFront(cellLoadingIndicator)
        
        /*
        repeat {
        
        populateNewsArticles()
        // I initially thought I would need to add 1 to the currentPage everytime, but this is already done in the populateNewsArticles function.
        
        }
        
        while (self.currentPage < currentNumberOfPages) // the program runs through the "repeat" statement before even considering the "while" condition.
        */
        
        self.populatingNewsArticles = false
        
        populateNewsArticles()
        
        // print(newsObjects.count)
        
        self.cellLoadingIndicator.stopAnimating()
        
        /*            self.editorialsTableView!.reloadData() */
        
        goldenWordsRefreshControl.endRefreshing()
        
        /*            populateNewsArticles() */
    }
}