//
//  MovieDetailViewController.swift
//  rotten
//
//  Created by Erin Chuang on 9/15/14.
//  Copyright (c) 2014 Erin Chuang. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movies: [NSDictionary] = []
    var movieId: String!

    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var synopsisLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var url = "http://api.rottentomatoes.com/api/public/v1.0/movies/\(self.movieId).json?apikey=dagqdghwaq3e3mxyrp7kmmj5"
        var request = NSURLRequest(URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            var year = object["year"] as Int
            var title = object["title"] as String
            self.navigationItem.title = title
            self.titleLabel.text = "\(title) (\(year))"
            var score = object["ratings"] as NSDictionary
            var criticScore = score["critics_score"] as Int
            var audienceScore = score["audience_score"] as Int
            self.scoreLabel.text = "Critics score: \(criticScore), Audience score: \(audienceScore)"
            self.ratingLabel.text = object["mpaa_rating"] as? String
            self.synopsisLabel.text = object["synopsis"] as? String
            self.synopsisLabel.sizeToFit()
            var posters = object["posters"] as NSDictionary
            var posterUrl = posters["profile"] as String
            self.posterImage.setImageWithURL(NSURL(string: posterUrl))
            self.containerView.frame.size.height = self.synopsisLabel.frame.height + 100;
            var scrollViewHeight = self.containerView.frame.height + self.containerView.frame.origin.y
            self.scrollView.contentSize = CGSize(width:320, height: scrollViewHeight)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
