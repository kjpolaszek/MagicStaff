//
//  SimpleDocumentItem.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import Foundation

struct SimpleDocumentItem: SimpleDocument, Decodable {
    
    var id: Int
    
    var title: String
    
    var category: String
    
    var thumbnailImg: String
    
}
