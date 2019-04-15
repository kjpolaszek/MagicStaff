//
//  NetworkWorker.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import Foundation
import Result

extension JSONDecoder {
    static func defaultDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
}

class NetworkWorker: Network {
    
    func getDocuments(complete: @escaping (Result<[SimpleDocument], NetworkError>) -> Void) {
        makeRequestAndCreateObject(for: DocumentApi.documents, type: DocumentsContainer.self) { (result) in
            switch result {
            case .success(let object):
                complete(.success(object.documents))
            case .failure(let error):
                complete(.failure(error))
            }
        }
    }
    
    func getDocumentDetail(id: Int, complete: @escaping (Result<Document, NetworkError>) -> Void) {
        makeRequestAndCreateObject(for: DocumentApi.document(id: id), type: DocumentItem.self) { (result) in
            switch result {
            case .success(let object):
                complete(.success(object))
            case .failure(let error):
                complete(.failure(error))
            }
        }

    }
    
    func getImage(from url: URL, complete: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                complete(.failure(.missingData))
                return
            }
            complete(.success(data))
        }.resume()
    }
    
    private func makeRequestAndCreateObject<T>(for endpoint: EndpointType, type: T.Type, complete: @escaping (Result<T,NetworkError>) -> Void) where T: Decodable {
        let url = API.BaseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 5)
        request.httpMethod = endpoint.method.rawValue
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                complete(.failure(.networkError))
                return
            }
            if let data = data {
                do {
                    let object = try JSONDecoder.defaultDecoder().decode(type, from: data)
                    complete(.success(object))
                } catch {
                    complete(.failure(.jsonError))
                }
                return
            }
            complete(.failure(.missingData))
        }
        task.resume()
    }
    
}
