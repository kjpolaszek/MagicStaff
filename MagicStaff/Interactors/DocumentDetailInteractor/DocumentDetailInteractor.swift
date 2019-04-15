//
//  DocumentDetailInteractor.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 14/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import Foundation

protocol DocumentDetailInteractor {
    
    func getDocumentTitle() -> String
    func getDocumentAuthor() -> String
    func getDocumentCategory() -> String
    func getDocumentText() -> String
    func getDocumentHeaderImage() -> AsyncImage
    
}
