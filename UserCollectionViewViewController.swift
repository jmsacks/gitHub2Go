//
//  UserCollectionViewViewController.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/22/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class UserCollectionViewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var users : [Users]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.searchBar.delegate = self
        NetworkController.sharedInstance.searchGitHubUsers ("test", completionHandler: { (errorDescription, results) -> (Void) in
            if errorDescription != nil {
                //alert the user that something went wrong
                println("something went wrong")
            } else {
                self.users = results
                println(self.users?.count)
                println(self.users?.first?.name)
                self.collectionView.reloadData()
            }})
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.users?.count != nil){
            return self.users!.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCollectionViewCell
        //cell.backgroundColor = UIColor.purpleColor()
        let thisUser = self.users?[indexPath.row]
        cell.profileImage.image = self.users?[indexPath.row].profileImage
        cell.profileName.text = self.users?[indexPath.row].name
        NetworkController.sharedInstance.getImageFromURL(thisUser!, completionHandler: { (image) -> Void in
            cell.profileImage.image = thisUser?.profileImage
        })
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let singleUserView=self.storyboard?.instantiateViewControllerWithIdentifier("userDetailView") as UserDetailViewController
        var userToDisplay = self.users![indexPath.row]
        singleUserView.userShown = userToDisplay
        self.navigationController?.pushViewController(singleUserView, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
       // self.activityIndicator.startAnimating()
        println("SEARCHING!")
        NetworkController.sharedInstance.searchGitHubUsers(searchBar.text, completionHandler: { (errorDescription, results) -> (Void) in
            self.users = results
          //  self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
            searchBar.resignFirstResponder()
        })

    } }