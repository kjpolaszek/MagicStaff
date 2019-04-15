//
//  ListInteractor.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import UIKit

protocol ListInteractor {
    
    func setPresenter(_ presenter: DocumentInteractorPresenter?)
    func loadData()
    func getNumberOfItemsFor(section: Int) -> Int
    func getNumberOfSections() -> Int
    func getSectionTitle(for section: Int) -> String?
    func getTitle(for index: IndexPath) -> String
    func getImage(for index: IndexPath) -> AsyncImage
    func didSelectItemAt(index: IndexPath)
    
}
