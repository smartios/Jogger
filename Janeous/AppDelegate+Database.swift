//
//  AppDelegate+Database.swift
//  Janeous
//
//  Created by singsys on 21/03/18.
//

import Foundation

var social_Table = "janeous_social"
var ilr_level_Table = "janeous_ilr_level"
var skills_Table = "janeous_skills"
var job_titles_Table = "janeous_job_titles"
var fieldofstudy_Table = "janeous_fieldofstudy"
var degree_Table = "janeous_degree"
var workExperienceYear_Table = "janeous_workExperienceYear"
var month_Table = "janeous_month"
var experience_level_Table = "janeous_experience_level"
var country_phone_codes_Table = "janeous_country_phone_codes"
var countries_Table = "janeous_countries"
var nationalities_Table = "janeous_nationalities"
var industries_Table = "janeous_industries"
var job_functions_Table = "janeous_job_functions"
var job_tags_Table = "janeous_job_tags"
var cerificate_start_year_Table = "janeous_cerificate_start_year"
var cerificate_end_year_Table = "janeous_cerificate_end_year"
var educationYear_Table = "janeous_educationYear"


var generalTableKey = ["id","name"]
var social_Table_Key = ["id","name","image"]
var ilr_level_Table_Key = ["id","level","label"]
var country_phone_codes_Table_Key = ["id","name","country_name"]

extension AppDelegate
{
    
    //MARK:- DATABASE
    func copyDatabase()
    {
        //let error: Error?
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath: String = paths[0]
        let databasePath = "\(documentPath)/janeous.db"
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: databasePath) {
            let path: String? = Bundle.main.path(forResource: "janeous", ofType: "db")
            if let aPath = path {
                try? fileManager.copyItem(atPath: aPath, toPath: databasePath)
            }
        }
        
    }
    
    
    //MARK:- Webservice
    func getGeneralData()
    {
        supportingfuction.showProgressHudForViewMy(view: self, withDetailsLabel: "", labelText: "Please wait.")
        CommonValidations().makeWebServiceCall(url: generalWebService, parameter: NSMutableDictionary()) { (JSON) in
            
            if (JSON as! NSDictionary).object(forKey: "status") != nil && ("\((JSON as! NSDictionary).object(forKey: "status")!)" == "1") {
                
                let dataDic = (JSON as! NSDictionary).object(forKey: "data") as! NSDictionary
                
                if dataDic.value(forKey: "social") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: social_Table, forKeys: social_Table_Key, values: dataDic.value(forKey: "social") as! [Any])
                }
                
                if dataDic.value(forKey: "ilr_level") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: ilr_level_Table, forKeys: ilr_level_Table_Key, values: dataDic.value(forKey: "ilr_level") as! [Any])
                }
                
                if dataDic.value(forKey: "skills") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: skills_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "skills") as! [Any])
                }
        
                if dataDic.value(forKey: "job_titles") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: job_titles_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "job_titles") as! [Any])
                }
                
                if dataDic.value(forKey: "fieldofstudy") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: fieldofstudy_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "fieldofstudy") as! [Any])
                }
                
                if dataDic.value(forKey: "degree") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: degree_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "degree") as! [Any])
                }
                
                if dataDic.value(forKey: "workExperienceYear") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: workExperienceYear_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "workExperienceYear") as! [Any])
                }

                if dataDic.value(forKey: "month") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: month_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "month") as! [Any])
                }
                
                if dataDic.value(forKey: "experience_level") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: experience_level_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "experience_level") as! [Any])
                }
                
                if dataDic.value(forKey: "country_phone_codes") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: country_phone_codes_Table, forKeys: country_phone_codes_Table_Key, values: dataDic.value(forKey: "country_phone_codes") as! [Any])
                }
                
                if dataDic.value(forKey: "countries") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: countries_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "countries") as! [Any])
                }
                
                if dataDic.value(forKey: "nationalities") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: nationalities_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "nationalities") as! [Any])
                }
                
                if dataDic.value(forKey: "industries") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: industries_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "industries") as! [Any])
                }
                
                if dataDic.value(forKey: "job_functions") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: job_functions_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "job_functions") as! [Any])
                }
                
                if dataDic.value(forKey: "job_tags") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: job_tags_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "job_tags") as! [Any])
                }
                
                if dataDic.value(forKey: "cerificate_start_year") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: cerificate_start_year_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "cerificate_start_year") as! [Any])
                }

                if dataDic.value(forKey: "cerificate_end_year") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: cerificate_end_year_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "cerificate_end_year") as! [Any])
                }
                
                if dataDic.value(forKey: "educationYear") != nil
                {
                    self.generalFunction.insertOrUpdateData(intoTable: educationYear_Table, forKeys: generalTableKey, values: dataDic.value(forKey: "educationYear") as! [Any])
                }
            }
            else
            {
                
            }
            
            
        }
    }
}
