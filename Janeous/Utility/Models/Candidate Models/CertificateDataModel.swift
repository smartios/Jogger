//
//  CertificateDataModel.swift
//  Janeous
//
//  Created by singsys on 25/03/18.
//

import Foundation

struct CertificateDataModel
{
    var id:String!
    var candidate_id:String!
    var name = NSDictionary()
    var authority:String!
    var received_month = NSDictionary()
    var received_year = NSDictionary()
    var till_month = NSDictionary()
    var till_year = NSDictionary()
    var share_status:String!
 
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
       
        if json.object(forKey: "name") != nil && json.object(forKey: "name") is NSDictionary
        {
            name = json.object(forKey: "name") as! NSDictionary
        }
        
        if json.object(forKey: "authority") != nil
        {
            authority = "\(json.object(forKey: "authority")!)"
        }
        
        
        if json.object(forKey: "received_month") != nil
        {
            received_month = ["id": "\(json.object(forKey: "received_month")!)", "name":(appDel.generalFunction.getAllWhereValues(inTable: month_Table, forKeys: generalTableKey, andWhere: "id = \(json.object(forKey: "received_month")!)")[0] as! NSDictionary).value(forKey: "name") as! String]
        }
        
        if json.object(forKey: "received_year") != nil
        {
            received_year = ["id": "\(json.object(forKey: "received_year")!)", "name":(appDel.generalFunction.getAllWhereValues(inTable: cerificate_start_year_Table, forKeys: generalTableKey, andWhere: "id = \(json.object(forKey: "received_year")!)")[0] as! NSDictionary).value(forKey: "name") as! String]
        }
        
        if json.object(forKey: "till_month") != nil
        {
            till_month = ["id": "\(json.object(forKey: "till_month")!)", "name":(appDel.generalFunction.getAllWhereValues(inTable: month_Table, forKeys: generalTableKey, andWhere: "id = \(json.object(forKey: "till_month")!)")[0] as! NSDictionary).value(forKey: "name") as! String]
        }
        
        if json.object(forKey: "till_year") != nil
        {
            till_year = ["id": "\(json.object(forKey: "till_year")!)", "name":(appDel.generalFunction.getAllWhereValues(inTable: cerificate_end_year_Table, forKeys: generalTableKey, andWhere: "id = \(json.object(forKey: "till_year")!)")[0] as! NSDictionary).value(forKey: "name") as! String]
        }
        
        if json.object(forKey: "share_status") != nil
        {
            share_status = "\(json.object(forKey: "share_status")!)"
        }
        
    }
  
}
