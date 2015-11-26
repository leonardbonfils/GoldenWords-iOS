//
//  CurrentIssueTableViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CurrentIssueTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    // Hamburger menu declaration
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // Table View outlet used for the refresh control
    @IBOutlet var currentIssueTableView: UITableView!
    
    // Volume # - Issue # header view label
    @IBOutlet weak var headerVolumeAndIssueLabel: UILabel!
    
    var temporaryCurrentIssueObjects = NSMutableOrderedSet(capacity: 1000)
    var currentIssueObjects = NSMutableOrderedSet(capacity: 1000)
    
    var goldenWordsRefreshControl = UIRefreshControl()
    // Replacing goldenWordsRefreshControl with the custom "dg" loadingView.
    // goldenWordsRefreshControl.startAnimating() will be replaced by self?.tableView.dg_startAnimating()
    // goldenWordsRefreshControl.stopAnimating() will be replaced by self?.tableView.dg_stopLoading()
    
    var revealViewControllerIndicator : Int = 0
    
    var customView: UIView!
    
    var labelsArray: [UILabel] = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer : NSTimer!
    
    var populatingCurrentIssue = false
    
    var currentPage = 0
    
    let CurrentIssueArticlesTableCellIdentifier = "CurrentIssueArticlesIdentifier"
    
    var dateFormatter = NSDateFormatter()
    
    var nodeIDArray = NSMutableArray()
    
    var timeStampDateString : String!
    
    var imageCache = NSCache()
    
    var cellLoadingIndicator = UIActivityIndicatorView()
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.titleView?.backgroundColor = UIColor.opaqueGoldenWordsYellow()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cellLoadingIndicator.backgroundColor = MyGlobalVariables.loadingIndicatorColor
        self.cellLoadingIndicator.hidesWhenStopped = true
        
        if self.revealViewController() != nil {
            revealViewControllerIndicator = 1
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 280

        // Preliminary refresh control "set up"
        currentIssueTableView.delegate = self
        currentIssueTableView.dataSource = self
        
        // Creating and configuring the goldenWordsRefreshControl subview
        goldenWordsRefreshControl = UIRefreshControl()
        goldenWordsRefreshControl.backgroundColor = UIColor.goldenWordsYellow()
        goldenWordsRefreshControl.tintColor = UIColor.blackColor() // this used to be UIColor.whiteColor()
//        currentIssueTableView.addSubview(goldenWordsRefreshControl)
        
        // Navigation set up
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Current Issue"
        
//        loadCustomRefreshContents()
        
        populateCurrentIssue()
        
//        currentIssueTableView.estimatedRowHeight = 80
        
        self.dateFormatter.dateFormat = "dd/MM/yy"
        
        self.cellLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.cellLoadingIndicator.color = MyGlobalVariables.loadingIndicatorColor
        let indicatorCenter = CGPoint(x: self.currentIssueTableView.center.x, y: self.currentIssueTableView.center.y - 50)
        self.cellLoadingIndicator.center = indicatorCenter
        self.currentIssueTableView.addSubview(cellLoadingIndicator)
        self.currentIssueTableView.bringSubviewToFront(cellLoadingIndicator)
        
        // Checking for 3D Touch Support
            if (traitCollection.forceTouchCapability == .Available){
                registerForPreviewingWithDelegate(self, sourceView: view)
            }

        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.blackColor()
        
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            self!.handleRefresh()
//            self!.holdRefreshControl()
            self!.tableView.dg_stopLoading()
            }, loadingView: loadingView)
            tableView.dg_setPullToRefreshFillColor(UIColor.opaqueGoldenWordsYellow())
            tableView.dg_setPullToRefreshBackgroundColor(UIColor.blackColor())
        
//        currentIssueTableView.rowHeight = UITableViewAutomaticDimension
//        currentIssueTableView.estimatedRowHeight = 80
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.backgroundColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }
    
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
                //                handleRefresh()
                holdRefreshControl()
