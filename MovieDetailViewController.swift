//
//  MovieDetailViewController.swift
//  
//
//  Created by Hassan Karaouni on 4/10/15.
//
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movie: NSDictionary!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var synopsisLabel: UILabel!
    
    @IBOutlet weak var detailPic: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
                
        var url = movie.valueForKeyPath("posters.original") as? String
        var range = url!.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        var hqurl = url!.stringByReplacingCharactersInRange(range!, withString: "https://content6.flixster.com/") as String
        
        self.detailPic.setImageWithURL(NSURL(string: hqurl)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
