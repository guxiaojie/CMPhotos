//
//  PhotoRequest.swift
//  CMPhotos
//
//  Created by Guxiaojie on 14/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

import UIKit
import SwiftyJSON

class PhotoRequest: NSObject {
    static let WURL: String = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"

    class func downloadData(completion: @escaping (_ blog: Canada?,  _ error: Error?) -> Void ) {
        let request = URLRequest(url: URL(string: WURL)!)
        let session = URLSession.shared
        
        let dataTask : URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            
            guard data != nil && error == nil else {
                print(error ?? "Error")
                completion(nil, error)
                return
            }
            
            completion(PhotoRequest.parseData(data: data!), error)

        }
        dataTask.resume()
    }
    
    //load from cache first, then download if not cached
    class func downloadImg(urlStr: String?, completion: @escaping (_ img: Data?,  _ error: Error?) -> Void ) {
        if urlStr == nil {
            return
        }
        let aUrl = URL(string: urlStr!)
        guard let url = aUrl else {
            return
        }
        
        let imageCachePath = urlStr!.appendImageCachePath()
        let cacheData = try? Data(contentsOf: imageCachePath)
        if cacheData != nil {
            completion(cacheData!, nil)
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let downloadTask: URLSessionDownloadTask = session.downloadTask(with: request) { location, response, error in
            DispatchQueue.main.async {
                
                guard location != nil && error == nil else {
                    print(error ?? "Error")
                    completion(nil, error)
                    return
                }
                
                guard let data = try? Data(contentsOf: location!) else {
                    print("Error: Couldn't read data")
                    completion(nil, error)
                    return
                }
                completion(data, error)
                
                do {
                    try? data.write(to:
                        imageCachePath, options: Data.WritingOptions.completeFileProtectionUntilFirstUserAuthentication)
                }
            }
        }
        downloadTask.resume()
    }
    
    class func parseData(data: Data) -> Canada? {
        let dataString = String(data: data, encoding: String.Encoding.isoLatin1)
        guard let jsonString = dataString else {
            print("JSON Format Error!")
            return nil
        }
        
        let json = JSON(parseJSON: jsonString)
        
        let canada: Canada = Canada()
        canada.title = json["title"].string
        
        var photos = [Photo]()
        for row in json["rows"].arrayValue {
            photos.append(Photo(json: row))
        }
        canada.rows = photos
        
        return canada
    }
}
