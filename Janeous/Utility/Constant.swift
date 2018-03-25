//
//  LoginView.swift
//  getAvis
//
//  Created by SS142 on 01/08/16.
//  Copyright © 2016 SS142. All rights reserved.
//

import Foundation
import NHAlignmentFlowLayout


let BASE_URL = "http://115.249.91.203:6161/janeous/public/api/v1/" //Development

let appDel = UIApplication.shared.delegate as! AppDelegate

let device  = UIDevice.current.model

//MARK:- Web service
let countryList = "countries"
let companySignUp = "company-signup"
let candidateSignUp = "candidate-signup"
let login = "login"
let sendOTP = "send-otp-mobile"
let countryCodes = "country_phone_codes";
let createPassword = "create-new-password";
let forgotPassword = "forgotpassword";
let verifyOTP = "otp-verification";
let resetPassword = "resetpassword";
let candidateChangePassword = "candidate/change-password";
let clientuserlist = "client/user/list";
let addWorkExperience = "candidate/work-experience/add";
let editWorkExperience = "candidate/work-experience/edit";
let addEducationExperience = "candidate/education/add";
let editEducationExperience = "andidate/education/edit";
let deleteEducationExperience = "candidate/education/delete";
let addCandidateGeneralInfo = "candidate/add-general-info";
let addCertificate = "candidate/certificate/add";
let editCertificate = "candidate/certificate/edit";
let generalWebService = "general";
let addSkills = "candidate/skill/add";
let addLanguage = "candidate/language/add";
let editLanguage = "candidate/language/edit";
let addExpYears = "candidate/experience/add";

//Client
let clientAddUser = "client/client-create-user";
let clientEditUser = "client/client-update-user";

//MARK:- MODELS
var userData:CandidateProfile!

func initialiseUserData()
{
    userData = CandidateProfile.init()
    
    if UserDefaults.standard.object(forKey: "userData") != nil
    {
       userData = CandidateProfile.init(json: UserDefaults.standard.object(forKey: "userData") as! NSDictionary)
    }
}

