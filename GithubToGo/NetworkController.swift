//
//  NetworkController.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/21/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation
import UIKit


class NetworkController {
    
    let clientID = "client_id=880285d02e8772ad3ec0"
    let clientSecret = "client_secret=509b38cdee04f96cba4926f2c502d926390659b6"
    let githubOAuthURL = "https://github.com/login/oauth/authorize?"
    let scope = "scope=user,repro"
    let redirectURL = "redirect_url=somefancyname://test"
    let gitHubPostURLForAuthorization = "https://github.com/login/oauth/access_token"
    var authorizedSiession : NSURLSession?
    let imageQueue = NSOperationQueue()
   
    
    func fetchAuthorizedUser(completionHandler : (errorDescription : String?, results : AuthorizedUser?) -> (Void)){
        let url = "https://api.github.com/user"
        let authorizedUserJSON = authorizedSiession?.dataTaskWithURL(NSURL (string: url), completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println("There was an error")
                
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        println("It worked for the authorized user!")
                        let parsedObject = AuthorizedUser.parseJSONintoAuthorizedUser(data)!
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(errorDescription: nil, results: parsedObject)
                        })
                        
                    default:
                        println("It didn't work.  StatusCode is \(httpResponse.statusCode)")
                        println(httpResponse.allHeaderFields)
                        completionHandler(errorDescription: "Something went horribly wrong", results: nil)
                        
                    }
                }
            }
        })
        authorizedUserJSON?.resume()
    }

        
    
    func searchGitHubRepo(searchString : String, completionHandler : (errorDescription : String?, results : [Repro]?) -> (Void)){
             let url = "https://api.github.com/search/repositories?q=\(searchString)"
        let reproJSON = authorizedSiession?.dataTaskWithURL(NSURL (string: url), completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println("There was an error")
                
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        println("It worked in the repos!")
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
    
    func loadURL (url : String, completionHandler : (errorDescription : String?, results : [specificUserRepro]?) -> (Void)){
        let reproJSON = authorizedSiession?.dataTaskWithURL(NSURL (string: url), completionHandler: { (data, response, error) -> Void in
        if error != nil {
        println("There was an error")
        
        } else {
        if let httpResponse = response as? NSHTTPURLResponse {
        switch httpResponse.statusCode {
        case 200...204:
        println("It worked in the repos!")
        let parsedObjects = specificUserRepro.parseJSONDataIntoUserRepros(data)!
        
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
        var request = NSMutableURLRequest(URL: NSURL (string: gitHubPostURLForAuthorization))
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
                        println("Got new OAuth")
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
    
        func getImageFromURLForAuthorizedUser (user: AuthorizedUser, completionHandler : (image :UIImage) -> Void) {
                self.imageQueue.addOperationWithBlock { () -> Void in
                    var imageString = user.imageURL
                    let nsurl = NSURL (string : imageString)
                    println(imageString)
                    let data = NSData (contentsOfURL: nsurl)
                    let profimage = UIImage (data: data)
                    user.profileImage = profimage
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completionHandler (image : profimage)
                    })
                    //return image
                }
            }
    
    func createNewRepository (name : String) {
        var tryAgain = 0
        let url = "https://api.github.com/user/repos"
        var error2 : NSError?
        var param = [String:String]()
        
        param["name"] = name
        param["description"] = "It Worked"
       // let param = ["name" : name] as NSDictionary
        let session = NSURLSession.sharedSession()
        if let postJSON = NSJSONSerialization.dataWithJSONObject(param, options: nil, error: &error2) {
        var request = NSMutableURLRequest(URL: NSURL (string: url))
        request.HTTPMethod = "POST"
        let token = NSUserDefaults.standardUserDefaults().objectForKey("OAUTH_Code") as String
         request.setValue("token " + token, forHTTPHeaderField: "Authorization")
            let string = NSString (data: postJSON, encoding: NSASCIIStringEncoding)
            println(string)
        
      //  var postData = param.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        request.HTTPBody = postJSON
        let length = postJSON.length
        request.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let createRepoTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
//                    let createRepoTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                println(error.description)
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...204:
                        println("Woot...it worked!")
                        tryAgain = 0
                    case 401:
                        println(httpResponse.statusCode)
                        let string = NSString (data: data, encoding: NSASCIIStringEncoding)
                        println(string)
                        NetworkController.sharedInstance.requestOAuthAccess()
                        tryAgain = 1
                    default:
                        println(httpResponse.statusCode)
                        let string = NSString (data: data, encoding: NSASCIIStringEncoding)
                        tryAgain = 0
                        println(string)
                    }
                }
            }
        })
        createRepoTask.resume()
            while tryAgain == 1 {
            if tryAgain == 1 {
                let authCode = "NeedNewCode"
                NSUserDefaults.standardUserDefaults().setObject(authCode, forKey: "OAUTH_Code")
               createRepoTask.resume()
            }
            } }
    }
}



