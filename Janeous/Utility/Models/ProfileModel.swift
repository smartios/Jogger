//
//  ProfileModel.swift
//  Janeous
//
//  Created by singsys on 18/03/18.
//

import Foundation

struct CandidateProfile{
    var userImage:String!
    var name:String!
    var userFirstName:String!
    var userLastName:String!
    var userID:String!
    var email:String!
    var mobile_number:String!
    var token:String!
    var type:String!
    var description:String!
    var linkedin:String!
    var nationality:String!
    var nationality_Dic:NSDictionary!
    var country_of_residence:String!
    var country_of_residence_Dic:NSDictionary!
    var experience:String!
    var ProfileDic = NSMutableDictionary()
    var workExperienceArray:[WorkExperienceModel]! = []
    var skillArray = NSMutableArray()
    var certificateArray:[CertificateDataModel]! = []
    var languageArray:[LanguageDataModel]! = []
    
    init(json:NSDictionary)
    {
        if json.object(forKey: "profile") != nil && json.object(forKey: "profile") is NSDictionary && (json.object(forKey: "profile") as! NSDictionary).value(forKey: "profile") != nil
        {
            ProfileDic = ((json.object(forKey: "profile") as! NSDictionary).value(forKey: "profile") as! NSDictionary) .mutableCopy() as! NSMutableDictionary
        }
        
        
        if json.object(forKey: "token") != nil
        {
            token = "\(json.object(forKey: "token")!)"
        }
        
        if json.object(forKey: "type") != nil
        {
            type = "\(json.object(forKey: "type")!)"
        }
        
        if ProfileDic.object(forKey: "profile_picture") != nil
        {
            userImage = "\(ProfileDic.object(forKey: "profile_picture")!)"
        }
        
        if ProfileDic.object(forKey: "first_name") != nil
        {
            userFirstName = "\(ProfileDic.object(forKey: "first_name")!)"
        }
        
        if ProfileDic.object(forKey: "last_name") != nil
        {
            userLastName = "\(ProfileDic.object(forKey: "last_name")!)"
        }
     
        name = "\(userFirstName!) \(userLastName!)"
        
        if ProfileDic.object(forKey: "id_user") != nil
        {
            userID = "\(ProfileDic.object(forKey: "id_user")!)"
        }
        
        if ProfileDic.object(forKey: "email") != nil
        {
            email = "\(ProfileDic.object(forKey: "email")!)"
        }
        
        if ProfileDic.object(forKey: "mobile_number") != nil
        {
            mobile_number = "\(ProfileDic.object(forKey: "mobile_number")!)"
        }
        
        if ProfileDic.object(forKey: "about_you") != nil
        {
            description = "\(ProfileDic.object(forKey: "about_you")!)"
        }
        
        if ProfileDic.object(forKey: "linkedin") != nil
        {
            linkedin = "\(ProfileDic.object(forKey: "linkedin")!)"
        }
        
        if ProfileDic.object(forKey: "nationality") != nil && "\(ProfileDic.object(forKey: "nationality")!)" != ""
        {
            nationality = "\(ProfileDic.object(forKey: "nationality")!)"
            nationality_Dic = appDel.generalFunction.getAllWhereValues(inTable: nationalities_Table, forKeys: generalTableKey, andWhere: "id = \(nationality!)")[0] as! NSDictionary
        }
        
        if ProfileDic.object(forKey: "country_of_residence") != nil && "\(ProfileDic.object(forKey: "country_of_residence")!)" != ""
        {
            country_of_residence = "\(ProfileDic.object(forKey: "country_of_residence")!)"
            country_of_residence_Dic = appDel.generalFunction.getAllWhereValues(inTable: countries_Table, forKeys: generalTableKey, andWhere: "id = \(country_of_residence!)")[0] as! NSDictionary
        }
        
        if ProfileDic.object(forKey: "experience") != nil
        {
            experience = "\(ProfileDic.object(forKey: "experience")!)"
        }
        
        if json.object(forKey: "profile") != nil && json.object(forKey: "profile") is NSDictionary && (json.object(forKey: "profile") as! NSDictionary).value(forKey: "workExperiences") != nil &&  (json.object(forKey: "profile") as! NSDictionary).value(forKey: "workExperiences") is NSArray
        {
            let tempArr = (json.object(forKey: "profile") as! NSDictionary).value(forKey: "workExperiences") as! NSArray
            for element in tempArr
            {
                let workExp:WorkExperienceModel = WorkExperienceModel.init(json: element as! NSDictionary)
                self.workExperienceArray.append(workExp)
            }
        }
        
        if json.object(forKey: "profile") != nil && json.object(forKey: "profile") is NSDictionary && (json.object(forKey: "profile") as! NSDictionary).value(forKey: "skills") != nil &&  (json.object(forKey: "profile") as! NSDictionary).value(forKey: "skills") is NSArray
        {
            for dic in ((json.object(forKey: "profile") as! NSDictionary).value(forKey: "skills") as! NSArray)
            {
                skillArray.add(((dic as! NSDictionary).value(forKey: "skill") as! NSDictionary).value(forKey: "name")!)
            }
        }
        
        if json.object(forKey: "profile") != nil && json.object(forKey: "profile") is NSDictionary && (json.object(forKey: "profile") as! NSDictionary).value(forKey: "certificates") != nil &&  (json.object(forKey: "profile") as! NSDictionary).value(forKey: "certificates") is NSArray
        {
            let tempArr = (json.object(forKey: "profile") as! NSDictionary).value(forKey: "certificates") as! NSArray
            for element in tempArr
            {
                let cert:CertificateDataModel = CertificateDataModel.init(json: element as! NSDictionary)
                self.certificateArray.append(cert)
            }
        }
        
        if json.object(forKey: "profile") != nil && json.object(forKey: "profile") is NSDictionary && (json.object(forKey: "profile") as! NSDictionary).value(forKey: "language") != nil &&  (json.object(forKey: "profile") as! NSDictionary).value(forKey: "language") is NSArray
        {
            let tempArr = (json.object(forKey: "profile") as! NSDictionary).value(forKey: "language") as! NSArray
            for element in tempArr
            {
                let language:LanguageDataModel = LanguageDataModel.init(json: element as! NSDictionary)
                self.languageArray.append(language)
            }
        }
        
    }
    init() {
        ProfileDic = NSMutableDictionary()
        userImage = ""
        userFirstName = ""
        userLastName = ""
        userID = ""
        email = ""
        mobile_number = ""
        name = ""
        token = ""
        type = ""
        description = ""
        linkedin = ""
        nationality = ""
        country_of_residence = ""
        experience = ""
        nationality_Dic = NSDictionary()
        country_of_residence_Dic = NSDictionary()
        workExperienceArray = []
    }
}
