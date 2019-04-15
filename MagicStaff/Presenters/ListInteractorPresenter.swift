//
//  ListInteractorPresenter.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import Foundation

protocol ListInteractorPresenter: class {
    
    func startLoading(message: String?)
    func endLoading()
    func dataLoadedSuccessfull()
    func dataLoadedError(message: String)
    func showDetailFor(document: Document)
    func reloadCellAt(index: IndexPath)
    
}