//MARK:- Color from Hex
func hexStringToUIColor (hex:String) -> UIColor
{
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//MARK:- Validations
func isValidEmail(testStr:String) -> Bool
{
    
    let emailRegEx = "(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
    return emailTest.evaluate(with: testStr)
}

func isValidPassword(testStr:String) -> Bool
{
    let passwordRegex:String = "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!#$%&'*+,-./:;<=>?@|~]).{8,15}"
    let passTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
    
    return passTest.evaluate(with: testStr)
}

func numberFiler(string:String) -> Bool
{
    let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
    let compSepByCharInSet = string.components(separatedBy: aSet)
    let numberFiltered = compSepByCharInSet.joined(separator: "")
    if string != numberFiltered
    {
        return false
    }
    
    return true
}

//MARK:- NHAlignment Layout
func getCollectionViewFlowLayout() -> NHAlignmentFlowLayout
{
    
    let layout = NHAlignmentFlowLayout()
    
    layout.alignment = NHAlignment.topLeftAligned
    layout.minimumInteritemSpacing = 5.0;
    layout.minimumLineSpacing = 5.0;
    return layout
}

func getCollectionViewFlowLayout2() -> NHAlignmentFlowLayout
{
    let layout = NHAlignmentFlowLayout()
    
    layout.alignment = NHAlignment.topLeftAligned
    layout.minimumInteritemSpacing = 10.0;
    layout.minimumLineSpacing = 5.0;
    
    return layout
}

//MARK:- DropDown

func dropDownUISetup(){
    let appearance = DropDown.appearance()
    appearance.cellHeight = 40
    appearance.backgroundColor = UIColor(white: 1, alpha: 1)
    appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
    //        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
    appearance.cornerRadius = 5
    appearance.shadowColor = UIColor(white: 0.6, alpha: 0.5)
    appearance.shadowOpacity = 0.5
    appearance.shadowRadius = 10
    appearance.animationduration = 0.25
    appearance.textColor = defaultDarkTextColor()
    appearance.textFont = UIFont(name: defaultRegular, size: textFontSize14)!
}

//MARK:- Remove Dictionary NULL value
func removeAllNullValues(tempDic:NSMutableDictionary) -> NSMutableDictionary
{
    for key in tempDic.allKeys
    {
        if tempDic.object(forKey: key) is NSNull
        {
            tempDic.setValue("", forKey: key as! String)
        }
        else if tempDic.object(forKey: key) is NSDictionary
        {
             tempDic.setValue(removeAllNullValues(tempDic: (tempDic.object(forKey: key) as! NSDictionary).mutableCopy() as! NSMutableDictionary), forKey: key as! String)
        }
        else if tempDic.object(forKey: key) is NSArray &&  (tempDic.object(forKey: key) as! NSArray).count > 0
        {
            
            if (tempDic.object(forKey: key) as! NSArray).object(at: 0) is NSDictionary
            {
                let tempArr = NSMutableArray()
                for dic in (tempDic.object(forKey: key) as! NSArray)
                {
                    let mutableDic:NSMutableDictionary = removeAllNullValues(tempDic: (dic as! NSDictionary).mutableCopy() as! NSMutableDictionary)
                    tempArr.add(mutableDic)
                }
                
                tempDic.setValue(tempArr, forKey: key as! String)
            }
        }
    }
    
    return tempDic
}

func overwriteDefaultUserDataValues(tempDic:NSMutableDictionary)
{
    let defaultMutableDic = (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).mutableCopy() as! NSMutableDictionary
    
    for key in tempDic.allKeys
    {
        if tempDic.object(forKey: key) is NSNull
        {
            defaultMutableDic.setValue("", forKey: key as! String)
        }
        else
        {
            defaultMutableDic.setValue(tempDic.object(forKey: key), forKey: key as! String)
        }
    }
    
    UserDefaults.standard.setValue(defaultMutableDic, forKey: "userData")
    UserDefaults.standard.synchronize()
    initialiseUserData()
}

class CommonValidations: NSObject
{
    //MARK: Validate Email
    class func isValidEmail(testStr:String) -> Bool
    {
        
        let emailRegEx = "(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }
    
    
    class func isValidPassword(testStr:String) -> Bool
    {
        let passwordRegex:String = "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!#$%&'*+,-./:;<=>?@|~]).{8,15}"
        let passTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        
        return passTest.evaluate(with: testStr)
    }
    
    
    class func isValidNO(testStr:String, range: Int) -> Bool
    {
        if testStr.characters.count < range
        {
            return false
        }
        else
        {
            return true
        }
        
    }
    
    class func numberLimit(testStr:String, min: Int, max: Int) -> Bool
    {
        if testStr.characters.count < min || testStr.characters.count > max
        {
            return false
        }
        else
        {
            return true
        }
        
    }
    
    //MARK: Get The Color From RGB
    
    class func isValidDate(from: Date, until: Date, flag: Int) -> Bool
    {
        var value:Bool! = Bool()
        
        switch from.compare(until)
        {
        case .orderedAscending     :
            value = true
            
        case .orderedDescending    :
            value = false
            
        case .orderedSame          :
            value = true
            
        }
        
        if flag == 0
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let from1 : NSString = dateFormatter.string(from: from) as NSString
            let until1 : NSString = dateFormatter.string(from: until) as NSString
            
            if from1 == until1
            {
                value = false
            }
            
        }
        return value
    }
    
    
    
    //MARK:- Common Webservice Method
    
    
    /// Common Webservice Method
    ///
    /// - Parameters:
    ///   - url: server url
    ///   - parameter: parameter passed as NSMutuable Dictionary
    ///   - completion: save responseObject as NSDictionary
    
    
    func makeWebServiceCall (url: String, parameter: NSMutableDictionary, completion: @escaping (_ JSON : Any) -> ()) {
        
       // supportingfuction.hideProgressHudInView(view: self)
        if isConnectivity(){
            
            APISniper().postDataFromWebAPI(url, parameter, { (operation, responseObject) in
                
                supportingfuction.hideProgressHudInView(view: self)
                print("RESPONSE: \(responseObject)")
                
                completion((responseObject as! NSDictionary))
                
                
            }, { (operation, error) in
                
                // Error Block
                supportingfuction.hideProgressHudInView(view: self)
                supportingfuction.showMessageHudWithMessage(message: "Please try again.", delay: 2.0)

            })
        }else{
            supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
            
        }
        
    }
    
    func makeFormDataWebServiceCall (url: String, parameter: NSMutableDictionary,ImageDataDic:NSMutableDictionary, completion: @escaping (_ JSON : Any) -> ()) {
        
        // supportingfuction.hideProgressHudInView(view: self)
        if isConnectivity(){
            
            APISniper().postFormDataFromWebAPI(url, parameter, ImageDataDic, { (operation, responseObject) in
                
                supportingfuction.hideProgressHudInView(view: self)
                print("RESPONSE: \(responseObject)")
                
                completion((responseObject as! NSDictionary))
                
            }, { (operation, error) in
                // Error Block
                supportingfuction.hideProgressHudInView(view: self)
                supportingfuction.showMessageHudWithMessage(message: "Please try again.", delay: 2.0)
            })
           
        }else{
            supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
            
        }
        
    }
    
    
    func isConnectivity() -> Bool{
        
        let reachability = Reachability.forInternetConnection()
        //        let reachability = Reachability()
        //    let reach = reachability.forInternetConnection()
        
        if (reachability?.isReachable())!{
            return true
        }else{
            return false
        }
    }
    
}

func widthForView( text:String, font:UIFont, height:CGFloat) -> CGRect{
    let lbl:UILabel = UILabel(frame: CGRect(x:0, y:0, width:CGFloat.greatestFiniteMagnitude,height:21))
    lbl.numberOfLines = 1
    lbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
    lbl.font = font
    lbl.text = "\(text)"
    lbl.sizeToFit()
    
    return lbl.frame
    
}

//calculate the frame of the lable according to its height
func heightForView( text:String, font:UIFont, width:CGFloat) -> CGRect{
    let lbl:UILabel = UILabel(frame: CGRect(x:0, y:0, width:width,height:CGFloat.greatestFiniteMagnitude))
    lbl.numberOfLines = 0
    lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
    lbl.font = font
    lbl.text = "\(text)"
    lbl.sizeToFit()
    
    return lbl.frame
    
}