//                animateRefreshStep1()
                
            }
        }
    }
    
    /*
    func getNextColor() -> UIColor {
        var colorsArray: [UIColor] = [goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow, goldenWordsYellow]
        
        if currentColorIndex == colorsArray.count {
            currentColorIndex = 0
        }
        
        let returnColor = colorsArray[currentColorIndex]
        ++currentColorIndex
        
        return returnColor
    }
    */
    
    func holdRefreshControl() {
        timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "handleRefresh", userInfo: nil, repeats: true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return (currentIssueArticlesAuthor.count + 1) // As of 18/08/2015, this returns 5
        
        return (currentIssueObjects.count)
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell {
    
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CurrentIssueArticlesTableCellIdentifier, forIndexPath: indexPath) as! CurrentIssueArticlesTableViewCell
                
        if let currentIssueObject = currentIssueObjects.objectAtIndex(indexPath.row) as? IssueElement {
            
            let title = currentIssueObject.title ?? ""
            
            let timeStampDateObject = NSDate(timeIntervalSince1970: NSTimeInterval(currentIssueObject.timeStamp))
            let timeStampDateString = dateFormatter.stringFromDate(timeStampDateObject) ?? "Date unknown"
        
            let author = currentIssueObject.author ?? ""
            
            let issueNumber = currentIssueObject.issueNumber ?? ""
            let volumeNumber = currentIssueObject.volumeNumber ?? ""
            
            let articleContent = currentIssueObject.articleContent ?? ""
            
            let nodeID = currentIssueObject.nodeID ?? 0
        
        
//            cell.currentIssueArticlesHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
            cell.currentIssueArticlesHeadlineLabel.text = title
            
//            cell.currentIssueArticlesAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            cell.currentIssueArticlesAuthorLabel.text = author
            
//            cell.currentIssueArticlesPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//            cell.currentIssueArticlesPublishDateLabel.text = timeStampDateString
            
            // This "if" statement serves the sole purpose of only updating the label's text once.
            if row == 0 {
                let firstElementInIssue = currentIssueObjects.objectAtIndex(0) as! IssueElement
                headerVolumeAndIssueLabel.text = "Volume \(firstElementInIssue.volumeNumber) - Issue \(firstElementInIssue.issueNumber)"
            }
            

            
            /*
            if row == 0 {
                
                cell.userInteractionEnabled = false
                
                // The URL isn't being obtained properly because the row is not right. I should sort the array first and then get the URL from row 0.
                let imageURL = (currentIssueObjects.objectAtIndex(row) as! IssueElement).imageURL
                
                cell.currentIssueArticlesHeadlineLabel.textColor = UIColor.clearColor()
                cell.currentIssueArticlesAuthorLabel.textColor = UIColor.clearColor()
                cell.currentIssueArticlesPublishDateLabel.textColor = UIColor.clearColor()
                
                cell.request?.cancel()
                
                if let image = self.imageCache.objectForKey(imageURL) as? UIImage {
                    cell.currentIssueArticlesBackgroundImageView.image = image
                } else {
                    cell.currentIssueArticlesBackgroundImageView.image = UIImage(named: "reveal Image")
                    cell.request = Alamofire.request(.GET, imageURL).responseImage() { response in
                        if response.result.error == nil && response.result.value != nil {
                            self.imageCache.setObject(response.result.value!, forKey: response.request!.URLString)
                            cell.currentIssueArticlesBackgroundImageView.image = response.result.value
                        } else {
            
                        }
                    }
                }
                cell.currentIssueArticlesBackgroundImageView.hidden = false
            }
            else {
                cell.currentIssueArticlesBackgroundImageView.hidden = true
        }
        */
    
    } else {
            
            cell.currentIssueArticlesHeadlineLabel.text = nil
            cell.currentIssueArticlesAuthorLabel.text = nil
//            cell.currentIssueArticlesPublishDateLabel.text = nil
        
    }
        return cell
}
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let row = indexPath.row
//        tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
//    }
    
    func closeCallback() {
        
    }
    
    func cancelCallback() {
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView?.indexPathForRowAtPoint(location) else { return nil }
        
        guard let cell = tableView?.cellForRowAtIndexPath(indexPath) else { return nil }
        
        guard let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("CurrentIssueDetailViewControllerIdentifier") as? CurrentIssueDetailViewController else { return nil }
        
        if let currentIssueObject = currentIssueObjects.objectAtIndex(indexPath.row) as? IssueElement {
            
            let nodeID = currentIssueObject.nodeID ?? 714
            
            let title = currentIssueObject.title ?? ""
            
            let author = currentIssueObject.author ?? ""
            
            let articleContent = currentIssueObject.articleContent ?? ""
    
            let currentIssueHeadlineFor3DTouch = title
            let currentIssueAuthorFor3DTouch = author
            let currentIssueArticleContentFor3DTouch = articleContent
            
            detailViewController.currentIssueArticleTitleThroughSegue = currentIssueHeadlineFor3DTouch
            detailViewController.currentIssueAuthorThroughSegue = currentIssueAuthorFor3DTouch
            detailViewController.currentIssueArticleContentThroughSegue = currentIssueArticleContentFor3DTouch
            
            detailViewController.preferredContentSize = CGSize(width: 0.0, height: 600)
            
            previewingContext.sourceRect = cell.frame
            
        }
        
        return detailViewController

    }
    
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
    }
    
    
        
        
