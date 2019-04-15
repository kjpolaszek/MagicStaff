//
//  Backend.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import Foundation
import Result

enum NetworkError: String, Error {
    case networkError = "Something goes wrong. Please try again later"
    case jsonError = "Error in parse JSON"
    case missingData = "Missing Data"
}

protocol Network {
    
    func getDocuments( complete: @escaping (Result<[SimpleDocument],NetworkError>) -> Void)
    
    func getDocumentDetail(id: Int, complete: @escaping (Result<Document,NetworkError>) -> Void)
    
    func getImage(from url: URL, complete: @escaping (Result<Data,NetworkError>) -> Void)
    
}
