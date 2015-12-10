//
//  VideosViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-18.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class VideosViewController: UITableViewController {
    
    // Hamburger button declaration
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // Table View Outlet used for the refresh control
    @IBOutlet var videosTableView: UITableView!

    var temporaryVideoObjects = NSMutableOrderedSet(capacity: 1000)
    var videoObjects = NSMutableOrderedSet(capacity: 1000)
    
    var goldenWordsRefreshControl = UIRefreshControl()
    
    var revealViewControllerIndicator : Int = 0
    
    let imageCache = NSCache()
    
    var customView: UIView!
    
    var labelsArray: [UILabel] = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer : NSTimer!
    
    var populatingVideos = false
    
    var currentPage = 0
    
    let VideoTableCellIdentifier = "VideoTableCellIdentifier"
    
    var dateFormatter = NSDateFormatter()
    
    var nodeIDArray = NSMutableArray()
    
    var timeStampDateString : String!
    
    var cellLoadingIndicator = UIActivityIndicatorView()
    
    var downloadErrorAlertViewCount = 0
    
    // Variables for refresh control - end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadErrorAlertViewCount = 0
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        // Hamburger button configuration
        if let revealViewControllerInstance = self.revealViewController()
        {
            revealViewControllerIndicator = 1
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            revealViewControllerInstance.rearViewRevealWidth = 280
        }
                
        // Preliminary refresh control "set up"
        videosTableView.delegate = self
        videosTableView.dataSource = self
        
        // Creating and configuring the goldenWordsRefreshControl subview
        goldenWordsRefreshControl = UIRefreshControl()
        goldenWordsRefreshControl.backgroundColor = UIColor.goldenWordsYellow()
        goldenWordsRefreshControl.tintColor = UIColor.whiteColor()
        videosTableView.addSubview(goldenWordsRefreshControl)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Videos"
        
