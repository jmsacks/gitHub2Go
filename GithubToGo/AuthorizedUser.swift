//
//  AuthorizedUser.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/24/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation
import UIKit

class AuthorizedUser {

    var profileImage : UIImage
    var imageURL : String
    var bio : String
    var hireable : Bool
    var publicRepos : Int
    var privateRepos : Int
    var email : String
    var login : String
    var name : String
    var followersCount : Int
    var followersURL : String
    var following : Int
    var staredURL : String
    var location : String
    
    init (authorizedUserInfo : NSDictionary) {
        self.profileImage = UIImage (named: "questionMark.png")
        self.imageURL = authorizedUserInfo["avatar_url"] as String
        if let bio = authorizedUserInfo["bio"] as? String {
            self.bio = bio }
        else {
            self.bio = ""}
        self.hireable = authorizedUserInfo["hireable"] as Bool
        self.publicRepos = authorizedUserInfo["public_repos"] as Int
        self.privateRepos = authorizedUserInfo["total_private_repos"] as Int
        self.email = authorizedUserInfo["email"] as String
        self.login = authorizedUserInfo["login"] as String
        self.name = authorizedUserInfo["name"] as String
        self.followersCount = authorizedUserInfo["followers"] as Int
        self.followersURL = authorizedUserInfo["followers_url"] as String
        self.following = authorizedUserInfo["following"] as Int
        self.staredURL = authorizedUserInfo["starred_url"] as String
        self.location = authorizedUserInfo["location"] as String
        }
    
    class func parseJSONintoAuthorizedUser (rawJSONData : NSData ) -> (AuthorizedUser)? {
        var error : NSError?
        
        if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {
            
                    var authorizedUser = AuthorizedUser(authorizedUserInfo: JSONDictionary)
                    return authorizedUser
            }
            
        else{
            println("JSONARRAY IF statement didn't work")
            return nil
        }
        
    }
    
}