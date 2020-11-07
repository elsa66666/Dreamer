//
//  OssClient.swift
//  dreamer1
//
//  Created by 陈宥伊 on 2020/10/14.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import Foundation
import AliyunOSSiOS
import Alamofire

class OssClient{
    private var ossPutObj: OSSPutObjectRequest?
    private let BucketName = "dream-diaries"
    private let EndPoint = "http://oss-cn-hangzhou.aliyuncs.com"
    public static var ossClient:OSSClient!
    
    public static func getToken()
    {
        //上传配置设置
        let conf = OSSClientConfiguration()
        conf.maxRetryCount = 2
        conf.timeoutIntervalForRequest = 300
        conf.timeoutIntervalForResource = TimeInterval(24 * 60 * 60)
        conf.maxConcurrentRequestCount = 50
            
        //实现获取StsToken回调
        let credential2:OSSCredentialProvider = OSSFederationCredentialProvider.init(federationTokenGetter: { () -> OSSFederationToken? in
            
            let tcs = OSSTaskCompletionSource<AnyObject>.init()
            let parameters:Dictionary = ["RoleArn":"acs:ram::223978402681851798:role/AliyunOSSTokenGeneratorUser@1740695921595744.onaliyun.com", "RoleSessionName":"alice", "DurationSeconds": "3600"]
            Alamofire.request("https://sts.aliyuncs.com?Action=AssumeRole", method: .get, parameters: parameters).responseJSON { (response) in
                print(response.result.value as Any)
                    if let value = response.result.value {
                        do
                        {
                            if let parseJSON = try JSONSerialization.jsonObject(with: value as! Data, options: []) as? NSDictionary {

                                let resultValue:String = parseJSON["Code"] as! String

                                if(resultValue == "1")
                                {
                                    tcs.setResult(parseJSON as AnyObject?)
                                }
                                else{
                                    tcs.setError("error" as! Error)
                                }
                            }
                        }
                        catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
            }
                 
            tcs.task.waitUntilFinished()
                 
            if tcs.task.error != nil {
                return nil
            }else {
                let jsonData = tcs.task.result as AnyObject,
                tokenInfo:OSSFederationToken = OSSFederationToken()
                     
                tokenInfo.tAccessKey = jsonData["AccessKeyId"] as! String
                tokenInfo.tSecretKey = jsonData["AccessKeySecret"] as! String
                tokenInfo.tToken = jsonData["SecurityToken"] as! String
                tokenInfo.expirationTimeInGMTFormat = (jsonData["Expiration"] as! String)
                    
                return tokenInfo
            }
                
        })
             
        //实例化
        OssClient.ossClient = OSSClient(endpoint: "oss-cn-hangzhou.aliyuncs.com", credentialProvider: credential2, clientConfiguration: conf)
        print(OssClient.ossClient as Any)
    }
    
    public static func initClient()
    {
        //上传配置设置
        let conf = OSSClientConfiguration()
        conf.maxRetryCount = 2
        conf.timeoutIntervalForRequest = 300
        conf.timeoutIntervalForResource = TimeInterval(24 * 60 * 60)
        conf.maxConcurrentRequestCount = 50
            
        //实现获取StsToken回调
        let credential2:OSSCredentialProvider = OSSFederationCredentialProvider.init(federationTokenGetter: { () -> OSSFederationToken? in
            
            let tcs = OSSTaskCompletionSource<AnyObject>.init()
                
            Alamofire.request("https://sts.aliyuncs.com:443", method: .get, parameters: [: ]).responseJSON { (response) in
                         
                    if let value = response.result.value {
                        do
                        {
                            if let parseJSON = try JSONSerialization.jsonObject(with: value as! Data, options: []) as? NSDictionary {

                                let resultValue:String = parseJSON["Code"] as! String

                                if(resultValue == "1")
                                {
                                    tcs.setResult(parseJSON as AnyObject?)
                                }
                                else{
                                    tcs.setError("error" as! Error)
                                }
                            }
                        }
                        catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    }
            }
                 
            tcs.task.waitUntilFinished()
                 
            if tcs.task.error != nil {
                return nil
            }else {
                let jsonData = tcs.task.result as AnyObject,
                tokenInfo:OSSFederationToken = OSSFederationToken()
                     
                tokenInfo.tAccessKey = jsonData["AccessKeyId"] as! String
                tokenInfo.tSecretKey = jsonData["AccessKeySecret"] as! String
                tokenInfo.tToken = jsonData["SecurityToken"] as! String
                tokenInfo.expirationTimeInGMTFormat = (jsonData["Expiration"] as! String)
                    
                return tokenInfo
            }
                
        })
             
        //实例化
        OssClient.ossClient = OSSClient(endpoint: "oss-cn-hangzhou.aliyuncs.com", credentialProvider: credential2, clientConfiguration: conf)
        print(OssClient.ossClient as Any)
    }
    
    //上传图片
    public static func uploadPic(url: URL) {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd"
        let ossPutObj: OSSPutObjectRequest = OSSPutObjectRequest()
        //key为上传到阿里云的路径
        let key = "shortcut/" + timeFormatter.string(from: date) as String + ".jpg"
         
        ossPutObj.bucketName = "dream-diaries"
        ossPutObj.objectKey = key
        ossPutObj.uploadingFileURL = url
         
        ossPutObj.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
            print(String(bytesSent) + "/" + String(totalBytesSent) + "/" + String(totalBytesExpectedToSend))
        }
         
        let uploadTask = OssClient.ossClient?.putObject(ossPutObj)
         
        uploadTask?.continue({ (uploadTask) -> Any? in
             
            if let _err = uploadTask.error {
                print(_err)
            }
            else {
                print("success")
            }
            
            return uploadTask
        })
        OSSLog.enable()
    }
}