//        loadCustomRefreshContents()
        
        populateVideos()
        
        self.dateFormatter.dateFormat = "dd/MM/yy"
        
        // Static data to test my table view controller

        tableView.estimatedRowHeight = 50
        
        self.cellLoadingIndicator.backgroundColor = UIColor.goldenWordsYellow()
        self.cellLoadingIndicator.hidesWhenStopped = true
        self.cellLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.cellLoadingIndicator.color = UIColor.goldenWordsYellow()
        self.cellLoadingIndicator.center = self.videosTableView.center
        self.videosTableView.addSubview(cellLoadingIndicator)
        self.videosTableView.bringSubviewToFront(cellLoadingIndicator)

    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if goldenWordsRefreshControl.refreshing {
            if !isAnimating {
                holdRefreshControl()
            }
        }
    }
    
    func holdRefreshControl() {
        timer = NSTimer.scheduledTimerWithTimeInterval(MyGlobalVariables.holdRefreshControlTime, target: self, selector: "handleRefresh", userInfo: nil, repeats: true)
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
        return videoObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier(VideoTableCellIdentifier, forIndexPath: indexPath) as! VideoTableViewCell
        
        if let videoObject = videoObjects.objectAtIndex(indexPath.row) as? VideoElement {
            
            let title = videoObject.title ?? ""
            
            let timeStampDateObject = NSDate(timeIntervalSince1970: NSTimeInterval(videoObject.timeStamp))
            let timeStampDateString = dateFormatter.stringFromDate(timeStampDateObject) ?? "Date unknown"
            
            let author = videoObject.author ?? ""
            
            let issueNumber = videoObject.issueNumber ?? ""
            let volumeNumber = videoObject.volumeNumber ?? ""
            
            let nodeID = videoObject.nodeID ?? 0
            
            let thumbnailURL = videoObject.thumbnailURL ?? "http://goldenwords.ca/sites/all/themes/custom/gw/logo.png"
            
            cell.videoHeadlineLabel.text = title
            cell.videoPublishDateLabel.text = timeStampDateString
            
            cell.request?.cancel()
            
            if let image = self.imageCache.objectForKey(thumbnailURL) as? UIImage {
                
                cell.videoThumbnailImage.image = image
                
            } else {
                
                cell.videoThumbnailImage.image = nil
                cell.request = Alamofire.request(.GET, thumbnailURL).responseImage() { response in
                    if let image = response.result.value {
                        self.imageCache.setObject(response.result.value!, forKey: thumbnailURL)
                        if cell.videoThumbnailImage.image == nil {
                            cell.videoThumbnailImage.image = image
                        }
                    }
                }
            }
        } else {
            
            cell.videoHeadlineLabel.text = nil
            cell.videoPublishDateLabel.text = nil
            cell.videoThumbnailImage.image = UIImage(named: "reveal Image")
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = indexPath.row
        
        if let videoObject = videoObjects.objectAtIndex(indexPath.row) as? VideoElement {
            let videoURL = NSURL(string: videoObject.videoURL)
            UIApplication.sharedApplication().openURL(videoURL!)
        
        tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
            
        }
    }
    
    func closeCallback() {
        
    }
    
    func cancelCallback() {
        
    }

    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowVideo" {
            
            let detailViewController = segue.destinationViewController as! VideosDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            let row = myIndexPath?.row

            if let videoObject = videoObjects.objectAtIndex((myIndexPath?.row)!) as? VideoElement {
                    detailViewController.videoURLThroughSegue = videoObject.videoURL
            }
        }
    }
    */
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.75) {
            populateVideos()
        }
    }
    
    func populateVideos() {
        
        if populatingVideos {
            return
        }
        populatingVideos = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.cellLoadingIndicator.startAnimating()
        
        Alamofire.request(GWNetworking.Router.Videos(currentPage)).responseJSON() { response in
            if let JSON = response.result.value {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                    
                    /* Making an array of all the node IDs from the JSON file */
                    var nodeIDArray : [Int]
                    
                    if (JSON .isKindOfClass(NSDictionary)) {
                        
                        for node in JSON as! Dictionary<String, AnyObject> {
                            
                            let nodeIDValue = node.0
                            var lastItem : Int = 0
                            
                            self.nodeIDArray.addObject(nodeIDValue)
                            
                            if let videoElement: VideoElement = VideoElement(title: "Golden Words Video", nodeID: 0, timeStamp: 1442239200, videoURL: "https://www.youtube.com/watch?v=XvK-5emkgLs", thumbnailURL:  "http://goldenwords.ca/sites/all/themes/custom/gw/logo.png", author: "Staff", issueNumber: "Issue # error", volumeNumber: "Volume # error") {
                                
                                videoElement.title = node.1["title"] as! String
                                videoElement.nodeID = Int(nodeIDValue)!
                                
                                let timeStampString = node.1["revision_timestamp"] as! String
                                videoElement.timeStamp = Int(timeStampString)!
                                
                                if let videoURL = node.1["video_url"] as? String {
                                    videoElement.videoURL = videoURL
                                }
                                
                                let location = videoElement.videoURL.characters.count - 11
                                var videoID = videoElement.videoURL.substringFromIndex(videoElement.videoURL.startIndex.advancedBy(location))
                                
                                
                                if let thumbnailURL = "http://i1.ytimg.com/vi/" + videoID + "/maxresdefault.jpg" as? String {
                                    videoElement.thumbnailURL = thumbnailURL
                                }

                                
                                if let author = node.1["author"] as? String {
                                    videoElement.author = author
                                }
                                if let issueNumber = node.1["issue_int"] as? String {
                                    videoElement.issueNumber = issueNumber
                                }
                                if let volumeNumber = node.1["volume_int"] as? String {
                                    videoElement.volumeNumber = volumeNumber
                                }
                                
//                                if (videoElement.videoURL != "https://www.youtube.com/watch?v=XvK-5emkgLs") {
                                    lastItem = self.temporaryVideoObjects.count
                                    self.temporaryVideoObjects.addObject(videoElement)
//                                }
                                
                                let indexPaths = (lastItem..<self.temporaryVideoObjects.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                                
                            }
                        }
                        
                        /* Sorting the elements in order of newest to oldest (as the array index increases] */
                        let timestampSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
                        self.temporaryVideoObjects.sortUsingDescriptors([timestampSortDescriptor])
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        if self.videoObjects != self.temporaryVideoObjects {
                        self.videoObjects = self.temporaryVideoObjects
                        }
                        self.videosTableView.reloadData()
                        
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                        self.cellLoadingIndicator.stopAnimating()
                        
                        self.currentPage++
                        self.populatingVideos = false
                        
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
        
        self.currentPage = 0
        
        self.cellLoadingIndicator.startAnimating()
        self.videosTableView.bringSubviewToFront(cellLoadingIndicator)
        
        self.populatingVideos = false
        populateVideos()
        
        self.cellLoadingIndicator.stopAnimating()
        
        goldenWordsRefreshControl.endRefreshing()
        
        
    }
}