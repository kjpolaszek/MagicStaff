//
//  ControllerFactory.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 15/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import UIKit

struct ControllerFactory {
    
    static func createListOfDocumentController() -> UIViewController {
         return ListOfItemsViewController(interactor: DocumentsInteractor(network: Current.network))
    }
    
    static func createDocumentDetailController(for document: Document) -> UIViewController {
        return DocumentDetailViewController(interactor: DocumentDetailInteractorImp(document: document, network: Current.network))
    }
    
}
