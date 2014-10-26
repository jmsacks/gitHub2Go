//
//  specificUserRepos.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/23/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation


class specificUserRepro {
    var name : String
    var url : String
    var ID : Int
    var description : String
    var updateDate : String
    
    
    init (reproInfo : NSDictionary) {
        // let itemInfo = reproInfo["items"] as NSDictionary
        self.name = reproInfo["full_name"] as String
        self.url = reproInfo["html_url"] as String
        self.ID = reproInfo["id"] as Int
        if let descript = reproInfo["descripition"] as? String {
            self.description = descript }
        else {
            self.description = ""
        }
        self.updateDate = reproInfo ["updated_at"] as String
        
    }
    
    
    class func parseJSONDataIntoUserRepros(rawJSONData : NSData ) -> [specificUserRepro]? {
        var error : NSError?
        
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray {
            
            var repros = [specificUserRepro]()
                for result in JSONArray {
                    if let reproDictionary = result as? NSDictionary {
                        var newRepro = specificUserRepro(reproInfo: reproDictionary)
                        repros.append(newRepro)
                    }
                }
                return repros
            }
            
        else{
            println("JSONARRAY IF statement didn't work")
        }
        return nil
    }
    
}