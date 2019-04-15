//
//  DocumentApi.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 15/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import Foundation

enum DocumentApi: EndpointType {
    
    case documents
    case document(id: Int)
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .documents:
            return "documents"
        case .document(let id):
            return "documents/\(id)"
        }
    }
    
}
