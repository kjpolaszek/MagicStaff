//
//  BackendTests.swift
//  MagicStaffTests
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import XCTest
@testable import MagicStaff

class BackendTests: XCTestCase {

    var sut: Backend!
    
    override func setUp() {
        sut = BackendImp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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

}
