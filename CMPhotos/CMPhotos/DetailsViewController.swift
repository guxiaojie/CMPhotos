//
//  DetailsViewController.swift
//  CMPhotos
//
//  Created by Guxiaojie on 14/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var photo: Photo?
    var photoImageView = UIImageView()
    var descriptionLabel: UILabel = UILabel()

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(photo: Photo) {
        self.init(nibName:nil, bundle:nil)
        self.photo = photo
        self.view.backgroundColor = UIColor.white
        commonInit()
        setupConstraint()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.orientationChanged(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = photo?.title ?? "No title!😕"
        self.photoImageView.cm_setImage(urlStr: photo?.imageHref, placeholder: UIImage(named: "cloud.png"))
        self.descriptionLabel.text = photo?.description ?? "No description!😒"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func commonInit() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.contentMode = .scaleAspectFit
        view.addSubview(photoImageView)

        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
    }
    
    func setupConstraint() {
        view.removeConstraints(view.constraints)
        let currentOrientation = UIApplication.shared.statusBarOrientation
        if UIInterfaceOrientationIsPortrait(currentOrientation) {
            setupOrientationConstraint()
        } else {
            setupLandscapeConstraint()
        }
    }

    func setupOrientationConstraint() {
        //photoImageView
        let viewsDictionary = ["image": photoImageView,  "description": descriptionLabel]
        let marginsDictionary = ["leftMargin": 10, "rightMargin": 10, "viewSpacing": 10]
        let constraintImageHor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[image]-rightMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: marginsDictionary, views: viewsDictionary)
        let constraintImageTop = NSLayoutConstraint.constraints(withVisualFormat: "V:|-74-[image]", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDictionary)
        let constraintImageSize = NSLayoutConstraint(item: photoImageView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 3/7, constant: 0)
        view.addConstraints(constraintImageHor)
        view.addConstraints(constraintImageTop)
        view.addConstraint(constraintImageSize)
        
        //descriptionLabel
        let bottomMargin: CGFloat = 100
        let constraintDesHor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[description]-rightMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: marginsDictionary, views: viewsDictionary)
        view.addConstraints(constraintDesHor)
        let constraintDesBottom = NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -bottomMargin)
        view.addConstraint(constraintDesBottom)
    }
    
    func setupLandscapeConstraint() {
        //photoImageView
        let viewsDictionary = ["image": photoImageView,  "description": descriptionLabel]
        let marginsDictionary = ["leftMargin": 10, "rightMargin": 10, "viewSpacing": 10]
        let constraintImageHor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[image]", options: NSLayoutFormatOptions(rawValue: 0), metrics: marginsDictionary, views: viewsDictionary)
        let constraintImageTop = NSLayoutConstraint.constraints(withVisualFormat: "V:|-65-[image]", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: viewsDictionary)
        let constraintImageSize = NSLayoutConstraint(item: photoImageView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 3/7, constant: 0)
        view.addConstraint(constraintImageSize)
        view.addConstraints(constraintImageHor)
        view.addConstraints(constraintImageTop)
        let constraintImageBottom = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -10)
        view.addConstraint(constraintImageBottom)
        
        //descriptionLabel
        let constraintDesHor = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftMargin-[image]-viewSpacing-[description]-rightMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: marginsDictionary, views: viewsDictionary)
        view.addConstraints(constraintDesHor)
        let constraintDesY = NSLayoutConstraint(item: descriptionLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)
        view.addConstraint(constraintDesY)
    }
    
    //MARK: orientation
    @objc func orientationChanged(_ notification: Notification) {
        setupConstraint()
        view.updateConstraints()
    }
    
}
