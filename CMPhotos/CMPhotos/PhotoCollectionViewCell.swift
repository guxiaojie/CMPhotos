//
//  PhotoCollectionViewCell.swift
//  CMPhotos
//
//  Created by Guxiaojie on 14/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var photoImageView = UIImageView()
    var titleLabel: UILabel = UILabel()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    func setupViews() {
        photoImageView.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.gray
        titleLabel.backgroundColor = UIColor(white: 1, alpha: 0.5)
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(titleLabel)

        setupConstraint()
      
    }
    
    func setImageConstraint() {
        let viewsDictionary = ["image": photoImageView]

        let marginsDictionary = ["leftMargin": 10, "rightMargin": 10, "viewSpacing": 10]
        let constraintH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[image]-rightMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: marginsDictionary, views: viewsDictionary)
        let constraintV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[image]", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDictionary)
        let bottomMargin: CGFloat = 10
        let constraintVBottom = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -bottomMargin)
        contentView.addConstraints(constraintH)
        contentView.addConstraints(constraintV)
        contentView.addConstraint(constraintVBottom)
    }
    
    func setupConstraint() {
        
        setImageConstraint()

        //photoImageView
        let viewsDictionary = ["title": titleLabel]
        
        //titleLabel
        let bottomMargin: CGFloat = 10
        let marginsDictionary = ["leftMargin": 10, "rightMargin": 10, "viewSpacing": 10]
        let constraintTitleH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[title]-rightMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: marginsDictionary, views: viewsDictionary)
        contentView.addConstraints(constraintTitleH)
        let constrainttitleBottom = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -bottomMargin)
        contentView.addConstraint(constrainttitleBottom)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func reloadData(photo: Photo) {
        self.titleLabel.text = photo.title ?? "No title!😕"
        self.photoImageView.cm_setImage(urlStr: photo.imageHref, placeholder: UIImage(named: "cloud.png"))
    }
    
    class func estimateHeight(photo: Photo, index: IndexPath, completion: @escaping (_ ratio: CGFloat, _ indexPath: IndexPath?) -> Void) {
        var aspectRatio: CGFloat = 1
        
        //tell controller get height from cached image
        if photo.imageHref != nil {
            let imageCachePath = photo.imageHref!.appendImageCachePath()
            let cacheData = try? Data(contentsOf: imageCachePath)
            if cacheData != nil {
                let size = UIImage(data: cacheData!)?.size
                if let aSize = size {
                    aspectRatio = aSize.height/aSize.width
                    completion(aspectRatio, nil)
                    return
                }
            }
        }
        

        PhotoRequest.downloadImg(urlStr: photo.imageHref) { (data, error) in
            if let aData = data {
                let size = UIImage(data: aData)?.size
                if let aSize = size {
                    aspectRatio = aSize.height/aSize.width
                    completion(aspectRatio, index)
                }
            }
        }
    }
    
}
