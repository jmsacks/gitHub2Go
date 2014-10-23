//
//  SplitContainerViewController.swift
//  GithubToGo
//
//  Created by Bradley Johnson on 10/20/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class SplitContainerViewController: UIViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let splitVC = self.childViewControllers[0] as UISplitViewController
        splitVC.delegate = self

        if let authCode = NSUserDefaults.standardUserDefaults().valueForKey("OAUTH_Code") as String? {
            NetworkController.sharedInstance.createAuthoriedSession(authCode)
        }else{
            NetworkController.sharedInstance.requestOAuthAccess()
    }
        // Do any additional setup after loading the view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController!, ontoPrimaryViewController primaryViewController: UIViewController!) -> Bool {
        return true
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
