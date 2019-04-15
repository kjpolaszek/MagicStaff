//
//  DocumentDetailInteractorImp.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 14/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import UIKit

class DocumentDetailInteractorImp: DocumentDetailInteractor {
    
    private var document: Document
    private var network: Network
    
    init(document: Document, network: Network) {
        self.document = document
        self.network = network
    }
    
    func getDocumentTitle() -> String {
        return document.title
    }
    
    func getDocumentAuthor() -> String {
        return document.author
    }
    
    func getDocumentCategory() -> String {
        return document.category
    }
    
    func getDocumentText() -> String {
        return document.text
    }
    
    func getDocumentHeaderImage() -> AsyncImage {
        let url = URL(string: document.headerImg)!
        let asyncImage = AsyncImage(placeholder: #imageLiteral(resourceName: "empty_image_large"))
        network.getImage(from: url) { (result) in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    asyncImage.update(image)
                }
            default:
                break
            }
        }
        return asyncImage
    }
    
    
    
    
}
