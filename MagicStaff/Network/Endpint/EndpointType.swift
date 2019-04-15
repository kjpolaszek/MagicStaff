//
//  EndpointType.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 14/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol EndpointType {
    var path: String { get }
    var method: HTTPMethod { get }
}
