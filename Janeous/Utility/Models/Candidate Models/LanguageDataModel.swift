//
//  LanguageDataModel.swift
//  Janeous
//
//  Created by singsys on 25/03/18.
//

import Foundation


struct LanguageDataModel
{
    var id:String!
    var candidate_id:String!
    var name:String!
    var share_status:String!
    var ilr_level_description = NSDictionary()
    
    init(json:NSDictionary)
    {
        
        if json.object(forKey: "id") != nil
        {
            id = "\(json.object(forKey: "id")!)"
        }
        
        if json.object(forKey: "candidate_id") != nil
        {
            candidate_id = "\(json.object(forKey: "id")!)"
        }
        
        if json.object(forKey: "name") != nil
        {
            name = "\(json.object(forKey: "name")!)"
        }
        
        if json.object(forKey: "share_status") != nil
        {
            share_status = "\(json.object(forKey: "share_status")!)"
        }
        
        if json.object(forKey: "ilr_level_description") != nil && json.object(forKey: "ilr_level_description") is NSDictionary
        {
            ilr_level_description = json.object(forKey: "ilr_level_description") as! NSDictionary
        }
        
    }
    
}
