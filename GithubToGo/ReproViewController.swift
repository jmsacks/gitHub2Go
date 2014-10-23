//
//  ReproViewController.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/21/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class ReproViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repros : [Repro]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.searchBar.delegate = self
         
        NetworkController.sharedInstance.searchGitHubRepo ("test", completionHandler: { (errorDescription, results) -> (Void) in
            if errorDescription != nil {
                //alert the user that something went wrong
                println("something went wrong")
            } else {
                self.repros = results
                println(self.repros?.count)
                println(self.repros?.first?.name)
                self.tableView.reloadData()
            }})

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.repros?.count != nil){
          return self.repros!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("REPO_CELL") as ReproTableViewCell
        cell.name.text = self.repros![indexPath.row].name
        println(cell.name.text)
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.activityIndicator.startAnimating()
        NetworkController.sharedInstance.searchGitHubRepo(searchBar.text, completionHandler: { (errorDescription, results) -> (Void) in
            self.repros = results
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            searchBar.resignFirstResponder()
        })
        
        
        
    }

}
