//
//  AuthorizedUserViewController.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/24/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class AuthorizedUserViewController: UIViewController {
    
    var authorizedUser : AuthorizedUser?
    
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var loginName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var hireable: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var Following: UILabel!
    @IBOutlet weak var publicRepoCount: UILabel!
    @IBOutlet weak var privateRepoCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkController.sharedInstance.fetchAuthorizedUser({ (errorDescription, result) -> (Void) in
    
            if errorDescription != nil {
                //alert the user that something went wrong
                println("something went wrong")
            } else {
                self.authorizedUser = result
                self.userName.text = self.authorizedUser!.name
                self.loginName.text = "Login: " + self.authorizedUser!.login
                self.location.text = "Location: " + self.authorizedUser!.location
                self.email.text = "Email: " + self.authorizedUser!.email
                self.bio.text = "Bio: " + self.authorizedUser!.bio
                var hireableText = "No"
                if (self.authorizedUser!.hireable) { hireableText = "True"}
                self.hireable.text = "Hireable: " + hireableText
                self.followers.text = "Followers: " + String (self.authorizedUser!.followersCount)
                self.Following.text = "Following: " + String (self.authorizedUser!.following)
                self.privateRepoCount.text = "Private Repos: " + String (self.authorizedUser!.privateRepos)
                self.publicRepoCount.text = "Public Repos: " + String (self.authorizedUser!.publicRepos)
                
                NetworkController.sharedInstance.getImageFromURLForAuthorizedUser(self.authorizedUser!, completionHandler: { (image) -> Void in
                    self.profileImage.image = self.authorizedUser?.profileImage
                })

                
            }})


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
