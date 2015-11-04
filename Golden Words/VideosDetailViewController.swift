//
//  VideosDetailViewController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-11-02.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit
//import YouTubePlayer

class VideosDetailViewController: UIViewController {
    
    @IBOutlet var videoDetailView: UIView!
    
    var videoURLThroughSegue : String = "https://www.youtube.com/watch?v=XvK-5emkgLs"
    
//    var videoPlayer = YouTubePlayerView(frame: playerFrame)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoURL = NSURL(string: videoURLThroughSegue)
        UIApplication.sharedApplication().openURL(videoURL!)

/*
        let playerFrame = CGRect(origin: CGPointZero, size: videoDetailView.bounds.size)
        videoDetailView.bringSubviewToFront(videoPlayer)
        
        videoPlayer.playerVars = [
        "playsinline": "1",
        "controls": "0",
        "showinfo": "0"]
        
        videoPlayer.loadVideoID("3PWuKlnOI0c")
*/
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    @IBAction func playTheVideo(sender: UIButton) {
        
        if videoPlayer.ready {
            if videoPlayer.playerState != YouTubePlayerState.Playing {
                videoPlayer.play()
            } else {
                videoPlayer.pause()
            }
        }
    }
        */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
