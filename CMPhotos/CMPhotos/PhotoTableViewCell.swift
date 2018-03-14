//
//  PhotoTableViewCell.swift
//  CMPhotos
//
//  Created by Guxiaojie on 14/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    var photoImageView = UIImageView()
    var titleLabel: UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    
    var photo: Photo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        photoImageView.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        setupConstraint()
    }
    
    func setupConstraint() {
        //photoImageView
        let viewsDictionary = ["image": photoImageView, "title": titleLabel, "description": descriptionLabel]
        let constraintHeight = NSLayoutConstraint.constraints(withVisualFormat: "H:[image(80)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let constraintV = NSLayoutConstraint.constraints(withVisualFormat: "V:[image(80)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let constraintH = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[image]", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDictionary)
        photoImageView.addConstraints(constraintHeight)
        photoImageView.addConstraints(constraintV)
        
        //titleLabel
        let marginsDictionary = ["leftMargin": 10, "rightMargin": 10, "viewSpacing": 10]
        let constraintTitleH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[image]-viewSpacing-[title]-rightMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: marginsDictionary, views: viewsDictionary)
        let constraintTitleV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[title]", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDictionary)
        
        //descriptionLabel
        let viewSpacing: CGFloat = 10
        let constraintDescV = NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: viewSpacing)
        let constraintDescH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[image]-viewSpacing-[description]-rightMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: marginsDictionary, views: viewsDictionary)
        
        //so use UITableViewAutomaticDimension to return right cell Height
        let bottomMargin: CGFloat = 10
        let constraintDescBottom = NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -bottomMargin)
        constraintDescBottom.priority = UILayoutPriority(rawValue: 999)
        
        //set the minimum height of cell = descriptionLabel.top + 55 + descriptionLabel.bottomMargin
        let descMinHeight: CGFloat = 55
        let constraintDescHeight = NSLayoutConstraint(item: descriptionLabel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: descMinHeight)
        constraintDescHeight.priority = UILayoutPriority(rawValue: 1000)
        descriptionLabel.addConstraint(constraintDescHeight)
        
        contentView.addConstraints(constraintH)
        contentView.addConstraints(constraintTitleH)
        contentView.addConstraints(constraintTitleV)
        contentView.addConstraint(constraintDescV)
        contentView.addConstraints(constraintDescH)
        contentView.addConstraint(constraintDescBottom)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func reloadData(photo: Photo) {
        self.titleLabel.text = photo.title ?? "No title!😕"
        self.descriptionLabel.text = photo.description ?? "No description!😒"
        
        //Here use SDWebImage
        //Other wise I'll category UIImage (download Data and Manage Cache and so on)
        //self.photoImageView.sd_setImage(with: URL(string: photo.imageHref ?? ""), placeholderImage: UIImage(named: "cloud.png"))
    }

}
