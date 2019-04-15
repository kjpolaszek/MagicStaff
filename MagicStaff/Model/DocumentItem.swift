//
//  DocumentItem.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import Foundation

struct DocumentItem: Document, Decodable {
    
    var thumbnailImg: String
    
    var id: Int
    
    var author: String
    
    var text: String
    
    var created: Date
    
    var headerImg: String
    
    var title: String
    
    var category: String
    
}
