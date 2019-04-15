//
//  ListOfItemsViewController.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import UIKit

class ListOfItemsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingText: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let interactor: ListInteractor
    
    private var selectedIndex: IndexPath?
    
    init(interactor: ListInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTitle()
        configureTableCells()
        setupInteractorAndLoadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let index = selectedIndex {
            tableView.deselectRow(at: index, animated: true)
            selectedIndex = nil
        }
    }
    
    private func configureTitle() {
        navigationItem.title = "Magic Staff"
    }
    
    private func setupInteractorAndLoadData() {
        interactor.setPresenter(self)
        interactor.loadData()
    }
    
    private func configureTableCells() {
        tableView.register(UINib.init(nibName: "SimpleDocumentCellView", bundle: nil), forCellReuseIdentifier: "simpleView")
    }
    
}

extension ListOfItemsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        interactor.didSelectItemAt(index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "simpleView", for: indexPath) as? SimpleDocumentCellView {
            cell.pictureView.setAsyncImage(image:  interactor.getImage(for: indexPath))
            cell.titleLbl.text = interactor.getTitle(for: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return interactor.getSectionTitle(for: section)
    }
}

extension ListOfItemsViewController: ListInteractorPresenter {
    
    func startLoading(message: String?) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.loadingText.text = message ?? "Wait for loading ..."
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }
    }
    
    func endLoading() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
        }
    }
    
    func dataLoadedSuccessfull() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.tableView.reloadData()
        }
        
    }
    
    func dataLoadedError(message: String) {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = true
            self.loadingText.text = "Something goes wrong. Please restart app."
            self.loadingView.isHidden = false
        }
    }
    
    func showDetailFor(document: Document) {
        DispatchQueue.main.async {
            let detailController = ControllerFactory.createDocumentDetailController(for: document)
            self.navigationController?.pushViewController(detailController, animated: true)
        }
    }
    
}
