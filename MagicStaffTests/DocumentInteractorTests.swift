//
//  DocumentInteractorTests.swift
//  MagicStaffTests
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import XCTest
import Result
@testable import MagicStaff

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: UIGraphicsImageRendererFormat(for: .init(displayScale: 1.0))).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

fileprivate class NetworkMock: Network {
    
    enum TestCase {
        case error
        case none
        case zeroElements
        case oneElement
        case twoElementsInOneSection
        case twoElementsInTowSections
        case oneElementForTwoSections
    }
    
    var getImageCallCount = 0
    
    var testCase: TestCase = .none
    
    var imageData: Data! = Data()
    
    var documents: [SimpleDocument]? {
        switch testCase {
        case .none, .error:
            return nil
        case .zeroElements:
            return []
        case .oneElementForTwoSections:
            return [SimpleDocumentItem(id: 1, title: "First Element", category: "Apple", thumbnailImg: "url"),
                    SimpleDocumentItem(id: 2, title: "Second Element", category: "Tomato", thumbnailImg: "url")
            ]
        case .twoElementsInOneSection:
            return [SimpleDocumentItem(id: 1, title: "First Element", category: "Apple", thumbnailImg: "url"),
                    SimpleDocumentItem(id: 2, title: "Second Element", category: "Apple", thumbnailImg: "url")]
        case .twoElementsInTowSections:
            return [
                SimpleDocumentItem(id: 1, title: "First Element", category: "Apple", thumbnailImg: "url"),
                SimpleDocumentItem(id: 2, title: "Second Element", category: "Apple", thumbnailImg: "url"),
                SimpleDocumentItem(id: 3, title: "First Element", category: "Tomato", thumbnailImg: "url"),
                SimpleDocumentItem(id: 4, title: "Second Element", category: "Tomato", thumbnailImg: "url")
            ]
        case .oneElement:
            return [SimpleDocumentItem(id: 1, title: "First Element", category: "Apple", thumbnailImg: "http://localhost/image")]
        }
    }
    
    func getDocuments(complete: (Result<[SimpleDocument], NetworkError>) -> Void) {
        if let documents = documents {
            complete(.success(documents))
        } else {
            if case .error = testCase {
                complete(.failure(.missingData))
            }
        }
    }
    
    func getDocumentDetail(id: Int, complete: (Result<Document, NetworkError>) -> Void) {
        if case .error = testCase {
            complete(.failure(.networkError))
            return
        }
        complete(.success(DocumentItem(thumbnailImg: "Image", id: 1, author: "Author", text: "Text", created: Date(), headerImg: "HeaderImage", title: "Title", category: "Category")))
    }
    
    func getImage(from url: URL, complete: @escaping (Result<Data, NetworkError>) -> Void) {
        getImageCallCount += 1
        complete(.success(imageData))
    }
    
}

fileprivate class ListPresenterMock: ListInteractorPresenter {
    
    var startLoadingCallCount = 0
    var endLoadingCallCount = 0
    var dataLoadedSuccessfullCallCount = 0
    var dataLoadedErrorCallCount = 0
    var showDetailForDocumentCallCount = 0
    
    func startLoading(message: String?) {
        startLoadingCallCount += 1
    }
    
    func endLoading() {
        endLoadingCallCount += 1
    }
    
    func dataLoadedSuccessfull() {
        dataLoadedSuccessfullCallCount += 1
    }
    
    func dataLoadedError(message: String) {
        dataLoadedErrorCallCount += 1
    }
    
    func showDetailFor(document: Document) {
        showDetailForDocumentCallCount += 1
    }
}

class DocumentInteractorTests: XCTestCase {

    private var sut: DocumentsInteractor!
    private var network: NetworkMock!
    private var presenter: ListPresenterMock!
    
    override func setUp() {
        network = NetworkMock()
        presenter = ListPresenterMock()
        sut = DocumentsInteractor(network: network)
        sut.setPresenter(presenter)
    }

