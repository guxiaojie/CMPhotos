//
//  PhotoRequest.swift
//  CMPhotos
//
//  Created by Guxiaojie on 14/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

import UIKit

class PhotoRequest: NSObject {
    static let WURL: String = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"

    class func downloadData(completion: @escaping (_ blog: Canada?,  _ error: Error?) -> Void ) {
        let request = URLRequest(url: URL(string: WURL)!)
        let session = URLSession.shared
        let downloadTask: URLSessionDownloadTask = session.downloadTask(with: request) { location, response, error in
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
            
            //why convert data?
            //Don't know why can't get JSON from JSONSerialization.jsonObject before converting
            //Here could be using Post instead of Download data/thrid part json/Swift 4 JSONDecoder()
            let convertString: NSString = NSString(data: data, encoding: 0)!
            guard let convertedData = convertString.data(using: String.Encoding.utf8.rawValue) else {
                print("Error: Couldn't convert data")
                completion(nil, error)
                return
            }
            
            completion(PhotoRequest.parseData(data: convertedData), error)

        }
        downloadTask.resume()
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
    
    class func parseData(data: Data!) -> Canada? {
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let rows = json["rows"] as? [[String: Any]] {
                
                //init canada model
                let canada: Canada = Canada()
                if let title = json["title"] as? String {
                    canada.title = title
                }
                
                //add photos to canada
                var photos = [Photo]()
                for photo in rows {
                    let aPhoto = Photo()
                    if let title = photo["title"] as? String {
                        aPhoto.title = title
                    }
                    if let description = photo["description"] as? String {
                        aPhoto.description = description
                    }
                    if let imageHref = photo["imageHref"] as? String {
                        aPhoto.imageHref = imageHref
                    }
                    photos.append(aPhoto)
                }
                canada.rows = photos
                
                return canada
                
            } else {
                
                return nil
            }
        } catch {
            print("Error deserializing JSON: \(error)")
            return nil
            
        }
    }
}
