//
//  PhotoBrowserCollectionViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-15.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PhotoBrowserCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet var picturesCollectionView: UICollectionView!
    
    var temporaryPictureObjects = NSMutableOrderedSet(capacity: 1000)
    var pictureObjects = NSMutableOrderedSet(capacity: 1000)

    var goldenWordsRefreshControl = UIRefreshControl()
    
    var revealViewControllerIndicator : Int = 0
    
    let imageCache = NSCache()
    
    var customView: UIView!
    
    var labelsArray: [UILabel] = []
    
    var isAnimating = false
    
    var currentColorIndex = 0
    
    var currentLabelIndex = 0
    
    var timer : NSTimer!
    
    var populatingPhotos = false
    
    var currentPage = 0
    
    let PhotoBrowserCellIdentifier = "PhotoBrowserCell"
    
    var dateFormatter = NSDateFormatter()
    
    var nodeIDArray = NSMutableArray()
    
    var timeStampDateString : String!
    
    var cellLoadingIndicator = UIActivityIndicatorView()
    
    var scrollViewDidScrollLoadingIndicator = UIActivityIndicatorView()
    
//    let PhotoBrowserFooterViewIdentifier = "PhotoBrowserFooterView" // Identifier used for the footer view (with Featured and Downloads)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(PhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCellIdentifier)
        
        self.cellLoadingIndicator.backgroundColor = UIColor.goldenWordsYellow()
        self.cellLoadingIndicator.hidesWhenStopped = true
        
        // Hamburger menu button setup
    if self.revealViewController() != nil {
        revealViewControllerIndicator = 1
        menuButton.target = self.revealViewController()
        menuButton.action = "revealToggle:"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = 280
        
        // Preliminary refresh control "set up"
        collectionView!.delegate = self
        collectionView!.dataSource = self
        
        // Creating and configuring the goldenWordsRefreshControl subview
        goldenWordsRefreshControl = UIRefreshControl()
        goldenWordsRefreshControl.backgroundColor = UIColor.goldenWordsYellow()
        goldenWordsRefreshControl.tintColor = UIColor.whiteColor()
        self.collectionView!.addSubview(goldenWordsRefreshControl)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.title = "Pictures"
        
//        loadCustomRefreshContents()
        
        setupView()
        
        populatePhotos()
        
        self.dateFormatter.dateFormat = "dd/MM/yy"
        
        self.cellLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.cellLoadingIndicator.color = UIColor.goldenWordsYellow()
        self.cellLoadingIndicator.center = (self.view?.center)!
        self.collectionView!.addSubview(cellLoadingIndicator)
        self.collectionView!.bringSubviewToFront(cellLoadingIndicator)
        
        if (traitCollection.forceTouchCapability == .Available) {
            registerForPreviewingWithDelegate(self, sourceView: view)
        }

//        self.scrollViewDidScrollLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        self.scrollViewDidScrollLoadingIndicator.color = goldenWordsYellow
//        self.scrollViewDidScrollLoadingIndicator.center =
//        self.collectionView!.addSubview(scrollViewDidScrollLoadingIndicator)
//        self.collectionView!.bringSubviewToFront(scrollViewDidScrollLoadingIndicator)
        
//        self.collectionView!.reloadData()
        
        /*
        self.dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        self.dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let currentDateAndTime = NSDate()
        let updateString = "Last updated at " + self.dateFormatter.stringFromDate(currentDateAndTime)
        self.goldenWordsRefreshControl.attributedTitle = NSAttributedString(string: updateString)
        */
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    
    func loadCustomRefreshContents() {
        let refreshContents = NSBundle.mainBundle().loadNibNamed("RefreshContents", owner: self, options: nil)
        
        customView = refreshContents[0] as! UIView
        customView.frame = goldenWordsRefreshControl.bounds
        
        for (var i=0; i < customView.subviews.count; i++) {
            labelsArray.append(customView.viewWithTag(i+1) as! UILabel)
            
            goldenWordsRefreshControl.addSubview(customView)
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
                        if self.goldenWordsRefreshControl.refreshing {
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
    
//    func endOfWork() {
//        goldenWordsRefreshControl.endRefreshing()
//        
//        timer.invalidate()
//        timer = nil
//    }

    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return pictureObjects.count
        return (pictureObjects.count) // setting an arbitrary value in case pictureObjects is not getting correctly populated
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        /*
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath) as! PhotoBrowserCollectionViewCell
        
        cell.imageView.image = UIImage(named: "reveal Image")
        cell.backgroundColor = UIColor.blackColor()
        
        return cell
        */
  
    
//    let imageURL = (pictureObjects.objectAtIndex(indexPath.row) as! PictureElement).imageURL
//    
//    cell.imageView.image = nil
//    cell.request?.cancel()
//    
//    cell.request = Alamofire.request(.GET, imageURL).responseImage() {
//        (request, _, image, error) in
//        if error == nil && image != nil {
//        cell.imageView.image = image
//    
//        }
//    }
//    
//        return cell
        
//        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath) as? PhotoBrowserCollectionViewCell else {
//            
//            print("cell could not be initialized as PhotoBrowserCollectionViewCell, hence it will be casted to another default UICollectionViewCell type")
//            return picturesCollectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath)
//            
//            
//        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoBrowserCellIdentifier, forIndexPath: indexPath) as! PhotoBrowserCollectionViewCell
        
        if let pictureObject = pictureObjects.objectAtIndex(indexPath.row) as? PictureElement {
            
            let title = pictureObject.title ?? "" // if pictureObject.title == nil, then we return an empty string
            
            let timeStampDateObject = NSDate(timeIntervalSince1970: NSTimeInterval(pictureObject.timeStamp))
            let timeStampDateString = dateFormatter.stringFromDate(timeStampDateObject)
            
            let author = pictureObject.author ?? ""
            
            let issueNumber = pictureObject.issueNumber ?? ""
            let volumeNumber = pictureObject.volumeNumber ?? ""
            
            let nodeID = pictureObject.nodeID ?? 0
            
            let imageURL = pictureObject.imageURL ?? "http://goldenwords.ca/sites/all/themes/custom/gw/logo.png"
            
            cell.request?.cancel()
            
            // Using image cache system to make sure the table view works even when rapidly scrolling down the screen.
            if var image = self.imageCache.objectForKey(imageURL) as? UIImage {
                
                cell.imageView.image = image
                
            } else {
                
                cell.imageView.image = nil
                cell.request = Alamofire.request(.GET, imageURL).responseImage() { response in
                    if var image = response.result.value {
//                        self.imageCache.setObject(response.result.value!, forKey: response.request!.URLString)
                        self.imageCache.setObject(response.result.value!, forKey: imageURL)
                        if cell.imageView.image == nil {
                            cell.imageView.image = image
                        }
                    }
                }
            }
        }
        
        return cell
}
    
    
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView?.indexPathForItemAtPoint(location) else { return nil }
        
        guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? PhotoBrowserCollectionViewCell else { return nil }
        
        guard let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("PhotoViewerViewControllerIdentifier") as? PhotoViewerViewController else { return nil }
        
        if let pictureObject = pictureObjects.objectAtIndex(indexPath.row) as? PictureElement {
            
            let imageURL = pictureObject.imageURL ?? ""
            
            let pictureImageURLFor3DTouch = imageURL
            
            Alamofire.request(.GET, pictureImageURLFor3DTouch).responseImage { response in
                
                if let image = response.result.value {
                    print("image downloaded : \(image)")
                    
                    detailViewController.imageToStore = image
                    detailViewController.imageView.image = image
                    
                }
            }
            
            detailViewController.preferredContentSize = CGSize(width: 0, height: 0)
            
            previewingContext.sourceRect = cell.imageView.frame
            
        }
        
        return detailViewController
        
    }
    
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        showViewController(viewControllerToCommit, sender: self)
    }
    
    
    
//        cell.request?.cancel()
//        
//        // Using image cache system to make sure the table view works even when rapidly scrolling down the screen.
//        if let image = self.imageCache.objectForKey(imageURL) as? UIImage {
//
//            cell.imageView.image = image
//            
//        } else {
//            
//            cell.imageView.image = nil
//            
//            cell.request = Alamofire.request(.GET, imageURL).responseImage { response in
//                
//                if let image = response.result.value {
//                    
//                    self.imageCache.setObject(response.result.value!, forKey: response.request!.URLString)
//                    
//                    cell.imageView.image = image
//                    
//                } else {
//                    
//                }
//                
//                
//            }
   
//            cell.request = Alamofire.request(.GET, imageURL).validate(contentType: ["image/*"]).responseImage() {
//                (request, _, result) in
//                if result.error == nil && result.value != nil {
//                    
//                    self.imageCache.setObject(result.value!, forKey: request!.URLString)
//                    
//                    cell.imageView.image = result.value
//                } else {
//                    
//                }
//            }

    
//    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PhotoBrowserFooterViewIdentifier, forIndexPath: indexPath)
//    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("ShowPhoto", sender: self.collectionView!.cellForItemAtIndexPath(indexPath))
        self.performSegueWithIdentifier("ShowPhoto", sender: self)
    }
    
    func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Configuring out collection view flow layout
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.size.width) / 3
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
//        layout.footerReferenceSize = CGSize(width: picturesCollectionView!.bounds.size.width, height: 100.0)
        
        collectionView!.collectionViewLayout = layout
        
        navigationItem.title = "Pictures"

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(((self.collectionView?.frame.width)!*0.5)-2, self.collectionView!.frame.height/3)
    }
    

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto" {
            
            let detailViewController = segue.destinationViewController as! PhotoViewerViewController
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as! NSIndexPath
            
            detailViewController.imageURLForViewerController = pictureObjects.objectAtIndex(indexPath.item).imageURL
            
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + view.frame.size.height > scrollView.contentSize.height * 0.25) {
            populatePhotos()
        }
    }
    
    func populatePhotos() {
        
        if populatingPhotos {
            return
        }
        populatingPhotos = true
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.cellLoadingIndicator.startAnimating()
//        self.temporaryPictureObjects.removeAllObjects()
        
        Alamofire.request(GWNetworking.Router.Pictures(self.currentPage)).responseJSON() { response in
            if let JSON = response.result.value {
                
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                
                var nodeIDArray : [Int]
                
                if (JSON .isKindOfClass(NSDictionary)) {
                    
                    for node in JSON as! Dictionary<String, AnyObject> {
                        
                        let nodeIDValue = node.0
                        var lastItem : Int = 0
                        
                        self.nodeIDArray.addObject(nodeIDValue)
                        
                        if let pictureElement : PictureElement = PictureElement(title: "Picture", nodeID: 0, timeStamp: 1442239200, imageURL: "http://goldenwords.ca/sites/all/themes/custom/gw/logo.png", author: "Staff", issueNumber: "Issue # error", volumeNumber: "Volume # error") {
                            
                            pictureElement.title = node.1["title"] as! String
                            pictureElement.nodeID = Int(nodeIDValue)!
                            
                            let timeStampString = node.1["revision_timestamp"] as! String
                            pictureElement.timeStamp = Int(timeStampString)!
                            
                            if let imageURL = node.1["image_url"] as? String {
                                pictureElement.imageURL = imageURL
                            }
                            
                            if let author = node.1["author"] as? String {
                                pictureElement.author = author
                            }
                            
                            if let issueNumber = node.1["issue_int"] as? String {
                                pictureElement.issueNumber = issueNumber
                            }
                            
                            if let volumeNumber = node.1["volume_int"] as? String {
                                pictureElement.volumeNumber = volumeNumber
                            }
                            
                            if self.pictureObjects.containsObject(pictureElement) {
                                // do not add the pictureElement to the set of pictures
                            } else {
                            lastItem = self.temporaryPictureObjects.count // Using a temporary set to not handle the dataSource set directly (safer).
                            self.temporaryPictureObjects.addObject(pictureElement)
                            }
                            
                            let indexPaths = (lastItem..<self.temporaryPictureObjects.count).map { NSIndexPath(forItem: $0, inSection: 0) }
                        }
                        
                    }
                    
                    /* Sorting the elements in order of newest to oldest (as the array index increases] */
                    let timeStampSortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
                    self.temporaryPictureObjects.sortUsingDescriptors([timeStampSortDescriptor])
                    
                }
                dispatch_async(dispatch_get_main_queue()) {
                    
//                    self.pictureObjects = self.temporaryPictureObjects
                    for object in self.temporaryPictureObjects {
                        self.pictureObjects.addObject(object)
                    }
                    
                    self.temporaryPictureObjects.removeAllObjects()
                    
                    self.collectionView!.reloadData()
                
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                    self.cellLoadingIndicator.stopAnimating()
                    self.goldenWordsRefreshControl.endRefreshing()

                    self.currentPage++
                    self.populatingPhotos = false
                }
            }
        }
    }
}
    
    
    
    func handleRefresh() {
        
        goldenWordsRefreshControl.beginRefreshing()
        
        self.pictureObjects.removeAllObjects()
        self.temporaryPictureObjects.removeAllObjects()
                
        self.currentPage = 0
        
        // self.collectionView!.reloadData()
        
//        self.cellLoadingIndicator.startAnimating()
//        self.picturesCollectionView.bringSubviewToFront(cellLoadingIndicator)
        
        self.populatingPhotos = false
        populatePhotos()
        
//        self.cellLoadingIndicator.stopAnimating()
        
        
    }
}
