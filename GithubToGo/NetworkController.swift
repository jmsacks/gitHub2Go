//
//  NetworkController.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/21/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation
import UIKit

enum typesOfSearches{
    case repo
    case user
}



class NetworkController {
    
    let clientID = "client_id=880285d02e8772ad3ec0"
    let clientSecret = "client_secret=509b38cdee04f96cba4926f2c502d926390659b6"
    let githubOAuthURL = "https://github.com/login/oauth/authorize?"
    let scope = "scope=user,repro"
    let redirectURL = "redirect_url=somefancyname://test"
    let gitHubPostURL = "https://github.com/login/oauth/access_token"
    var authorizedSiession : NSURLSession?
    let imageQueue = NSOperationQueue()
   
    
    func searchGitHubRepo(searchString : String, completionHandler : (errorDescription : String?, results : [Repro]?) -> (Void)){
             let url = "https://api.github.com/search/repositories?q=\(searchString)"
        let reproJSON = authorizedSiession?.dataTaskWithURL(NSURL (string: url), completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println("There was an error")
                
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        println("It worked!")
                          let parsedObjects = Repro.parseJSONDataIntoRepros(data)!

                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(errorDescription: nil, results: parsedObjects)
                        })
                        
                    default:
                        println("It didn't work.  StatusCode is \(httpResponse.statusCode)")
                        println(httpResponse.allHeaderFields)
                        completionHandler(errorDescription: "Something went horribly wrong", results: nil)

                    }
                    }
            }
        })
        reproJSON?.resume()
    }

    func searchGitHubUsers(searchString : String, completionHandler : (errorDescription : String?, results : [Users]?) -> (Void)){
        let url = "https://api.github.com/search/users?q=\(searchString)"
        let reproJSON = authorizedSiession?.dataTaskWithURL(NSURL (string: url), completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println("There was an error")
                
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        println("It worked!")
                        let parsedObjects = Users.parseJSONDataIntoUsers(data)
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(errorDescription: nil, results: parsedObjects)
                        })
                        
                    default:
                        println("It didn't work.  StatusCode is \(httpResponse.statusCode)")
                        println(httpResponse.allHeaderFields)
                        completionHandler(errorDescription: "Something went horribly wrong", results: nil)
                        
                    }
                }
            }
        })
        reproJSON?.resume()
    }
    
    class var sharedInstance : NetworkController {
    struct Static {
        static var onceToken : dispatch_once_t = 0
        static var instance : NetworkController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkController()
        }
        return Static.instance!
    }
    
    
    func requestOAuthAccess (){
        let url = githubOAuthURL + clientID + "&" + redirectURL + "&" + scope
        UIApplication.sharedApplication().openURL(NSURL (string: url))
    }
    
    func handleOAuthRequest (callbackURL : NSURL){
        let query = callbackURL.query
        let components = query?.componentsSeparatedByString("code=")
        let code = components?.last
        
        let urlQuery = clientID + "&" + clientSecret + "&" + "code=\(code!)"
        var request = NSMutableURLRequest(URL: NSURL (string: gitHubPostURL))
        request.HTTPMethod = "POST"
        var postData = urlQuery.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let length = postData!.length
        request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println("Hello this is an error")
            } else {
                println("entered else in handleOAuth")
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        var tokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
                        //var configuration = NSURLSessionConfiguration()
                        let responseItems = tokenResponse.componentsSeparatedByString("&")
                        //TO-DO create protection that the first itme in responseItems is always access_token
                        let justCode = responseItems.first!.componentsSeparatedByString("access_token=")
                        var authCode = justCode.last! as NSString
                        authCode = "token " + authCode
                        println("The auth code is: \(authCode)")
                        NSUserDefaults.standardUserDefaults().setObject(authCode, forKey: "OAUTH_Code")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        self.createAuthoriedSession(authCode)
                    default:
                        println("default case on status code")
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func createAuthoriedSession (authCode : NSString) {
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = ["Authorization" : authCode]
        self.authorizedSiession = NSURLSession(configuration: configuration)
}
    
    func getImageFromURL (user: Users, completionHandler : (image :UIImage) -> Void) {
        if user.previouslyDownloadedImage == 0 {
            self.imageQueue.addOperationWithBlock { () -> Void in
                var imageString = user.avitarURL
                let nsurl = NSURL (string : imageString)
                println(imageString)
                let data = NSData (contentsOfURL: nsurl)
                let profimage = UIImage (data: data)
                user.profileImage = profimage
                user.previouslyDownloadedImage = 1
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completionHandler (image : profimage)
                })
                //return image
            }
        }
        
    }
    
    
    
    
}