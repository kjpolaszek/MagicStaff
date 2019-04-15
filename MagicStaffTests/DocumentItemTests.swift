//
//  DocumentItemTests.swift
//  MagicStaffTests
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import XCTest
@testable import MagicStaff

class DocumentItemTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDocumentItemCreatedFromJSON() {
        let json = """
            {"category": "Nature",
            "author": "Velit Purus",
            "text": "Text", "title": "Velit purus litora at dictumst rutrum duis erat amet ridiculus ligula sagittis non nonummy dictumst lectus taciti",
            "id": 129,
            "created": "2019-04-13T21:03:28.521685",
            "headerImg": "http://lorempixel.com/400/300/nature/Velit%20purus%20litora%20at%20dictumst%20rutrum%20duis%20erat%20amet%20ridiculus%20ligula%20sagittis%20non%20nonummy%20dictumst%20lectus%20taciti",
            "thumbnailImg": "http://lorempixel.com/100/100/nature"
            }
        """
        let data = Data(json.utf8)
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        decoder.dateDecodingStrategy = .formatted(formatter)
        do {
            let document = try decoder.decode(DocumentItem.self, from: data)
            XCTAssertEqual(document.category, "Nature")
        } catch {
            XCTAssertThrowsError(error)
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
