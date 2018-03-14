//
//  String_extension.swift
//  CMPhotos
//
//  Created by Guxiaojie on 14/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

import UIKit

extension String {
    //path of cached Image
    func appendImageCachePath()->URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let folderPath = documentDirectory.appendingPathComponent("Images")
        createIfNotExist(path: folderPath)
        let imageCaCheUrl = folderPath.appendingPathComponent((self as NSString).lastPathComponent)
        return imageCaCheUrl
    }
    
    private func createIfNotExist(path : URL){
        if !FileManager.default.fileExists(atPath: path.absoluteString) {
            try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
