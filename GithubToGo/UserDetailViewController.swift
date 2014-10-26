//
//  UserDetailViewController.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/23/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var profileID: UILabel!
    var userShown : Users?
    var reverseOrigin: CGRect?
    var repros : [specificUserRepro]?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.image = userShown?.profileImage
        profileName.text = "Login: " + userShown!.name
        profileID.text = "GitHub ID: " + String (userShown!.ID)
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
        cell.descripition.text = self.repros![indexPath.row].description
        cell.updateDate.text = self.repros![indexPath.row].updateDate
        println(cell.name.text)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Should go to webview")
        let repoWebView = self.storyboard?.instantiateViewControllerWithIdentifier("webView") as WebViewController
        repoWebView.destinationURL = self.repros![indexPath.row].url
        self.navigationController?.pushViewController(repoWebView, animated: true)
        
    }
    
    @IBAction func profileButtonClicked(sender: UIButton) {
        let profileWebView = self.storyboard?.instantiateViewControllerWithIdentifier("webView") as WebViewController
        profileWebView.destinationURL = userShown?.url
        self.navigationController?.pushViewController(profileWebView, animated: true)

    }
    
    @IBAction func repoButtonClicked(sender: UIButton) {
        let repoWebView = self.storyboard?.instantiateViewControllerWithIdentifier("webView") as WebViewController
        repoWebView.destinationURL = "https://github.com/\(userShown!.name)?tab=repositories"
        println(repoWebView.destinationURL)
        self.navigationController?.pushViewController(repoWebView, animated: true)

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
