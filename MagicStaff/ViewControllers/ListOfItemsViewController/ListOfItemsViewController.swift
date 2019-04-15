//
//  ListOfItemsViewController.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import UIKit
import Kingfisher

class ListOfItemsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var interactor: DocumentInteractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        interactor = DocumentInteractorImp(backend: BackendImp())
        interactor.setPresenter(self)
        interactor.loadData()
        self.view.backgroundColor = .white
    }
    
}

extension ListOfItemsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ListOfItemsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getNumberOfItemsFor(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.imageView?.image = #imageLiteral(resourceName: "empty_image")
        cell.imageView?.kf.setImage(with: interactor.getImageURL(for: indexPath))
        cell.textLabel?.text = interactor.getTitle(for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return interactor.getSectionTitle(for: section)
    }
}

extension ListOfItemsViewController: DocumentInteractorPresenter {
    
    func startLoadingData() {
        
    }
    
    func dataLoadedSuccessfull() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func dataLoadedError(message: String) {
        
    }
    
}
