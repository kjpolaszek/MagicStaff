//
//  DocumentDetailViewController.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import UIKit

class DocumentDetailViewController: UIViewController {
    
    @IBOutlet var headerImage: UIAsyncImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var authorLbl: UILabel!
    @IBOutlet var textLbl: UILabel!
    
    private let interactor: DocumentDetailInteractor
    
    init(interactor: DocumentDetailInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent()
    }
    
    private func setupContent() {
        title = interactor.getDocumentCategory()
        headerImage.setAsyncImage(image: interactor.getDocumentHeaderImage())
        titleLbl.text = interactor.getDocumentTitle()
        authorLbl.text = interactor.getDocumentAuthor()
        textLbl.attributedText = createAttributedString(from: interactor.getDocumentText())
    }
    
    private func createAttributedString(from htmlText: String) -> NSAttributedString {
        if let data = htmlText.data(using: .unicode) {
            do {
            return try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
            } catch {
                
            }
        }
        return NSAttributedString(string: htmlText)
    }
    
}
