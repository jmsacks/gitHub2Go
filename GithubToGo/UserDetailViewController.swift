//
//  UserDetailViewController.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/23/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    var userShown : Users?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.image = userShown?.profileImage
        profileName.text = userShown?.name

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
