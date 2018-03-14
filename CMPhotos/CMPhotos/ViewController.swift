//
//  ViewController.swift
//  CMPhotos
//
//  Created by Guxiaojie on 14/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    var collectionView: UICollectionView!
    var layout: PhotoCollectionViewLayout!
    
    let refresButton = UIButton()//Mean to show  when no data(not finish)
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "Cell")
        //view.addSubview(tableView)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.bounds.width, height: 300)

        layout = PhotoCollectionViewLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        
        view.addSubview(indicatorView)
        
        // just for a better UI while loading data
        tableView.isHidden = true;
        indicatorView.hidesWhenStopped = true;
        
    }
    
    func setupConstraint() {
        //constraint tableview
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        let viewsDictionary = ["contentView": collectionView, "button": refresButton] as [String : Any]
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
    
    //MARK: ViewController
    
    convenience init(canada: Canada) {
        self.init()
        
        self.canada = canada
        self.tableView.reloadData()
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
                        strongSelf.tableView.isHidden = true
                        strongSelf.indicatorView.stopAnimating()
                    }
                } else {
                    if let canada = canada {
                        strongSelf.canada = canada
                    }
                    DispatchQueue.main.async {
                        strongSelf.tableView.isHidden = false
                        strongSelf.tableView.reloadData()
                        strongSelf.indicatorView.stopAnimating()
                        
                        strongSelf.title = strongSelf.canada.title ?? "No Title"
                        
                        strongSelf.collectionView.reloadData()
                        
                    }
                }
                strongSelf.isLoading = false
            }
        }
    }
    
    //MARK: Table View Delegate/DataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canada.rows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PhotoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PhotoTableViewCell
        if let rows = self.canada.rows {
            if indexPath.row < rows.count {
                cell.reloadData(photo: rows[indexPath.row])
            }
        }
        return cell
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
    
}

extension ViewController: UICollectionViewDataSource {
    
    //MARK: CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return canada.rows?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCollectionViewCell
        if let rows = self.canada.rows {
            if indexPath.row < rows.count {
                cell.reloadData(photo: rows[indexPath.row])
            }
        }
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
}


