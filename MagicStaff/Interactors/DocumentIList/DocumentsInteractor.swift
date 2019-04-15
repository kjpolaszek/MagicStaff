//
//  DocumentInteractorImp.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import UIKit

fileprivate class DocumentSection {
    
    private(set) var title: String
    private(set) var documents: [SimpleDocument] = []
    
    subscript(index: Int) -> SimpleDocument {
        get { return documents[index] }
        set { documents[index] = newValue }
    }
    
    init(title: String, documents: [SimpleDocument]) {
        self.title = title
        self.documents = documents
    }
    
    func addDocument(_ document: SimpleDocument) {
        if !documents.contains(where: { document.id == $0.id }) {
            documents.append(document)
        }
    }
}

class DocumentsInteractor: ListInteractor {

    private var network: Network
    
    private var documents: [SimpleDocument] = []
    
    private var sections: [DocumentSection] = []
    
    private var images: [IndexPath: AsyncImage] = [:]
    
    private weak var presenter: ListInteractorPresenter?
    
    init(network: Network) {
        self.network = network
    }
    
    func getNumberOfItemsFor(section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        return sections[section].documents.count
    }
    
    func getNumberOfSections() -> Int {
        return sections.count
    }
    
    func setPresenter(_ presenter: ListInteractorPresenter?) {
        self.presenter = presenter
    }
    
    func getImage(for index: IndexPath) -> AsyncImage {
        if let image = images[index] {
            return image
        }
        return fetchAndUpdateImage(for: index)
    }
    
    func loadData() {
        self.presenter?.startLoading(message: nil)
        self.network.getDocuments {[weak self] (results) in
            switch results {
            case .success(let documents):
                self?.sections = self?.mapDocumentsToSections(documents) ?? []
                self?.presenter?.dataLoadedSuccessfull()
            case .failure(let error):
                self?.presenter?.dataLoadedError(message: error.rawValue)
            }
        }
    }
    
    func getTitle(for index: IndexPath) -> String {
        guard checkIndexPathIsValid(index) else {
            return ""
        }
        return sections[index.section][index.row].title
    }
    
    func getSectionTitle(for section: Int) -> String? {
        return sections[section].title
    }
    
    func didSelectItemAt(index: IndexPath) {
        let id = getDocumentId(for: index)
        self.presenter?.startLoading(message: "Loading document ...")
        network.getDocumentDetail(id: id) {[weak self] (result) in
            switch result {
            case .success(let document):
                self?.presenter?.showDetailFor(document: document)
            default:
                break
            }
            self?.presenter?.endLoading()
        }
    }
    
    private func fetchAndUpdateImage(for index: IndexPath) -> AsyncImage {
        let asyncImage = AsyncImage(image: #imageLiteral(resourceName: "empty_image"))
        self.images[index] = asyncImage
        if let url = getImageURL(for: index) {
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
        }
        return asyncImage
    }
    
    private func getImageURL(for index: IndexPath) -> URL? {
        guard checkIndexPathIsValid(index) else {
            return nil
        }
        return URL(string: sections[index.section][index.row].thumbnailImg)
    }
    
    private func getDocumentId(for index: IndexPath) -> Int {
        guard checkIndexPathIsValid(index) else {
            return 0
        }
        return sections[index.section][index.row].id
    }
    
    private func mapDocumentsToSections(_ documents: [SimpleDocument]) -> [DocumentSection] {
        var sections: [DocumentSection] = []
        for document in documents {
            if let section = sections.first(where: { $0.title == document.category }) {
                section.addDocument(document)
            }  else {
                sections.append(DocumentSection(title: document.category, documents: [document]))
            }
        }
        return sections
    }
    
    private func checkIndexPathIsValid(_ indexPath: IndexPath) -> Bool {
        guard indexPath.section < sections.count, indexPath.row < sections[indexPath.section].documents.count else {
            return false
        }
        return true
    }
    
}




