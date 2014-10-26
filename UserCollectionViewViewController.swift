 //
//  UserCollectionViewViewController.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/22/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit
import QuartzCore

class UserCollectionViewViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var users : [Users]?
    var origin: CGRect?
    var userToDisplay : Users?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.searchBar.delegate = self
//        NetworkController.sharedInstance.searchGitHubUsers ("test", completionHandler: { (errorDescription, results) -> (Void) in
//            if errorDescription != nil {
//                //alert the user that something went wrong
//                println("something went wrong")
//            } else {
//                self.users = results
//                println(self.users?.count)
//                println(self.users?.first?.name)
//                self.collectionView.reloadData()
//            }})
       println("The delegate is: \(self.navigationController?.delegate)")
       self.navigationController?.delegate = self
       // self.navigationController?.delegate =
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
        
        cell.profileImage.image = UIImage (named: "questionMark.png")
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        let thisUser = self.users?[indexPath.row]
        cell.profileImage.image = self.users?[indexPath.row].profileImage
        cell.profileName.text = self.users?[indexPath.row].name
        NetworkController.sharedInstance.getImageFromURL(thisUser!, completionHandler: { (image) -> Void in
            if cell.tag == currentTag {
            cell.profileImage.image = thisUser?.profileImage
            }
            })
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let singleUserView=self.storyboard?.instantiateViewControllerWithIdentifier("userDetailView") as UserDetailViewController
        userToDisplay = self.users![indexPath.row]
        singleUserView.userShown = userToDisplay
        let attributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        let origin = self.view.convertRect(attributes!.frame, fromView: collectionView)
        self.origin = origin
        let image = userToDisplay!.profileImage
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        singleUserView.reverseOrigin = self.origin!
        
        
        //println("The delegate is: \(self.navigationController?.delegate)")
        //self.navigationController?.delegate = self
        self.navigationController!.pushViewController(singleUserView, animated: true)
    }
    
        func navigationController(UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            if let userCollectionViewViewController = fromVC as? UserCollectionViewViewController {
                if let userDetailViewController = toVC as? UserDetailViewController{
                    let animator = ShowImageAnimator()
                    animator.origin = self.origin
                    return animator
                } }
            return nil
        }
   
  //MARK: SearchBar
    
    func searchBar(searchBar: UISearchBar,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool {
            println(text)
            return text.validate()
    }

func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    // self.activityIndicator.startAnimating()
    println("SEARCHING!")
    NetworkController.sharedInstance.searchGitHubUsers(searchBar.text, completionHandler: { (errorDescription, results) -> (Void) in
        self.users = results
        //  self.activityIndicator.stopAnimating()
        self.collectionView.reloadData()
    })
    
    searchBar.resignFirstResponder()
    
    }
}