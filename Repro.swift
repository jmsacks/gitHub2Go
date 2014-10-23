//
//  Repro.swift
//  GithubToGo
//
//  Created by Joshua M. Sacks on 10/21/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import Foundation

class Repro {
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
            self.description = reproInfo["description"] as String
            self.updateDate = reproInfo ["updated_at"] as String
        
    }
    
    
class func parseJSONDataIntoRepros(rawJSONData : NSData ) -> [Repro]? {
    var error : NSError?

    if let JSONDictionary = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSDictionary {
        
        var repros = [Repro]()
        if let searchResultsArray = JSONDictionary["items"] as? NSArray {
            for result in searchResultsArray {
                if let reproDictionary = result as? NSDictionary {
                    var newRepro = Repro(reproInfo: reproDictionary)
                    repros.append(newRepro)
                }
            }
            return repros
        }
        
    }
    else{
        println("JSONARRAY IF statement didn't work")
    }
    return nil
}

}