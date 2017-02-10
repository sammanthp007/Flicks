//
//  DetailViewController.swift
//  Flicks
//
//  Created by samman on 2/9/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textDetailView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: textDetailView.frame.origin.y + textDetailView.frame.size.height)
        
        let title = movie["title"] as! String
        
        let overview = movie["overview"] as! String
        
        titleLabel.text = title
        overviewLabel.text = overview
        
        // for wrapping the size of the box as per the dynamic text
        overviewLabel.sizeToFit()
        
        let poster_base_url = "https://image.tmdb.org/t/p/w342"
        
        // In case no picture exists
        if let poster_path = movie["poster_path"] as! String? {
            let poster_url = NSURL(string: poster_base_url + poster_path)
            posterImageView.setImageWith(poster_url as! URL)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
