//
//  RandomTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire

class RandomTableViewController: UITableViewController {
    
    let goldenWordsYellow = UIColor(red: 247.00/255.0, green: 192.00/255.0, blue: 51.00/255.0, alpha: 0.5)

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellLoadingIndicator.backgroundColor = goldenWordsYellow
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
        randomTableView.delegate = self
        randomTableView.dataSource = self
        
        // Creating and configuring the goldenWordsRefreshControl subview
        goldenWordsRefreshControl = UIRefreshControl()
       goldenWordsRefreshControl.backgroundColor = goldenWordsYellow
        goldenWordsRefreshControl.tintColor = UIColor.whiteColor()
//        goldenWordsRefreshControl.addTarget(self, action: "handleRefresh", forControlEvents: .ValueChanged)
        randomTableView.addSubview(goldenWordsRefreshControl)
        
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
        self.cellLoadingIndicator.color = goldenWordsYellow
        let indicatorCenter = CGPoint(x: self.randomTableView.center.x, y: self.randomTableView.center.y - 130)
        self.cellLoadingIndicator.center = indicatorCenter
        self.randomTableView.addSubview(cellLoadingIndicator)
        self.randomTableView.bringSubviewToFront(cellLoadingIndicator)
        

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

        /*
    func loadCustomRefreshContents() {
        let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customView = refreshContents[0] as! UIView
        customView.frame = customRefreshControl.bounds
        
        for (var i=0; i < customView.subviews.count; i++) {
            labelsArray.append(customView.viewWithTag(i+1) as! UILabel)
            
            customRefreshControl.addSubview(customView)
        }
    }
    
    func animateRefreshStep1() {
        isAnimating = true
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            
            // Selecting the UILabel object in the labelsArray array, and applying the animation
            self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            self.labelsArray[self.currentLabelIndex].textColor = self.getNextColor()
            
            }, completion: { (finished) -> Void in
                
                UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    
                    self.labelsArray[self.currentLabelIndex].transform = CGAffineTransformIdentity
                    self.labelsArray[self.currentLabelIndex].textColor = UIColor.blackColor()
                    
                    }, completion: { (finished) -> Void in
                        ++self.currentLabelIndex
                        
                        if self.currentLabelIndex < self.labelsArray.count {
                            self.animateRefreshStep1()
                        }
                        else {
                            self.animateRefreshStep2()
                        }
                })
        })
    }
    
    func animateRefreshStep2() {
        UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
            self.labelsArray[0].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[1].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[2].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[3].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[4].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[5].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[6].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[7].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[8].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[9].transform = CGAffineTransformMakeScale(1.5, 1.5)
            self.labelsArray[10].transform = CGAffineTransformMakeScale(1.5, 1.5)
            
            
            }, completion: { (finished) -> Void in
                UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                    self.labelsArray[0].transform = CGAffineTransformIdentity
                    self.labelsArray[1].transform = CGAffineTransformIdentity
                    self.labelsArray[2].transform = CGAffineTransformIdentity
                    self.labelsArray[3].transform = CGAffineTransformIdentity
                    self.labelsArray[4].transform = CGAffineTransformIdentity
                    self.labelsArray[5].transform = CGAffineTransformIdentity
                    self.labelsArray[6].transform = CGAffineTransformIdentity
                    self.labelsArray[7].transform = CGAffineTransformIdentity
                    self.labelsArray[8].transform = CGAffineTransformIdentity
                    self.labelsArray[9].transform = CGAffineTransformIdentity
                    self.labelsArray[10].transform = CGAffineTransformIdentity
                    
                    
                    }, completion: { (finished) -> Void in
                        if self.customRefreshControl.refreshing {
                            self.currentLabelIndex = 0
                            self.animateRefreshStep1()
                        } else {
                            self.isAnimating = false
                            self.currentLabelIndex = 0
                            for var i=0; i<self.labelsArray.count; i++ {
                                self.labelsArray[i].textColor = UIColor.blackColor()
                                self.labelsArray[i].transform = CGAffineTransformIdentity
                            }
                        }
                })
        })
        
    }
    */
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if goldenWordsRefreshControl.refreshing {
            if !isAnimating {
                holdRefreshControl()
//                animateRefreshStep1()
                
            }
        }
    }
    
    func getNextColor() -> UIColor {
        var colorsArray: [UIColor] = [goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow]
        
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        
        let returnColor = colorsArray[currentColorIndex]
        ++currentColorIndex
        
        return returnColor
    }
    
    func holdRefreshControl() {
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "handleRefresh", userInfo: nil, repeats: true)
    }
    
