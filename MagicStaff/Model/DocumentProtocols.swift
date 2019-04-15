//
//  Document.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import Foundation

protocol TitleProtocol {
    var title: String { get }
}

protocol CategoryProtocol {
    var category: String { get }
}

protocol ThumbnailProtocol {
    var thumbnailImg: String { get }
}

protocol AuthorProtocol {
    var author: String { get }
}

protocol TextProtocol {
    var text: String { get }
}

protocol CreatedAtProtocol {
    var created: Date { get }
}

protocol HeaderImageProtocol {
    var headerImg: String { get }
}

protocol PoorDocument: TitleProtocol, CategoryProtocol, ThumbnailProtocol {
    var id: Int { get }
}

protocol Document: PoorDocument, AuthorProtocol, TextProtocol, CreatedAtProtocol, HeaderImageProtocol {
    
}

