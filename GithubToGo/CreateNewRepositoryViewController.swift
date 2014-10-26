//
//  CreateNewRepositoryViewController.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/24/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class CreateNewRepositoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var descriptionTextField: UITextField!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func createRepository(sender: UIButton) {
        println(descriptionTextField.text)
        NetworkController.sharedInstance.createNewRepository(descriptionTextField.text)
    }
    
    
    
    
    
}
