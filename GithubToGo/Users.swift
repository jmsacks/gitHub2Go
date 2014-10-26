//
//  Users.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/22/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation
import UIKit

class Users {
    var name : String
    var url : String
    var ID : Int
    var avitarURL : String
    var profileImage : UIImage
    var previouslyDownloadedImage : Int
    var repos_URL : String
    
    init (userInfo : NSDictionary) {
        self.name = userInfo["login"] as String
        self.url = userInfo["html_url"] as String
        self.ID = userInfo["id"] as Int
        self.avitarURL = userInfo["avatar_url"] as String
        self.profileImage = UIImage (named: "questionMark.png")
        self.previouslyDownloadedImage = 0
        self.repos_URL = userInfo["repos_url"] as String
    }
    
    
    class func parseJSONDataIntoUsers(rawJSONData : NSData ) -> [Users]? {
        var error : NSError?
        
        if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {
            
            var users = [Users]()
            if let searchResultsArray = JSONDictionary["items"] as? NSArray {
                for result in searchResultsArray {
                    if let userDictionary = result as? NSDictionary {
                        var newUser = Users(userInfo: userDictionary)
                        users.append(newUser)
                    }
                }
                return users
            }
            
        }
        else{
            println("JSONARRAY IF statement didn't work")
        }
        return nil
    }
    
}