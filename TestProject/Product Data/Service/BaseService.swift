//
// BaseService.swift
// BaseFoundation
//
//  Created by VJ on 11/09/19.
//  Copyright © 2020 VJ. All rights reserved.
//

import Foundation
import Alamofire

/// Service call from network
public class BaseService {
    
    
    /// Fetch Data from Server
    ///
    /// - Parameters:
    ///   - url: URL of the server call
    ///   - headers: Headers in the request
    ///   - params: Params to be send in get request
    ///   - completionHandler: Completion handler once call is done
    ///   - fetchCachedData: Fetch data from cache - If not found then it will call from network
    func fetchData(url: URL?, method: HTTPMethod, headers: HTTPHeaders? = nil, params: [String : Any]? = nil, completionHandler:  ((Data?, Error?) -> Void)?) {
        
        guard let url = url else {
            BaseLogger.errorLog(message: "ETService - Url is Nil")
            completionHandler?(nil, BaseUtilities.createError(msg: "Url is nil", statusCode: 500))
            return
        }
        
        let urlStr = url.absoluteString
        
        //By default json encoding in params
        var encoding : ParameterEncoding = JSONEncoding.default
        if method == .get {
            encoding = URLEncoding.default
        }
        
        let dataRequest = AF.request(url, method: method,  parameters: params, encoding: encoding, headers: headers ?? BaseService.etHeaders)
        
        BaseLogger.infoLog(message: "ETService - Network Call Started - \(urlStr)")

        dataRequest.responseJSON { (response) in
            
            completionHandler?(response.data, response.error)
            
            //Dump responses to the file
            if BaseUtilities.shouldDumpResponses {
//                ETStorageManager.saveDataInDocumentsFileSystem(data: response.data, filePath: response.request?.url)
            }
            
            //Logout if required
            if let _ = response.error {
                self.logoutUserIfNeeded(response: response.response)
            } else {
                self.logoutUserIfNeeded(data: response.data)
            }
            
            BaseLogger.dataLog(message: "ETService - Response Data from Network - \( String(data: response.data ?? Data(), encoding: .utf8) ?? "")")
            BaseLogger.infoLog(message: "ETService - Network Call Finished - \(urlStr)")
            if let error = response.error {
                BaseLogger.errorLog(message: "ETService - Error - \(error)")
            }
        }
    }
    
    /// Upload Data to Server
    ///
    /// - Parameters:
    ///   - url: URL of the server call
    ///   - headers: Headers in the request
    ///   - params: Params to be send in get request
    ///   - completionHandler: Completion handler once call is done
    ///   - fetchCachedData: Fetch data from cache - If not found then it will call from network
    func uploadData(url: URL?, method: HTTPMethod, headers: HTTPHeaders? = nil, params: [String : Any]? = nil, completionHandler:  ((Data?, Error?) -> Void)?) {
        
        guard let url = url else {
            BaseLogger.errorLog(message: "ETService - Url is Nil")
            completionHandler?(nil, BaseUtilities.createError(msg: "Url is nil", statusCode: 500))
            return
        }
        
        let urlStr = url.absoluteString
        
        let boundary = NSUUID().uuidString
        var headerUpload = headers ?? BaseService.etHeaders
        headerUpload["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        
        //Request alamofire for network call
        BaseLogger.infoLog(message: "ETMService - Upload Started - \(urlStr)")
        
        AF.upload(multipartFormData: { multiPart in
            
            for (key, value) in params ?? [String : Any]() {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            
            if let imageData = params?["photo"] as? Data {
                let mimeType = params?["mime_type"] as? String
                multiPart.append(imageData, withName:"photo", fileName: "sample", mimeType: mimeType)
            }
        }, to: url, method:method, headers: headers) .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(data)")
        }).response { (response) in
            switch response.result {
            case .success(_):
                BaseLogger.infoLog(message: "ETService - Upload Finished Success - \(urlStr)")
                completionHandler?(response.data, response.error)
            case .failure(_):
                BaseLogger.errorLog(message: "ETService - Upload Finished Fail - \(urlStr)")
                completionHandler?(response.data, response.error)
            }
        }
    }
    
    // MARK :- Helpers
    
    /// Updated headers for the App
    static var etHeaders : HTTPHeaders {
        var httpHeaders = HTTPHeaders()
        httpHeaders["Content-Type"] = "application/json"
        return httpHeaders
    }
    
    /// Logout user if required
    ///
    /// - Parameter response: HTTPURLResponse
    private func logoutUserIfNeeded(response: HTTPURLResponse?) {
        guard let _ = response else {
            return
        }
        
        //BaseUtilities.logout()
    }
    
    /// Logout user if required
    ///
    /// - Parameter data: Data of the reponse
    private func logoutUserIfNeeded(data: Data?) {
        guard let _ = data else {
            return
        }
        
        //BaseUtilities.logout()
    }
}