//        switch(row) {
//            
//            
//        case 0:
//            
//            let cellWithCoverImage = tableView.dequeueReusableCellWithIdentifier(CurrentIssueFrontCoverTableCellIdentifier, forIndexPath: indexPath) as! CurrentIssueFrontCoverTableViewCell
//            
//            if let currentIssueFrontCoverObject = currentIssueObjects.objectAtIndex(indexPath.row) as? IssueElement {
//                
//                let title = currentIssueFrontCoverObject.title ?? ""
//                
//                let timeStampDateObject = NSDate(timeIntervalSince1970: NSTimeInterval(currentIssueFrontCoverObject.timeStamp))
//                let timeStampDateString = dateFormatter.stringFromDate(timeStampDateObject)
//                
//                let issueNumber = currentIssueFrontCoverObject.issueNumber ?? ""
//                let volumeNumber = currentIssueFrontCoverObject.volumeNumber ?? ""
//                
//                let nodeID = currentIssueFrontCoverObject.nodeID ?? 0
//                
//                let imageURL = currentIssueFrontCoverObject.imageURL ?? ""
//                
//                
//                cellWithCoverImage.request?.cancel()
//                
//                if let coverImage = self.imageCache.objectForKey(imageURL) as? UIImage {
//                    cellWithCoverImage.currentIssueFrontCoverImageView.image = coverImage
//                } else {
//                    cellWithCoverImage.currentIssueFrontCoverImageView.image = nil
//                    cellWithCoverImage.request = Alamofire.request(.GET, imageURL).responseImage() { response in
//                        if let coverImage = response.result.value {
//                            self.imageCache.setObject(response.result.value!, forKey: imageURL)
//                            cellWithCoverImage.currentIssueFrontCoverImageView.image = coverImage
//                            
//                        } else {
//                            
//                            return
//                            
//                        }
//                    }
//                }
//            } else {
//                
//                break
//            }
//            
//            return cellWithCoverImage
//            
//            // Populating data in the "Articles" type cells
//            
//            
//        
//        default:
//            
//            let cellWithoutCoverImage = tableView.dequeueReusableCellWithIdentifier(CurrentIssueArticlesTableCellIdentifier, forIndexPath: indexPath) as! CurrentIssueArticlesTableViewCell
//            
//            if let currentIssueArticleObject = currentIssueObjects.objectAtIndex(indexPath.row) as? IssueElement {
//                
//                let title = currentIssueArticleObject.title ?? ""
//                
//                let timeStampDateObject = NSDate(timeIntervalSince1970: NSTimeInterval(currentIssueArticleObject.timeStamp))
//                let timeStampDateString = dateFormatter.stringFromDate(timeStampDateObject)
//                
//                let author = currentIssueArticleObject.author ?? ""
//                
//                let issueNumber = currentIssueArticleObject.issueNumber ?? ""
//                let volumeNumber = currentIssueArticleObject.volumeNumber ?? ""
//                
//                let articleContent = currentIssueArticleObject.articleContent ?? ""
//                
//                let nodeID = currentIssueArticleObject.nodeID ?? 0
//                
//                
//                cellWithoutCoverImage.currentIssueArticlesHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
//                cellWithoutCoverImage.currentIssueArticlesHeadlineLabel.text = title
//                
//                cellWithoutCoverImage.currentIssueArticlesAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//                cellWithoutCoverImage.currentIssueArticlesAuthorLabel.text = author
//                
//                cellWithoutCoverImage.currentIssueArticlesPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
//                cellWithoutCoverImage.currentIssueArticlesPublishDateLabel.text = timeStampDateString
//                
//                return cellWithoutCoverImage
//                
//            } else {
//                
//                let emptyCell = UITableViewCell()
//                
//                return emptyCell
//            }
//        }
//        
//        let emptyCell = UITableViewCell()
//        
//        return emptyCell
//        
//    }
    
    
    
