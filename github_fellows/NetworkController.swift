//
//  NetworkController.swift
//  github_fellows
//
//  Created by nacnud on 1/24/15.
//  Copyright (c) 2015 nanud. All rights reserved.
//

import UIKit

class NetworkController {
    
    // singleton class
    class var sharedNetworkController : NetworkController {
        struct Static {
            static let instance: NetworkController = NetworkController()
        }
        return Static.instance
    }
    
    let clientSecret = "f486a408aa44ed52390b5aaba591354949d20c66"
    let clientID = "b7474d3ec04cfb911e6a"
    var urlSession : NSURLSession
    let accessTokenUserDefaultsString = "accessToken"
    var accessToken : String?
    let imageQueue = NSOperationQueue()
    
    init() {
        let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        self.urlSession = NSURLSession(configuration: ephemeralConfig)
        if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey(self.accessTokenUserDefaultsString) as? String {
            self.accessToken = accessToken
        }
    }
    
    func requestAccessToken(){
        if let url = NSURL(string: "https://github.com/login/oauth/authorize?client_id=\(self.clientID)&scope=user,repo") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func handleCallBackURL(url: NSURL) {
        let requestToken = url.query
        let bodyString = "\(requestToken!)&client_id=\(self.clientID)&client_secret=\(self.clientSecret)"
        let bodyData = bodyString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let length = bodyData!.length
        let postRequest = NSMutableURLRequest(URL: NSURL(string: "https://github.com/login/oauth/access_token")!)
        postRequest.HTTPMethod = "POST"
        postRequest.setValue("\(length)", forHTTPHeaderField: "Content-Length")
        postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        postRequest.HTTPBody = bodyData
        
        let dataTask = self.urlSession.dataTaskWithRequest(postRequest, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        // this is good
                        println("goodwerk statusCode: \(httpResponse.statusCode)")
                        let requestTokenResponse = NSString(data: data, encoding: NSASCIIStringEncoding)
                        let accessTokenComponet = requestTokenResponse?.componentsSeparatedByString("&").first as String
                        let accessToken = accessTokenComponet.componentsSeparatedByString("=").last
                        println(accessToken!)
                        
                        NSUserDefaults.standardUserDefaults().setObject(accessToken!, forKey: self.accessTokenUserDefaultsString)
                        NSUserDefaults.standardUserDefaults().synchronize()
                    default:
                        println("bad statuscode case")
                        
                    }
                }
            } else {
                // error wasnt nill
                let alertView = UIAlertView(title: "ERROR", message: "i bet your wifi is off", delegate: nil, cancelButtonTitle: "ok")
                alertView.show()
            }// end dataTask completionHandler
        })
        dataTask.resume()
    }// end handleCallBackUrl
    
    
    func fetchRepositoriesForSearchTerm(searchTerm: String, callback: ([Repository]?, String?) -> (Void) ){
        let url = NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)")
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        
        let dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        println("booya got statusCode: \(httpResponse.statusCode) on fetchRepo call")
                        let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as [String: AnyObject]
                        var foundRepos : [Repository] = []
                        if let repoArray = jsonDictionary["items"] as? [[String: AnyObject]] {
                            for repoDict in repoArray {
                                let repo = Repository(jsonDictionary: repoDict)
                                foundRepos.append(repo)
                            }
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                callback(foundRepos, nil)
                            })
                        }
                    default:
                        println("ut oh got bad status code on repoSearch: \(httpResponse.statusCode)")
                    }
                }
            } else {
                // datatask hada error
                let alertView = UIAlertView(title: "ERROR", message: "i bet your wifi is off", delegate: nil, cancelButtonTitle: "ok")
                alertView.show()
            }
        })
        dataTask.resume()
        
    }// end fetrch repo call
    

    func fetchUsersForSearchTerm(searchTerm : String, callback : ([User]?, String?) -> (Void)) {
        let url = NSURL(string: "https://api.github.com/search/users?q=\(searchTerm)")
        let request = NSMutableURLRequest(URL: url!)
        //this line is how github knows who is making the request
        request.setValue("token \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        
        
        let dataTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200...299:
                        if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
                            if let userArray = jsonDictionary["items"] as? [[String : AnyObject]] {
                                
                                var foundUsers = [User]()
                                
                                for userDict in userArray {
                                    let user = User(jsonDictionary: userDict)
                                    foundUsers.append(user)
                                }
                                
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    callback(foundUsers, nil)
                                })
                            }
                        }
                        
                    default:
                        println("default case on user search, status code: \(httpResponse.statusCode)")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            callback(nil, error.localizedDescription)
                        })
                    }
                }
                
            } else {
                println(error.localizedDescription)
                let alertView = UIAlertView(title: "ERROR", message: "i bet your wifi is off", delegate: nil, cancelButtonTitle: "ok")
                alertView.show()
            }
        })
        dataTask.resume()
    } // end fetch users
    
    func fetchAvatarImageFromURL(url: String, completionHandler: (UIImage) -> (Void)) {
        if let url = NSURL(string: url){
            self.imageQueue.addOperationWithBlock({ () -> Void in
                if let imageData = NSData(contentsOfURL: url){
                    if let image = UIImage(data: imageData) {
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completionHandler(image)
                        })
                    }
                }
            })
        }
    }
    
}
