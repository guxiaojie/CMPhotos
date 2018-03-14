//
//  UIImageView_extension.swift
//  CMPhotos
//
//  Created by Guxiaojie on 14/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

import UIKit

extension UIImageView {
    
    //****lack of cache; Should load from cache first, then download if not cached
    
    func cm_setImage(urlStr : String?, placeholder : UIImage? = nil){
        self.image = placeholder
        if urlStr == nil {
            return
        }
        let url = URL(string: urlStr!)
        if url == nil {
            return
        }
        
        let request = URLRequest(url: URL(string: urlStr!)!)
        let session = URLSession.shared
        let downloadTask: URLSessionDownloadTask = session.downloadTask(with: request) { location, response, error in
            guard location != nil && error == nil else {
                print(error ?? "Error")
                return
            }
            
            guard let data = try? Data(contentsOf: location!) else {
                print("Error: Couldn't read data")
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }

        }
        downloadTask.resume()
    }
    
}