//    func endOfWork() {
//        goldenWordsRefreshControl.endRefreshing()
//        
//        timer.invalidate()
//        timer = nil
//    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (randomObjects.count)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCellWithIdentifier("RandomTableCellIdentifier", forIndexPath: indexPath) as! RandomTableViewCell
        
        let row = indexPath.row

//        guard let cell = tableView.dequeueReusableCellWithIdentifier(RandomArticleTableCellIdentifier, forIndexPath: indexPath) as? RandomTableViewCell else {
//            
//            print("error: randArticlesTableView cell is not of class RandomTableViewCell, we will use EditorialTableViewCell instead")
//            return tableView.dequeueReusableCellWithIdentifier(RandomArticleTableCellIdentifier, forIndexPath: indexPath) as! NewsTableViewCell
//        
//        }
        
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
            
            
            cell.randomHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.randomHeadlineLabel.text = title
            
            cell.randomAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            cell.randomAuthorLabel.text = author
            
            cell.randomPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            cell.randomPublishDateLabel.text = timeStampDateString
                
            
        } else {
            
            cell.randomHeadlineLabel.text = nil
            cell.randomAuthorLabel.text = nil
            cell.randomPublishDateLabel.text = nil
            
        }
        
//        let title = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).title
//        let timeStamp = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).timeStamp
//        let imageURL = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).imageURL
//        let author = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).author
//        
//        let issueNumber = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).issueNumber
//        let volumeNumber = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).volumeNumber
//        
//        let articleContent = (randomObjects.objectAtIndex(indexPath.row) as! RandomElement).articleContent
//        
//        // Unlike the Pictures Collection View, there is no need to create another Alamofire request here, since we already have all the content we want from the JSON we downloaded. There is no URL that we wish to place a request with to get extra content.
//        
//        cell.randomHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
//        cell.randomHeadlineLabel.text = title
//        
//        cell.randomAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        cell.randomAuthorLabel.text = author
//        
//        cell.randomPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        cell.randomPublishDateLabel.text = String(timeStamp)
//        
//        cell.randomVolumeAndIssueLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//        cell.randomVolumeAndIssueLabel.text = "Volume \(volumeNumber) - Issue \(issueNumber)"
        
        return cell
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
            
            // Passing the article information through the segue
            detailViewController.randomArticleTitleThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).title
//            detailViewController.randomArticlePublishDateThroughSegue = timeStampDateString
            detailViewController.randomArticleVolumeIndexThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).volumeNumber
            detailViewController.randomArticleIssueIndexThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).issueNumber
            detailViewController.randomArticleAuthorThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).author
            detailViewController.randomArticleArticleContentThroughSegue = randomObjects.objectAtIndex((myIndexPath?.row)!).articleContent
            
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
                            
                            if let randomElement : RandomElement = RandomElement(title: "Could not retrieve title", nodeID: 0, timeStamp: 0, imageURL: "init", author: "Author not found", issueNumber: "Issue # error", volumeNumber: "Volume # error", articleContent: "Could not retrieve article content") {
                                
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
                                    print(randomElement.nodeID)
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
                        self.randomTableView.reloadData()
                        
                        self.cellLoadingIndicator.stopAnimating()
                        
                        self.currentPage++
                        self.populatingRandomArticles = false
                    }
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
        self.randomTableView.bringSubviewToFront(cellLoadingIndicator)
        
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
        
        print(randomObjects.count)
        
        self.cellLoadingIndicator.stopAnimating()
        self.cellLoadingIndicator.hidesWhenStopped = true
        
/*        self.randomTableView!.reloadData() */
        
        goldenWordsRefreshControl.endRefreshing()
        
        //            populateEditorials()
    }

}