/*
            let cell:CurrentIssueArticlesTableViewCell = CurrentIssueArticlesTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CurrentIssueArticlesIdentifier")
            
            if let cIAHeadlineLabel = cell.currentIssueArticlesHeadlineLabel {
                cIAHeadlineLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                cIAHeadlineLabel.text = currentIssueArticlesHeadline[row]
            }
            
            if let cIAAuthorLabel = cell.currentIssueArticlesAuthorLabel {
                cIAAuthorLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
                cIAAuthorLabel.text = currentIssueArticlesAuthor[row]
            }
            
            if let cIAPublishDateLabel = cell.currentIssueArticlesPublishDateLabel {
                cIAPublishDateLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
                cIAPublishDateLabel.text = currentIssueArticlesPublishDate[row]
            }
*/
    

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
        
        if segue.identifier == "ShowCurrentIssueArticleDetail" {
            
            let detailViewController = segue.destinationViewController as! CurrentIssueDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row
            
            detailViewController.currentIssueArticleTitleThroughSegue = currentIssueObjects.objectAtIndex((myIndexPath?.row)!).title
            detailViewController.currentIssueTimeStampThroughSegue = currentIssueObjects.objectAtIndex((myIndexPath?.row)!).timeStamp
            detailViewController.currentIssueAuthorThroughSegue = currentIssueObjects.objectAtIndex((myIndexPath?.row)!).author
            detailViewController.currentIssueArticleContentThroughSegue = currentIssueObjects.objectAtIndex((myIndexPath?.row)!).articleContent
            detailViewController.currentIssueNodeIDThroughSegue = currentIssueObjects.objectAtIndex((myIndexPath?.row)!).nodeID
            detailViewController.currentIssueIssueIndexThroughSegue = currentIssueObjects.objectAtIndex((myIndexPath?.row)!).issueNumber
            detailViewController.currentIssueVolumeIndexThroughSegue = currentIssueObjects.objectAtIndex((myIndexPath?.row)!).volumeNumber
            
        }
    }
    
    func populateCurrentIssue() {
        if populatingCurrentIssue {
            return
        }
        
        populatingCurrentIssue = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.cellLoadingIndicator.startAnimating()
        
        Alamofire.request(GWNetworking.Router.Issue).responseJSON() { response in
            if let JSON = response.result.value {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                    
                    var nodeIDArray : [Int]
                    
                    if (JSON .isKindOfClass(NSDictionary)) {
                        
                        for node in JSON as! Dictionary<String, AnyObject> {
                            
                            let nodeIDValue = node.0
                            var lastItem : Int = 0
                            
                            self.nodeIDArray.addObject(nodeIDValue)
                            
                            if let issueElement : IssueElement = IssueElement(title: "Just another Golden Words article", nodeID: 0, timeStamp: 1442239200, imageURL: "http://goldenwords.ca/sites/all/themes/custom/gw/logo.png", author: "Staff", issueNumber: "Issue # error", volumeNumber: "Volume # error", articleContent: "Looks like the server is acting up again!", coverImageInteger: "init", coverImage: UIImage()) {
                                
                                issueElement.title = node.1["title"] as! String
                                issueElement.nodeID = Int(nodeIDValue)!
                                
                                let timeStampString = node.1["revision_timestamp"] as! String
                                issueElement.timeStamp = Int(timeStampString)!
                                
                                if let imageURL = node.1["image_url"] as? String {
                                    issueElement.imageURL = imageURL
                                }
                                
                                if let author = node.1["author"] as? String {
                                    issueElement.author = author
                                }
//                                issueElement.author = String(node.1["author"])
                                if let issueNumber = node.1["issue_int"] as? String {
                                    issueElement.issueNumber = issueNumber
                                }
                                if let volumeNumber = node.1["volume_int"] as? String {
                                    issueElement.volumeNumber = volumeNumber
                                }
                                
                                if let articleContent = node.1["html_content"] as? String {
                                    issueElement.articleContent = articleContent
                                }
//
//                                if let coverImageInteger = node.1["cover_image"] as? String {
//                                    issueElement.coverImageInteger = coverImageInteger
//                                }
//                                issueElement.coverImageInteger = String(node.1["cover_image"]) // addition specific to the Current Issue View Controller
                                
                                if issueElement.articleContent.characters.count > 50 {
                                    lastItem = self.temporaryCurrentIssueObjects.count
                                    self.temporaryCurrentIssueObjects.addObject(issueElement)
                                    // print(issueElement.nodeID)
                                }

                                let indexPaths = (lastItem..<self.temporaryCurrentIssueObjects.count).map {
                                    NSIndexPath(forItem: $0, inSection: 0) }
                                }
                            }
                        
//                            let coverImageSortDescriptor = NSSortDescriptor(key: "coverImageInteger", ascending: false)
//                            self.temporaryCurrentIssueObjects.sortUsingDescriptors([coverImageSortDescriptor])
                        
                            // Sorting with decreasing timestamp from top to bottom.
                            let timestampSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
                            self.temporaryCurrentIssueObjects.sortUsingDescriptors([timestampSortDescriptor])
                            
                        }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.currentIssueObjects = self.temporaryCurrentIssueObjects
                        self.currentIssueTableView.reloadData()
                        
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                        self.cellLoadingIndicator.stopAnimating()
                        
                        self.populatingCurrentIssue = false
                }
            }
            } else {
                
                let customIcon = UIImage(named: "Danger")
                let downloadErrorAlertView = JSSAlertView().show(self, title: "Download failed", text: "Please connect to the Internet and try again.", buttonText:  "OK", color: UIColor.redColor(), iconImage: customIcon)
                downloadErrorAlertView.addAction(self.closeCallback)
                downloadErrorAlertView.setTitleFont("ClearSans-Bold")
                downloadErrorAlertView.setTextFont("ClearSans")
                downloadErrorAlertView.setButtonFont("ClearSans-Light")
                downloadErrorAlertView.setTextTheme(.Light)
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                self.cellLoadingIndicator.stopAnimating()
                
                self.populatingCurrentIssue = false
                
            }
    }
}
   
    func handleRefresh() {
        
//        goldenWordsRefreshControl.beginRefreshing()
        
//        self.cellLoadingIndicator.startAnimating()
//        self.currentIssueTableView.bringSubviewToFront(cellLoadingIndicator)
        
        self.populatingCurrentIssue = false
        
        populateCurrentIssue()
        
//        self.cellLoadingIndicator.stopAnimating()
        
//        goldenWordsRefreshControl.endRefreshing()
        
    }
    
}