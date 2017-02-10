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
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie)
        
        let title = movie["title"] as! String
        
        let overview = movie["overview"] as! String
        
        titleLabel.text = title
        overviewLabel.text = overview
        
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
