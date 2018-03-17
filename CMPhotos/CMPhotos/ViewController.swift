//
//  ViewController.swift
//  CMPhotos
//
//  Created by Guxiaojie on 14/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    var collectionView: UICollectionView!
    private var cellSizeCache = NSCache<AnyObject, AnyObject>()

    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var canada = Canada()
    var isLoading: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
        self.view.backgroundColor = UIColor.white
        commonInit()
        setupConstraint()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.orientationChanged(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    convenience init(canada: Canada) {
        self.init()
        
        self.canada = canada
        self.collectionView.reloadData()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    func commonInit() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ViewController.refresh))
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        
        view.addSubview(indicatorView)
        
        //here for a better UI while loading data
        collectionView.isHidden = true;
        indicatorView.hidesWhenStopped = true;
        
    }
    
    func setupConstraint() {
        //constraint collectionView
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        let viewsDictionary = ["contentView": collectionView] as [String : Any]
        let constraintV = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[contentView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let constraintH = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[contentView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        view.addConstraints(constraintH)
        view.addConstraints(constraintV)
        
        //constraint indicatorView
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false;
        let constraintX = NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let constraintY = NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)
        view.addConstraint(constraintX)
        view.addConstraint(constraintY)
    }
    
    //MARK: Load Data
    
    func loadData() {
        isLoading = true
        indicatorView.startAnimating()
        PhotoRequest.downloadData {
            [weak self]
            (canada, error) in
            if let strongSelf = self {
                if error != nil {
                    strongSelf.canada = Canada()
                    DispatchQueue.main.async {
                        strongSelf.collectionView.isHidden = true
                        strongSelf.indicatorView.stopAnimating()
                    }
                } else {
                    if let canada = canada {
                        strongSelf.canada = canada
                    }
                    DispatchQueue.main.async {
                        strongSelf.collectionView.isHidden = false
                        strongSelf.collectionView.reloadData()
                        strongSelf.indicatorView.stopAnimating()
                        
                        strongSelf.title = strongSelf.canada.title ?? "No Title"                        
                    }
                }
                strongSelf.isLoading = false
            }
        }
    }
    
    //MARK: Actions
    
    @objc func refresh() {
        if isLoading {
            //here shold be a Toast Say "Data is loading..."
            print("Data is loading!!🧐")
        } else {
            loadData()
        }
    }
    
    //MARK: orientation
    
    @objc func orientationChanged(_ notification: Notification) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return canada.rows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCollectionViewCell
        guard let rows = self.canada.rows else {
            return cell
        }
        if indexPath.row < rows.count {
            cell.reloadData(photo: rows[indexPath.row])
        }
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let rows = self.canada.rows else {
            return
        }
        if indexPath.row < rows.count {
            let viewController = DetailsViewController(photo: rows[indexPath.row])
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let size = cellSizeCache.object(forKey: indexPath as AnyObject) as? NSValue {
            return size.cgSizeValue
        }
        //update with UIInterfaceOrientation change
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 100
        guard let rows = self.canada.rows else {
            return CGSize(width: width, height: height)
        }
        
        var finalSize = CGSize(width: width, height: height)
        if indexPath.row < rows.count {
            let photo = rows[indexPath.row]
            
            //download image data, then reloadItems
            PhotoCollectionViewCell.estimateHeight(photo: photo, index: indexPath) { (ratio, returnIndex) in
                
                let size = CGSize(width: width, height: ratio*width)
                
                if let aReturnIndex = returnIndex {
                    // Cache it
                    let value = NSValue.init(cgSize: size)
                    self.cellSizeCache.setObject(value, forKey: aReturnIndex as AnyObject)
                    
                    collectionView.reloadItems(at: [aReturnIndex])
                } else {
                    finalSize = size;
                }
            }
        }
        return finalSize
    }

}


