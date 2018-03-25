//
//  APISniper.swift
//  BZR
//
//  Created by SS-113 on 26/09/16.
//  Copyright © 2016 singsys. All rights reserved.
//

import Foundation
import AFNetworking
class APISniper : NSObject
{
    typealias CompleteBlock = ( _ operation: AFHTTPRequestOperation,  _ responseObject: Any) -> Void
    typealias ErrorBlock = ( _ operation: AFHTTPRequestOperation?,  _ error: Error) -> Void
    
    func httpManager(baseUrl: String) -> AFHTTPRequestOperationManager
    {
        let httpManager = AFHTTPRequestOperationManager(baseURL: URL(string: baseUrl))
        let requestSerializer : AFJSONRequestSerializer = AFJSONRequestSerializer()
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        if userData.token != ""
        {
             requestSerializer.setValue("Bearer \(userData.token!)", forHTTPHeaderField: "Authorization")
        }
        httpManager.requestSerializer = requestSerializer
        return httpManager
    }
    
    //MARK: POST Method
    func postDataFromWebAPI(_ url: String, _ requestData: NSMutableDictionary, _ completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {
        self.httpManager(baseUrl: BASE_URL).post(url, parameters: requestData, success: completeBlock, failure: errorBlock)
        
    }
    
    //FORM DATA
    func postFormDataFromWebAPI(_ url: String, _ requestData: NSMutableDictionary,_ imageDataDic:NSMutableDictionary, _ completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {
        self.httpManager(baseUrl: BASE_URL).post(url, parameters: requestData, constructingBodyWith: { (formData) in
            
            for key in imageDataDic.allKeys
            {
                formData.appendPart(withFileData: imageDataDic.object(forKey: key) as! Data,
                                                name: "key",
                                                fileName: "image.png",
                                                mimeType: "image/png")
            }
            
        }, success: completeBlock, failure: errorBlock)
   
    }
    
    //MARK : GET Method
    func getDataFromWebAPIWithGet(_ url: String, _ requestData: NSMutableDictionary, _ completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {
        self.httpManager(baseUrl: BASE_URL).get(url, parameters: requestData, success: completeBlock, failure: errorBlock)
    }
    
    // MARK: Get data from Web API containing token Header
    func hitWebAPIWithTokenHeaderToGetData(_ url: String, _ requestData: NSMutableDictionary, _ completeBlock: @escaping CompleteBlock, _ errorBlock: @escaping ErrorBlock)
    {
        let httpManager = AFHTTPRequestOperationManager(baseURL: URL(string: BASE_URL))
        
        let requestSerializer : AFJSONRequestSerializer = AFJSONRequestSerializer()
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        requestSerializer.setValue("Bearer \(UserDefaults.standard.object(forKey: "token") as! String)", forHTTPHeaderField: "Authorization")
    
        httpManager.requestSerializer = requestSerializer
        httpManager.post(url, parameters: requestData, success: completeBlock, failure: errorBlock)
    }
    
   
    func toUploadMultipleImagesOnServer( url: String,  requestData: NSMutableDictionary,  imageArray: NSArray, completeBlock: @escaping CompleteBlock,  errorBlock: @escaping ErrorBlock)
    {
        let httpManager = AFHTTPRequestOperationManager(baseURL: URL(string: BASE_URL))
        
        let requestSerializer : AFJSONRequestSerializer = AFJSONRequestSerializer()
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        httpManager.requestSerializer = requestSerializer
        
        httpManager.post(url, parameters: requestData, constructingBodyWith: { formData -> Void in
            for i in 0 ..< imageArray.count
            {
                if url.contains("addPhoto")
                {
                    formData.appendPart(withFileData: imageArray.object(at: i) as! Data,
                                        name: "image",
                                        fileName: "image.png",
                                        mimeType: "image/png")
                }
               else
                {
                    formData.appendPart(withFileData: imageArray.object(at: i) as! Data,
                                        name: "profile_picture",
                                        fileName: "profile_picture.png",
                                        mimeType: "image/png")
                }
                
                    
                }
                
            
        }, success: completeBlock, failure: errorBlock)
    }
    
    
    func toUploadVideoOnServer( url: String,  requestData: NSMutableDictionary, videoData: NSData, imageData: NSData, completeBlock: @escaping CompleteBlock,  errorBlock: @escaping ErrorBlock)
    {
        let httpManager = AFHTTPRequestOperationManager(baseURL: URL(string: BASE_URL))
        
        let requestSerializer : AFJSONRequestSerializer = AFJSONRequestSerializer()
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        httpManager.requestSerializer = requestSerializer
        
        httpManager.post(url, parameters: requestData, constructingBodyWith: { formData -> Void in
          
            formData.appendPart(withFileData: videoData as Data,
                                        name: "video_file",
                                        fileName: "video.mp4",
                                        mimeType: "video/mp4")
            
                    formData.appendPart(withFileData: imageData as Data,
                                        name: "thumbnail",
                                        fileName: "thumbnail.png",
                                        mimeType: "image/png")
            
            
        }, success: completeBlock, failure: errorBlock)
    }
    
}