    func testNumberOfSectionsShouldBeOne() {
        network.testCase = .oneElement
        sut.loadData()
        let sections = sut.getNumberOfSections()
        XCTAssertEqual(sections, 1)
    }
    
    func testNumberOfItemsShouldBeTwo() {
        network.testCase = .twoElementsInOneSection
        sut.loadData()
        let items = sut.getNumberOfItemsFor(section: 0)
        XCTAssertEqual(items, 2)
    }
    
    func testNumberOfSectionsShouldBeTwo() {
        network.testCase = .oneElementForTwoSections
        sut.loadData()
        let sections = sut.getNumberOfSections()
        XCTAssertEqual(sections, 2)
    }
    
    func testNumberOfItemsWhenNumberOfSectionIsOutOfRange() {
        network.testCase = .oneElement
        sut.loadData()
        XCTAssertEqual(sut.getNumberOfItemsFor(section: 3), 0)
    }
    
    func testTitleForFirstDocumentElement() {
        network.testCase = .oneElement
        sut.loadData()
        let title = sut.getTitle(for: .init(row: 0, section: 0))
        XCTAssertEqual(title, "First Element")
    }

    func testProtectionForIndexOutOfRange() {
        network.testCase = .oneElement
        sut.loadData()
        let title = sut.getTitle(for: .init(row: 1, section: 1))
        XCTAssertEqual(title, "")
    }
    
    func testImageForFirstElement() {
        network.testCase = .oneElement
        network.imageData = UIColor.white.image(.init(width: 1, height: 1)).pngData()
        sut.loadData()
        let testImage = sut.getImage(for: .init(row: 0, section: 0))
        XCTAssertEqual(testImage.value?.pngData(), network.imageData)
    }
    
    func testImageCachingForFirstElement() {
        network.testCase = .oneElement
        network.imageData = UIColor.white.image(.init(width: 1, height: 1)).pngData()
        sut.loadData()
        let firstIndex = IndexPath(row: 0, section: 0)
        _ = sut.getImage(for: firstIndex)
        let image = sut.getImage(for: firstIndex)
        XCTAssertEqual(image.value?.pngData(), network.imageData)
        XCTAssertEqual(network.getImageCallCount, 1)
    }
    
    func testGettingImageForIndexOutOfRange() {
        network.testCase = .oneElement
        network.imageData = UIColor.white.image(.init(width: 1, height: 1)).pngData()
        sut.loadData()
        let image = sut.getImage(for: .init(row: 1, section: 1))
        XCTAssertEqual(image.value, nil)
    }
    
    func testSectionTitleForSecondSection() {
        network.testCase = .twoElementsInTowSections
        sut.loadData()
        XCTAssertEqual(sut.getSectionTitle(for: 1), "Tomato")
    }
    
    func testSectionTitleForIndexOutOfRange() {
        network.testCase = .oneElement
        sut.loadData()
        XCTAssertEqual(sut.getSectionTitle(for: 1), nil)
    }
    
    func testFirstElementIsSelected() {
        network.testCase = .oneElement
        sut.loadData()
        sut.didSelectItemAt(index: .init(row: 0, section: 0))
        XCTAssertEqual(presenter.showDetailForDocumentCallCount, 1)
    }
    
    func testLoadingWhenModelStartLoadingDataAndWaitingForResponse() {
        network.testCase = .none
        sut.loadData()
        XCTAssertEqual(presenter.startLoadingCallCount, 1)
        XCTAssertEqual(presenter.dataLoadedErrorCallCount, 0)
        XCTAssertEqual(presenter.dataLoadedSuccessfullCallCount, 0)
    }
    
    func testErrorNetwork() {
        network.testCase = .error
        sut.loadData()
        XCTAssertEqual(presenter.startLoadingCallCount, 1)
        XCTAssertEqual(presenter.dataLoadedSuccessfullCallCount, 0)
        XCTAssertEqual(presenter.dataLoadedErrorCallCount, 1)
    }
    
    
}
