//
//  CMPhotosTests.swift
//  CMPhotosTests
//
//  Created by Guxiaojie on 17/03/2018.
//  Copyright © 2018 SageGu. All rights reserved.
//

import XCTest
@testable import CMPhotos
@testable import SwiftyJSON

class CMPhotosTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testTitleExitsFromMockData() {
        let canada: Canada = self.mockData()
        let viewController = ViewController(canada: canada)
        XCTAssertNil(viewController.title);
    }
    
    func testCollectionViewExistsWhenNoData() {
        let canada = Canada()
        let viewController = ViewController(canada: canada)
        XCTAssertNotNil(viewController.collectionView);
    }

    //MARK: Test Details View Controller
    
    func testDetailsViewExistsWhenNoData() {
        let viewController = DetailsViewController()
        XCTAssertNotNil(viewController.view);
    }

//    func testDetailsImageViewExistsWhenNoData() {
//        let photo: Photo?
//        let viewController = DetailsViewController(photo: photo!)
//        XCTAssertNotNil(viewController.photoImageView);
//    }

    //MARK: Data
    
    func mockData() -> Canada{
        let canada = Canada()
        canada.title = "a"
        canada.rows = []
        return canada
    }
}
