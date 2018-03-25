//
//  WorkExperienceModel.swift
//  Janeous
//
//  Created by singsys on 24/03/18.
//

import Foundation

struct WorkExperienceModel
{
    var id:String! = ""
    var candidate_id:String! = ""
    var jobtitle:String! = ""
    var experience_level:String! = ""
    var experience_level_name:String! = ""
    var industry = NSDictionary()
    var company_name:String! = ""
    var mobile_number:String! = ""
    var location = NSDictionary()
    var is_currently_working:Bool! = false
    var joining_month = NSDictionary()
    var joining_year = NSDictionary()
    var relieving_month = NSDictionary()
    var relieving_year = NSDictionary()
    var function:String! = ""
    var description:String! = ""
    var functions = NSDictionary()
    var tags = NSMutableArray()
    
    init(json:NSDictionary)
    {
        //tags = NSMutableArray()
        
        if json.object(forKey: "id") != nil
        {
           id = "\(json.object(forKey: "id")!)"
        }
        
        if json.object(forKey: "candidate_id") != nil
        {
            candidate_id = "\(json.object(forKey: "id")!)"
        }
        
        if json.object(forKey: "jobtitle") != nil && json.object(forKey: "jobtitle") is NSDictionary
        {
            jobtitle = "\((json.object(forKey: "jobtitle") as! NSDictionary).object(forKey: "name")!)"
        }
        
        if json.object(forKey: "experience_level") != nil
        {
          experience_level = "\(json.object(forKey: "experience_level")!)"
        }
        
        if json.object(forKey: "experience_level_name") != nil
        {
            experience_level_name = "\(json.object(forKey: "experience_level_name")!)"
        }
        
        if json.object(forKey: "industry") != nil && json.object(forKey: "industry") is NSDictionary
        {
            industry = json.object(forKey: "industry") as! NSDictionary
        }

        if json.object(forKey: "company_name") != nil
        {
            company_name = "\(json.object(forKey: "company_name")!)"
        }
        
        if json.object(forKey: "mobile_number") != nil
        {
            mobile_number = "\(json.object(forKey: "mobile_number")!)"
        }
        
        if json.object(forKey: "location") != nil && json.object(forKey: "location") is NSDictionary
        {
            location = json.object(forKey: "location") as! NSDictionary
        }
        
        if json.object(forKey: "is_currently_working") != nil
        {
            if "\(json.object(forKey: "is_currently_working")!)" == "no"
            {
                 is_currently_working = false
            }
            else
            {
                is_currently_working = true
            }
           
        }
        
        if json.object(forKey: "joining_month") != nil
        {
            //joining_month = "\(json.object(forKey: "joining_month")!)"
            
            joining_month = ["id": "\(json.object(forKey: "joining_month")!)", "name":(appDel.generalFunction.getAllWhereValues(inTable: month_Table, forKeys: generalTableKey, andWhere: "id = \(json.object(forKey: "joining_month")!)")[0] as! NSDictionary).value(forKey: "name") as! String]
        }
        
        if json.object(forKey: "joining_year") != nil
        {
            joining_year = ["id": "\(json.object(forKey: "joining_year")!)", "name":(appDel.generalFunction.getAllWhereValues(inTable: workExperienceYear_Table, forKeys: generalTableKey, andWhere: "id = \(json.object(forKey: "joining_year")!)")[0] as! NSDictionary).value(forKey: "name") as! String]
        }
        
        if json.object(forKey: "relieving_month") != nil
        {
           relieving_month = ["id": "\(json.object(forKey: "relieving_month")!)", "name":(appDel.generalFunction.getAllWhereValues(inTable: month_Table, forKeys: generalTableKey, andWhere: "id = \(json.object(forKey: "relieving_month")!)")[0] as! NSDictionary).value(forKey: "name") as! String]
           // relieving_month = "\(json.object(forKey: "relieving_month")!)"
        }
        
        if json.object(forKey: "relieving_year") != nil
        {
            relieving_year = ["id": "\(json.object(forKey: "relieving_year")!)", "name":(appDel.generalFunction.getAllWhereValues(inTable: workExperienceYear_Table, forKeys: generalTableKey, andWhere: "id = \(json.object(forKey: "relieving_year")!)")[0] as! NSDictionary).value(forKey: "name") as! String]
           // relieving_year = "\(json.object(forKey: "relieving_year")!)"
        }
        
        if json.object(forKey: "function") != nil
        {
            function = "\(json.object(forKey: "function")!)"
        }
        
        if json.object(forKey: "description") != nil
        {
            description = "\(json.object(forKey: "description")!)"
        }
  
        if json.object(forKey: "functions") != nil && json.object(forKey: "functions") is NSDictionary
        {
            functions = json.object(forKey: "functions") as! NSDictionary
        }
        
        if json.object(forKey: "tags") != nil && json.object(forKey: "tags") is NSArray && (json.object(forKey: "tags") as! NSArray).count > 0
        {

           for dic in (json.object(forKey: "tags") as! NSArray)
           {
            tags.add(((dic as! NSDictionary).value(forKey: "tag_name") as! NSDictionary).value(forKey: "name")!)
            
            }
        }
        
    }

}
