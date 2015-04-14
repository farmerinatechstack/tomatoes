//
//  MovieViewController.swift
//  RottenTomatoes
//
//  Created by Hassan Karaouni on 4/10/15.
//  Copyright (c) 2015 HKII. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]! = [NSDictionary]()
    var fetchedMovies: [NSDictionary]! = [NSDictionary]()

    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorView.hidden = true
                
        searchBar.delegate = self
        
        // Instantiate TableView
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchMovieData", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        
        fetchMovieData()
    }
    
    func fetchMovieData () {
        var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ta5dbe46br3y5s3enkz2nxk9")!
        var request = NSURLRequest(URL: url)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            { (response: NSURLResponse!, data: NSData!, requestError: NSError!) ->
                Void in
                
                if let requestError = requestError? {
                    NSLog("Request Error Non Null")
                    self.errorView.hidden = false
                } else {
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                    if let test = json["movies"] as? [NSDictionary] {
                        self.movies = json["movies"] as [NSDictionary]
                        self.fetchedMovies = self.movies
                        NSLog("Response Retrieved!")
                        self.tableView.reloadData()
                    } else {
                        NSLog("JSON Empty")
                        self.errorView.hidden = false
                    }
                }
                self.refreshControl.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var filteredMovies = [NSDictionary]()
            for movie in self.fetchedMovies {
                var title = movie["title"] as String
                if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    filteredMovies.append(movie)
                }
            }
            self.movies = filteredMovies
        } else {
            self.movies = self.fetchedMovies
        }
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as MovieCell
        var movieInfo = self.movies[indexPath.row]
        
        cell.titleLabel!.text = movieInfo["title"] as? String
        var runtime = movieInfo["runtime"] as? Int
        cell.runtimeLabel!.text = "\(runtime!) mins"
        
        cell.ratingLabel!.text = movieInfo["mpaa_rating"] as? String
        
        var criticScore = movieInfo.valueForKeyPath("ratings.critics_score") as? Int
        cell.criticLabel!.text = "\(criticScore!)%"
        
        var viewerScore = movieInfo.valueForKeyPath("ratings.audience_score") as? Int
        cell.viewerLabel!.text = "\(viewerScore!)%"
        
        cell.viewerLabel.font = UIFont(name: "budmo jiggler", size: 5)

        
        var criticImg = "rotten.png"
        if (criticScore! >= 90) {
            criticImg = "certified.png"
        } else if (criticScore! >= 60) {
            criticImg = "fresh.png"
        }
        
        var viewerImg = "spill.png"
        if (viewerScore! >= 60) {
            viewerImg = "pop.png"
        }
        
        cell.criticPic.image =  UIImage(named: criticImg)
        cell.viewerPic.image = UIImage(named: viewerImg)
    
        var url = movieInfo.valueForKeyPath("posters.thumbnail") as? String
        
        
        
        var range = url!.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        var hqurl = url!.stringByReplacingCharactersInRange(range!, withString: "https://content6.flixster.com/") as String
        
        cell.photoView.setImageWithURL(NSURL(string: hqurl)!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        NSLog("Navigating")
        
        var movieView = segue.destinationViewController as MovieDetailViewController
        
        var cell = sender as UITableViewCell
        var indexPath = tableView.indexPathForCell(cell)!
        
        movieView.movie = movies[indexPath.row]
    }
    

}
