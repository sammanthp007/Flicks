//
//  MoviesViewController.swift
//  Flicks
//
//  Created by samman on 2/5/17.
//  Copyright © 2017 samman. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies : [NSDictionary]? = []
    var endpoint: String!
    // for search bar
    var filteredData: [NSDictionary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For pulling to refresh
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        

        tableView.dataSource = self
        searchBar.delegate = self
        tableView.delegate = self
        
        tableView.backgroundColor = UIColor .red
        // Do any additional setup after loading the view.
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let ep = self.endpoint!
        print("https://api.themoviedb.org/3/movie/\(ep)?api_key=\(apiKey)")
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(ep)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    
                    self.filteredData = self.movies
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.filteredData {
            return movies.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! CustomMovieCell

        
        let movie = filteredData![indexPath.row]
        
        let title = movie["title"]  as! String?
        let overview = movie["overview"]  as! String?
        
        
        let poster_base_url = "https://image.tmdb.org/t/p/w342"
        
        if let poster_path = movie["poster_path"] as! String? {
            let poster_url = NSURL(string: poster_base_url + poster_path)
            cell.posterView.setImageWith(poster_url as! URL)
        }
        
        cell.backgroundColor = UIColor .orange
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        // for fitting in the content
        cell.titleLabel.sizeToFit()
        cell.selectionStyle = .none
        
        
        print("row \(indexPath.row)")
        
        return cell
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // Do any additional setup after loading the view.
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    
                    self.filteredData = self.movies
                    self.tableView.reloadData()

                    // Tell the refreshControl to stop spinning
                    refreshControl.endRefreshing()
                }
            }
        }
        task.resume()
    }
    
    // Search Bar
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        self.filteredData = searchText.isEmpty ? movies : movies?.filter({(dataDict: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            let title = dataDict["title"] as! String
            
            // return true if searchText matches title
            return title.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    // When search starts
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    // when cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        self.filteredData = self.movies
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        
        // get the indexpath for the given cell
        let indexPath = tableView.indexPath(for: cell)
        
        // get the movie
        let movie = self.filteredData![(indexPath!.row)]
        
        // get the detail view controller we segue to
        let detailViewControl = segue.destination as! DetailViewController
        
        // add to the dictionary in the custom class
        detailViewControl.movie = movie
        
        
        
        print("Segue")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
