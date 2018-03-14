//
//  UIImageView_extension.swift
//  CMPhotos
//
//  Created by Guxiaojie on 14/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

import UIKit

extension UIImageView {
    //load from cache first, then download if not cached(PhotoRequest)
    func cm_setImage(urlStr : String?, placeholder : UIImage? = nil){
        
        self.image = placeholder
        
        if urlStr == nil {
            return
        }
        
        let url = URL(string: urlStr!)
        if url == nil {
            return
        }
        
        PhotoRequest.downloadImg(urlStr: urlStr) { (data, error) in
            if data != nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
    }
}


