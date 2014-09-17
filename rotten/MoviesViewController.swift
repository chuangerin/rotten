//
//  MoviesViewController.swift
//  rotten
//
//  Created by Erin Chuang on 9/12/14.
//  Copyright (c) 2014 Erin Chuang. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errmsgView: UIView!
    
    var movies: [NSDictionary] = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errmsgView.hidden = true;
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.refresh(self);
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("I'm at row: \(indexPath.row), section: \(indexPath.section)")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieCell
        
        var movie = movies[indexPath.row]
        
        cell.movieTitleLabel.text = movie["title"] as? String
        
        var synopsis = NSMutableAttributedString(string:(movie["synopsis"] as String))
        var rating = movie["mpaa_rating"] as String
        var synopsisRating = "\(rating), \(synopsis)"
        
        var wordRange = (synopsisRating as NSString).rangeOfString(rating)
        var sysnopsisMutable = NSMutableAttributedString(string:synopsisRating)
        
        sysnopsisMutable.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(13), range: wordRange)
        
        cell.synopsisLabel.attributedText = sysnopsisMutable
        
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String
        
        cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        
        /*
        var cell = UITableViewCell()
        cell.textLabel!.text = "Hello, I'm at row: \(indexPath.row), section: \(indexPath.section)"
        */
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailView") {
            var indexPath = tableView.indexPathForSelectedRow()
            var movie = self.movies[indexPath!.row]
            var svc = segue.destinationViewController as MovieDetailViewController
            svc.movieId = movie["id"] as String
        }
    }
    
    func refresh(sender:AnyObject)
    {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us"
        var request = NSURLRequest (URL: NSURL(string: url))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (error != nil) {
                self.errmsgView.hidden = false
            } else {
                var object = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                //println("object: \(object)")
                self.movies = object["movies"] as [NSDictionary]
                self.tableView.reloadData()                
            }
            self.refreshControl.endRefreshing()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
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
