//
//  String_extension.swift
//  多线程介绍
//
//  Created by 武龙涛 on 2016/12/21.
//  Copyright © 2016年 武龙涛. All rights reserved.
//

import UIKit

extension String {
    //追加文档目录
    func appendImageCachePath()->URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let folderPath = documentDirectory.appendingPathComponent("Images")
        createIfNotExist(path: folderPath)
        let imageCaCheUrl = folderPath.appendingPathComponent((self as NSString).lastPathComponent)
        return imageCaCheUrl
    }
    //判断如果不存在改该文件夹，创建一个文件夹
    private func createIfNotExist(path : URL){
        if !FileManager.default.fileExists(atPath: path.absoluteString) {
            try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
