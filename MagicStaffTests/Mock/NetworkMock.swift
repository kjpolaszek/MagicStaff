//
//  NetworkMock.swift
//  MagicStaffTests
//
//  Created by Karol Polaszek on 15/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import Foundation
import Result
@testable import MagicStaff

class NetworkMock: Network {
    
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
    
    var document: Document = DocumentItem(thumbnailImg: "Image", id: 1, author: "Author", text: "Text", created: Date(), headerImg: "HeaderImage", title: "Title", category: "Category")
    
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
        complete(.success(document))
    }
    
    func getImage(from url: URL, complete: @escaping (Result<Data, NetworkError>) -> Void) {
        getImageCallCount += 1
        complete(.success(imageData))
    }
    
}
