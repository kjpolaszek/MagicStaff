//
//  DocumentDetailInteractorTests.swift
//  MagicStaffTests
//
//  Created by Karol Polaszek on 15/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import XCTest
@testable import MagicStaff
class DocumentDetailInteractorTests: XCTestCase {

    var sut: DocumentDetailInteractorImp!
    var networkMock: NetworkMock!
    
    override func setUp() {
        networkMock = NetworkMock()
        let document = DocumentItem(thumbnailImg: "ThumbImage", id: 1, author: "Author", text: "Text", created: Date(), headerImg: "HeaderImg", title: "Title", category: "Category")
        sut = DocumentDetailInteractorImp(document: document, network: networkMock)
    }
    
    func testTitleForDocument() {
        XCTAssertEqual(sut.getDocumentTitle(), "Title")
    }
    
    func testAuthorForDocument() {
        XCTAssertEqual(sut.getDocumentAuthor(), "Author")
    }
    
    func testCategoryForDocument() {
        XCTAssertEqual(sut.getDocumentCategory(), "Category")
    }
    
    func testTextForDocument() {
        XCTAssertEqual(sut.getDocumentText(), "Text")
    }
    
    func testHeaderImageForDocument() {
        networkMock.imageData = UIColor.white.image(.init(width: 1, height: 1)).pngData()
        XCTAssertEqual(sut.getDocumentHeaderImage().value?.pngData(), networkMock.imageData)
    }


}
